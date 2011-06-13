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
package org.spicefactory.parsley.dsl.command {

import org.spicefactory.lib.command.Command;
import org.spicefactory.lib.command.CommandResult;
import org.spicefactory.lib.command.adapter.CommandAdapters;
import org.spicefactory.lib.command.proxy.DefaultCommandProxy;
import org.spicefactory.parsley.core.command.ManagedCommand;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.messaging.Message;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;

/**
 * @author Jens Halm
 */
public class DefaultManagedCommand extends DefaultCommandProxy implements ManagedCommand {


	private var _target:DynamicObjectDefinition;
	private var _trigger:Message;
	
	private var dynamicObject:DynamicObject;


	function DefaultManagedCommand (target:DynamicObjectDefinition, trigger:Message = null) {
		_target = target;
		_trigger = trigger;
	}


	public function get context () : Context {
		return _target.registry.context;
	}

	public function get id () : String {
		return _target.id;
	}
	
	public function get trigger () : Message {
		return _trigger;
	}
	
	/**
	 * @private
	 */
	protected override function doExecute () : void {
		dynamicObject = _target.registry.context.addDynamicDefinition(_target);
		target =  (dynamicObject.instance is Command) 
				? dynamicObject.instance as Command
				: CommandAdapters.createAdapter(dynamicObject.instance, _target.registry.domain);
		super.doExecute();
	}
	
	/**
	 * @private
	 */
	protected override function commandComplete (result:CommandResult) : void {
		super.commandComplete(result);
		dynamicObject.remove();
	}

	
}
}
