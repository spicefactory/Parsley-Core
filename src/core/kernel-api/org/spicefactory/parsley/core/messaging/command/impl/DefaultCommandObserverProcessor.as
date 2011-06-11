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

package org.spicefactory.parsley.core.messaging.command.impl {
import org.spicefactory.lib.logging.LogUtil;
import org.spicefactory.parsley.core.messaging.MessageReceiverCache;
import org.spicefactory.parsley.core.messaging.MessageSettings;
import org.spicefactory.parsley.core.messaging.command.Command;
import org.spicefactory.parsley.core.messaging.command.CommandObserverProcessor;
import org.spicefactory.parsley.core.messaging.command.CommandStatus;
import org.spicefactory.parsley.core.messaging.impl.DefaultMessageProcessor;
import org.spicefactory.parsley.core.messaging.impl.MessageReceiverKind;
import org.spicefactory.parsley.core.messaging.receiver.CommandObserver;

/**
 * Default implementation of the CommandObserverProcessor interface.
 * 
 * @author Jens Halm
 */
public class DefaultCommandObserverProcessor extends DefaultMessageProcessor implements CommandObserverProcessor {
	
	
	private var _command:Command;
	private var status:CommandStatus;
	

	/**
	 * Creates a new instance.
	 * 
	 * @param command the command to handle observers for
	 * @param cache the receiver selection cache corresponding to the messageType
	 * @param settings the settings for this processor
	 * @param status the status to handle the matching observers for
	 */
	function DefaultCommandObserverProcessor (command:Command, cache:MessageReceiverCache, 
			settings:MessageSettings, status:CommandStatus) {
		super(command.message, cache, settings, invokeObserver);
		this._command = command;
		this.status = status;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get command () : Command {
		return _command;
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
		if (oldStatus != command.status && oldStatus != CommandStatus.EXECUTE) {
			status = command.status;
			rewind();
		}
	}
	
	/**
	 * @private
	 */
	protected override function fetchReceivers () : Array {	
		if (cache) {
			var receivers:Array = cache.getReceivers(command.message, MessageReceiverKind.forCommandStatus(status));
			return command.getObservers(status).concat(receivers);
		}
		else {
			return command.getObservers(status);
		}
	}
	
	
}
}

