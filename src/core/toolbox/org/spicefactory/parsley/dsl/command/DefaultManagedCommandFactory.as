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

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.command.ManagedCommand;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.core.messaging.Message;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
	
/**
 * @author Jens Halm
 */
public class DefaultManagedCommandFactory implements ManagedCommandFactory {

	// TODO - maybe move to CommandTag

	private var target:DynamicObjectDefinition;
	
	
	function DefaultManagedCommandFactory (target:DynamicObjectDefinition) {
		this.target = target;
	}
	
	public function get type () : ClassInfo {
		return target.type;
	}
	
	public function newInstance (trigger:Message = null) : ManagedCommand {
		return new DefaultManagedCommand(target, trigger);
	}
	
	
}
}
