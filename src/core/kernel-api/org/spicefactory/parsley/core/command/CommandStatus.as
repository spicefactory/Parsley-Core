/*
 * Copyright 2009 the original author or authors.
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

package org.spicefactory.parsley.core.command {

import org.spicefactory.lib.command.events.CommandResultEvent;
import org.spicefactory.lib.command.CancellableCommand;
import org.spicefactory.lib.command.events.CommandEvent;

/**
 * Enumeration for the current status of a command.
 * 
 * @author Jens Halm
 */
public class CommandStatus {


	/**
	 * The status for an active command.
	 */
	public static const EXECUTE:CommandStatus = new CommandStatus("execute");

	/**
	 * The status for a command that successfully completed.
	 */
	public static const COMPLETE:CommandStatus = new CommandStatus("complete");

	/**
	 * The status for a command that finished with an error.
	 */
	public static const ERROR:CommandStatus = new CommandStatus("error");

	/**
	 * The status for a command that was cancelled.
	 */
	public static const CANCEL:CommandStatus = new CommandStatus("cancel");


	private var _key:String;
	
	/**
	 * @private
	 */
	function CommandStatus (key:String) {
		_key = key;
	}
	
	/**
	 * The unique key representing this status.
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
	
	/**
	 * Observes the completion of the specified command.
	 * This method serves as a shortcut, as Parsley-internal
	 * classes often need to get notified when a command stops
	 * executing no matter what type of event caused the status
	 * change.
	 * 
	 * <p>The callback must have the following signature:</p>
	 * <code><pre>(command:CancellableCommand, result:Object, status:CommandStatus, data:Object) : void</pre></code>
	 * 
	 * TODO - this could get removed
	 * 
	 * @param command the command to observe
	 * @param callback the callback to invoke when the command stops executing
	 * @param data optional object to be passed through to the callback
	 */
	public static function observe (command:CancellableCommand, callback:Function, data:Object = null) : void {
		var f:Function = function (event:CommandEvent) : void {
			var result:Object = (event is CommandResultEvent)
				? CommandResultEvent(event).value
				: null;
			var status:CommandStatus;
			switch (event.type) {
				case CommandResultEvent.COMPLETE: status = CommandStatus.COMPLETE; break;
				case CommandResultEvent.ERROR: status = CommandStatus.ERROR; break;
				default: status = CommandStatus.CANCEL;
			}
			command.removeEventListener(CommandResultEvent.COMPLETE, arguments.callee);
			command.removeEventListener(CommandResultEvent.ERROR, arguments.callee);
			command.removeEventListener(CommandEvent.CANCEL, arguments.callee);
			callback(command, result, status, data);
		};
		command.addEventListener(CommandResultEvent.COMPLETE, f);
		command.addEventListener(CommandResultEvent.ERROR, f);
		command.addEventListener(CommandEvent.CANCEL, f);
	}
	
	
}
}
