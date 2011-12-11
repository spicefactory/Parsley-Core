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
import org.spicefactory.lib.command.builder.Commands;
import org.spicefactory.lib.command.lifecycle.CommandLifecycle;
import org.spicefactory.lib.command.proxy.DefaultCommandProxy;
import org.spicefactory.parsley.core.command.ManagedCommandProxy;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;

/**
 * ManagedCommandProxy implementation that knows how to create command
 * from an ObjectDefinition.
 * 
 * @author Jens Halm
 */
public class DefinitionBasedCommandProxy extends DefaultCommandProxy implements ManagedCommandProxy {


	private var definition:DynamicObjectDefinition;
	
	private var dynamicObject:DynamicObject;

	
	/**
	 * Creates a new instance.
	 * 
	 * @param target the definition of the target command
	 */
	function DefinitionBasedCommandProxy (target:DynamicObjectDefinition) {
		definition = target;
	}

	/**
	 * @inheritDoc
	 */
	public function get id () : String {
		return definition.id;
	}
	
	/**
	 * @private
	 */
	protected override function createLifecycle () : CommandLifecycle {
		return new ManagedCommandLifecycle(definition.registry.context, this);
	}
	
	/**
	 * @private
	 */
	protected override function doExecute () : void {
		dynamicObject = definition.registry.context.addDynamicDefinition(definition);
		if (!(dynamicObject.instance is Command)) {
			Commands.create(Object).build(); // TODO - temporary hack to trigger LightCommandAdapter registration
		}
		target =  (dynamicObject.instance is Command) 
				? dynamicObject.instance as Command
				: CommandAdapters.createAdapter(dynamicObject.instance, definition.registry.domain);
		super.doExecute();
	}
	
	/**
	 * @private
	 */
	protected override function commandComplete (result:CommandResult) : void {
		super.commandComplete(result);
		dynamicObject.remove();
	}
	
	/**
	 * @private
	 */
	public override function cancel () : void {
		super.cancel();
		dynamicObject.remove();
	}
	
	/**
	 * @private
	 */
	protected override function error (cause: Object = null): void {
		super.error(cause);
		dynamicObject.remove();
	}

	
}
}
