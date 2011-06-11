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

package org.spicefactory.parsley.core.messaging.command {

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
	
	
}
}
