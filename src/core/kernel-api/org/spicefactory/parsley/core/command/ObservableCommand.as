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

package org.spicefactory.parsley.core.command {

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.messaging.Message;
	
/**
 * Represents a single command and holds all the information needed
 * for command observers to process this command and its result.
 * 
 * @author Jens Halm
 */
public interface ObservableCommand {
	
	
	/**
	 * The message that triggered the command.
	 * This property is null when the command was started programmatically.
	 */
	function get trigger () : Message;
	
	/**
	 * The actual command instance.
	 */
	function get command () : Object;

	/**
	 * The id the command is registered with in the Context.
	 */
	function get id () : String;
	
	/**
	 * The type of the command.
	 */
	function get type () : ClassInfo;
	
	/**
	 * The result produced by the command.
	 */
	function get result () : Object;
	
	/**
	 * The status of the command.
	 */
	function get status () : CommandStatus;
	
	/**
	 * Indicates whether this command is a root command or a nested command.
	 * This property is true if the command is a simple standalone command or the root
	 * command of a sequence or flow. It is flow if it is a command nested in a sequence
	 * or flow. 
	 */
	function get root () : Boolean;
	
	/**
	 * Observes the completion of this command, no matter whether it successfully completes, 
	 * aborts with an error or gets cancelled. The callback function must accept an argument
	 * of type ObservableCommand.
	 * 
	 * @param callback the callback to invoke when the command completes  
	 */
	function observe (callback:Function) : void;
	
	
}
}
