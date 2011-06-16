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

package org.spicefactory.parsley.core.command.impl {

import org.spicefactory.lib.util.collection.List;
import org.spicefactory.parsley.core.command.CommandManager;
import org.spicefactory.parsley.core.command.ObservableCommand;

/**
 * Default implementation of the CommandManager interface.
 * 
 * @author Jens Halm
 */
public class DefaultCommandManager implements CommandManager {


	private var commands:List = new List();

	
	/**
	 * Adds an active command to be managed by this instance.
	 * 
	 * @param command the active command to add
	 */
	public function addActiveCommand (command:ObservableCommand) : void {
		commands.add(command);
		command.observe(commandCompleted);
	}
	
	private function commandCompleted (command:ObservableCommand) : void {
		commands.remove(command);
	}


	/**
	 * @inheritDoc
	 */
	public function hasActiveCommandsForTrigger (messageType:Class, selector:* = undefined) : Boolean {
		for each (var command:ObservableCommand in commands) {
			if (matchesByTrigger(command, messageType, selector)) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getActiveCommandsByTrigger (messageType:Class, selector:* = undefined) : Array {
		var result:Array = new Array();
		for each (var command:ObservableCommand in commands) {
			if (matchesByTrigger(command, messageType, selector)) {
				result.push(command);
			}
		}
		return result;
	}
	
	private function matchesByTrigger (command:ObservableCommand, messageType:Class, selector:*) : Boolean {
		return (command.trigger && command.trigger.instance is messageType &&
				(selector == undefined || selector == command.trigger.selector));
	}
	
	private function matchesByType (command:ObservableCommand, commandType:Class, id:String = null) : Boolean {
		return (command.command is commandType &&
				(id == null || id == command.id));
	}

	/**
	 * @inheritDoc
	 */
	public function hasActiveCommandsOfType (commandType:Class, id:String = null) : Boolean {
		for each (var command:ObservableCommand in commands) {
			if (matchesByType(command, commandType, id)) {
				return true;
			}
		}
		return false;
	}

	/**
	 * @inheritDoc
	 */
	public function getActiveCommandsByType (commandType:Class, id:String = null) : Array {
		var result:Array = new Array();
		for each (var command:ObservableCommand in commands) {
			if (matchesByType(command, commandType, id)) {
				result.push(command);
			}
		}
		return result;
	}
	
	
}
}
