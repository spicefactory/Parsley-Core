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
 
package org.spicefactory.parsley.tag.command {

import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;

/**
 * Base tag for command groups declared in MXML or XML configuration.
 * 
 * @author Jens Halm
 */
public class AbstractCommandGroupTag extends AbstractCommandParentTag implements NestedCommandTag {
	
	
	private var type:Class;

	/**
	 * @private
	 */
	function AbstractCommandGroupTag (type:Class) {
		this.type = type;
	}

	/**
	 * @inheritDoc
	 */
	public override function resolve (config:Configuration) : ManagedCommandFactory {
		var factories:Array = [];
		for each (var tag:NestedCommandTag in commands) {
			factories.push(tag.resolve(config));
		}
		return new Factory(type, factories, config.context);
	}
	
	
}
}

import org.spicefactory.lib.command.group.CommandGroup;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.core.command.ManagedCommandProxy;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.dsl.command.DefaultManagedCommandProxy;

class Factory implements ManagedCommandFactory {
	
	private var _type:Class;
	private var factories:Array;
	private var context:Context;
	
	function Factory (type:Class, factories:Array, context:Context) {
		this._type = type;
		this.factories = factories;
		this.context = context;
	}
	
	public function newInstance () : ManagedCommandProxy {
		var group:CommandGroup = new _type();
		for each (var factory:ManagedCommandFactory in factories) {
			group.addCommand(factory.newInstance());
		}
		// TODO - handle id ?
		return new DefaultManagedCommandProxy(context, group);
	}

	public function get type () : ClassInfo {
		return ClassInfo.forClass(_type, context.domain);
	}
	
}
