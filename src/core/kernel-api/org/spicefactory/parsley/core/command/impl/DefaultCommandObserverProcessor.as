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
	
	
	private var _command:ObservableCommand;
	private var _status:CommandStatus;
	private var _result:Object;
	

	/**
	 * Creates a new instance.
	 * 
	 * @param command the command to handle observers for
	 * @param cache the receiver selection cache corresponding to the messageType
	 * @param settings the settings for this processor
	 * @param result the result of the command
	 * @param status the status to handle the matching observers for
	 */
	function DefaultCommandObserverProcessor (command:ObservableCommand, cache:MessageReceiverCache, 
			settings:MessageSettings) {
		super(command.trigger, cache, settings, invokeObserver);
		_command = command;
		_status = command.status;
		_result = command.result;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get command () : Object {
		return _command.command;
	}
	
	public function get result () : Object {
		return _result;
	}
	
	public function get status () : CommandStatus {
		return _status;
	}
	
	public function changeResult (result:Object, error:Boolean = false) : void {
		if (status == CommandStatus) {
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
		return cache.getReceivers(command.trigger, MessageReceiverKind.forCommandStatus(status));
	}
	
	
}
}

