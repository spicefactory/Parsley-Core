/*
 * Copyright 2010 the original author or authors.
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

package org.spicefactory.parsley.core.messaging {
import org.spicefactory.parsley.core.command.CommandStatus;

/**
 * Enumeration for the different kinds of message receivers.
 * 
 * @author Jens Halm
 */
public class MessageReceiverKind {


	/**
	 * Constant for a regular message target (like MessageHandler or Command).
	 */
	public static const TARGET:MessageReceiverKind = new MessageReceiverKind("target");

	/**
	 * Constant for an error handler.
	 */
	public static const ERROR_HANDLER:MessageReceiverKind = new MessageReceiverKind("errorHandler");

	/**
	 * Constant for a command observer for the status EXECUTE, matching by trigger message and selector.
	 */
	public static const COMMAND_EXECUTE_BY_TRIGGER:MessageReceiverKind = new MessageReceiverKind("commandExecuteByTrigger");
	
	/**
	 * Constant for a command observer for the status COMPLETE, matching by trigger message and selector.
	 */
	public static const COMMAND_COMPLETE_BY_TRIGGER:MessageReceiverKind = new MessageReceiverKind("commandCompleteByTrigger");
	
	/**
	 * Constant for a command observer for the status ERROR, matching by trigger message and selector.
	 */
	public static const COMMAND_ERROR_BY_TRIGGER:MessageReceiverKind = new MessageReceiverKind("commandErrorByTrigger");
	
	/**
	 * Constant for a command observer for the status CANCEL, matching by trigger message and selector.
	 */
	public static const COMMAND_CANCEL_BY_TRIGGER:MessageReceiverKind = new MessageReceiverKind("commandCancelByTrigger");

	/**
	 * Constant for a command observer for the status EXECUTE, matching by command type and id.
	 */
	public static const COMMAND_EXECUTE_BY_TYPE:MessageReceiverKind = new MessageReceiverKind("commandExecuteByType");
	
	/**
	 * Constant for a command observer for the status COMPLETE, matching by command type and id.
	 */
	public static const COMMAND_COMPLETE_BY_TYPE:MessageReceiverKind = new MessageReceiverKind("commandCompleteByType");
	
	/**
	 * Constant for a command observer for the status ERROR, matching by command type and id.
	 */
	public static const COMMAND_ERROR_BY_TYPE:MessageReceiverKind = new MessageReceiverKind("commandErrorByType");
	
	/**
	 * Constant for a command observer for the status CANCEL, matching by command type and id.
	 */
	public static const COMMAND_CANCEL_BY_TYPE:MessageReceiverKind = new MessageReceiverKind("commandCancelByType");

	/**
	 * Returns the constant corrsesponding to the specified command status.
	 * 
	 * @param status the status to return the corresponding receiver kind for
	 * @param byTrigger whether the observer matches by trigger message and selector (true) or command type and id (false) 
	 * @return the constant corrsesponding to the specified command status
	 */
	public static function forCommandStatus (status:CommandStatus, byTrigger:Boolean) : MessageReceiverKind {
		switch (status.key) {
			case CommandStatus.EXECUTE.key: 
				return (byTrigger) ? COMMAND_EXECUTE_BY_TRIGGER : COMMAND_EXECUTE_BY_TYPE;
			case CommandStatus.COMPLETE.key: 
				return (byTrigger) ? COMMAND_COMPLETE_BY_TRIGGER : COMMAND_COMPLETE_BY_TYPE;
			case CommandStatus.CANCEL.key: 
				return (byTrigger) ? COMMAND_CANCEL_BY_TRIGGER : COMMAND_CANCEL_BY_TYPE;
			case CommandStatus.ERROR.key: 
				return (byTrigger) ? COMMAND_ERROR_BY_TRIGGER : COMMAND_ERROR_BY_TYPE;
		}
		return null;
	}
	
	
	private var _key:String;
	
	
	/**
	 * @private
	 */
	function MessageReceiverKind (key:String) {
		_key = key;
	}
	
	/**
	 * The unique key representing this kind.
	 */
	public function get key () : String {
		return _key;
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return _key;
	}	
	
	
}
}
