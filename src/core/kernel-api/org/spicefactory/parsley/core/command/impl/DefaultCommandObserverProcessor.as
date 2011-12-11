/*
 * Copyright 2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.spicefactory.parsley.core.command.impl {

import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.logging.LogUtil;
import org.spicefactory.parsley.core.command.CommandObserverProcessor;
import org.spicefactory.parsley.core.command.CommandStatus;
import org.spicefactory.parsley.core.command.ObservableCommand;
import org.spicefactory.parsley.core.messaging.MessageReceiverCache;
import org.spicefactory.parsley.core.messaging.MessageSettings;
import org.spicefactory.parsley.core.messaging.impl.DefaultMessageProcessor;
import org.spicefactory.parsley.core.messaging.impl.MessageReceiverKind;
import org.spicefactory.parsley.core.messaging.receiver.CommandObserver;

/**
 * Default implementation of the CommandObserverProcessor interface.
 * 
 * @author Jens Halm
 */
public class DefaultCommandObserverProcessor extends DefaultMessageProcessor implements CommandObserverProcessor {
	
	
	private var observable:ObservableCommand;
	private var _status:CommandStatus;
	private var _result:Object;
	
	private var typeCache:MessageReceiverCache;
	

	/**
	 * Creates a new instance.
	 * 
	 * @param observable the command to handle observers for
	 * @param typeCache the receiver selection cache corresponding to the command type
	 * @param triggerCache the receiver selection cache corresponding to the type of the trigger message
	 * @param settings the settings for this processor
	 */
	function DefaultCommandObserverProcessor (observable:ObservableCommand, typeCache:MessageReceiverCache, 
			triggerCache:MessageReceiverCache, settings:MessageSettings) {
		super(observable.trigger, triggerCache, settings, invokeObserver);
		this.typeCache = typeCache;
		this.observable = observable;
		_status = observable.status;
		_result = observable.result;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get command () : Object {
		return observable.command;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get result () : Object {
		return _result;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get status () : CommandStatus {
		return _status;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get root () : Boolean {
		return observable.root;
	}
	
	/**
	 * @inheritDoc
	 */
	public function changeResult (result:Object, error:Boolean = false) : void {
		if (status == CommandStatus.EXECUTE) {
			throw new IllegalStateError("Cannot set the result while command is still executing");
		}
		_result = result;
		_status = (error) ? CommandStatus.ERROR : CommandStatus.COMPLETE;
	}

	/**
	 * @private
	 */
	protected override function getLogString (action:String, receiverCount:int) : String {
		return LogUtil.buildLogMessage("{0} message '{1}' for command status '{2}' to {3} observer(s)", 
				[action, message, status, receiverCount]);
	}
	
	private function invokeObserver (observer:CommandObserver) : void {
		var oldStatus:CommandStatus = status;
		observer.observeCommand(this);
		if (oldStatus != status && oldStatus != CommandStatus.EXECUTE) {
			rewind();
		}
	}
	
	/**
	 * @private
	 */
	protected override function fetchReceivers () : Array {	
		var receivers:Array = typeCache.getReceivers(MessageReceiverKind.forCommandStatus(status, false), observable.id);
		return (observable.trigger) ?
			receivers.concat(cache.getReceivers(MessageReceiverKind.forCommandStatus(status, true), 
					observable.trigger.selector))
			: receivers;
	}
	
	
}
}

