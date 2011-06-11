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

package org.spicefactory.parsley.core.messaging.command.impl {
import org.spicefactory.lib.util.ArrayUtil;
import org.spicefactory.parsley.core.messaging.command.Command;
import org.spicefactory.parsley.core.messaging.command.CommandManager;

/**
 * Default implementation of the CommandManager interface.
 * 
 * @author Jens Halm
 */
public class DefaultCommandManager implements CommandManager {


	private var commands:Array = new Array();

	
	/**
	 * Adds an active command to be managed by this instance.
	 * 
	 * @param command the active command to add
	 */
	public function addActiveCommand (command:Command) : void {
		commands.push(command);
		command.addStatusHandler(commandCompleted);
	}
	
	private function commandCompleted (command:Command) : void {
		ArrayUtil.remove(commands, command);
	}


	/**
	 * @inheritDoc
	 */
	public function hasActiveCommands (messageType:Class, selector:* = undefined) : Boolean {
		for each (var command:Command in commands) {
			if (matches(command, messageType, selector)) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getActiveCommands (messageType:Class, selector:* = undefined) : Array {
		var result:Array = new Array();
		for each (var command:Command in commands) {
			if (matches(command, messageType, selector)) {
				result.push(command);
			}
		}
		return result;
	}
	
	private function matches (command:Command, messageType:Class, selector:*) : Boolean {
		return (command.message.instance is messageType && 
				(selector == undefined || selector == command.selector));
	}
	
	
}
}
