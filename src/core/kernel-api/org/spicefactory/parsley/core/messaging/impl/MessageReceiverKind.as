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

package org.spicefactory.parsley.core.messaging.impl {
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
	 * Constant for a command observer for the status EXECUTE.
	 */
	public static const COMMAND_EXECUTE:MessageReceiverKind = new MessageReceiverKind("commandExecute");
	
	/**
	 * Constant for a command observer for the status COMPLETE.
	 */
	public static const COMMAND_COMPLETE:MessageReceiverKind = new MessageReceiverKind("commandComplete");
	
	/**
	 * Constant for a command observer for the status ERROR.
	 */
	public static const COMMAND_ERROR:MessageReceiverKind = new MessageReceiverKind("commandError");
	
	/**
	 * Constant for a command observer for the status CANCEL.
	 */
	public static const COMMAND_CANCEL:MessageReceiverKind = new MessageReceiverKind("commandCancel");


	/**
	 * Returns the constant corrsesponding to the specified command status.
	 * 
	 * @param status the status to return the corresponding receiver kind for
	 * @return the constant corrsesponding to the specified command status
	 */
	public static function forCommandStatus (status:CommandStatus) : MessageReceiverKind {
		switch (status.key) {
			case CommandStatus.EXECUTE.key: 
				return COMMAND_EXECUTE;
			case CommandStatus.COMPLETE.key: 
				return COMMAND_COMPLETE;
			case CommandStatus.CANCEL.key: 
				return COMMAND_CANCEL;
			case CommandStatus.ERROR.key: 
				return COMMAND_ERROR;
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
