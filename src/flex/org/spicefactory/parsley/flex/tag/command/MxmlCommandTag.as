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
package org.spicefactory.parsley.flex.tag.command {

import flash.utils.getQualifiedClassName;
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.parsley.config.ObjectDefinitionDecorator;
import org.spicefactory.parsley.tag.command.link.LinkTag;
import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.config.ObjectConfiguration;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.tag.command.CommandTag;
import org.spicefactory.parsley.tag.command.NestedCommandTag;

[DefaultProperty("config")]
/**
 * Tag for a single command declared in MXML configuration.
 * 
 * @author Jens Halm
 */
public class MxmlCommandTag implements NestedCommandTag {

	
	/**
	 * The type of the command configured by this definition.
	 */
	public var type:Class = Object;
	
	[ArrayElementType("org.spicefactory.parsley.config.ObjectConfiguration")]
	/**
	 * The command configuration or flow links for this command definition.
	 */
	public function set config (value: Array): void {
		for each (var child: ObjectConfiguration in value) {
			if (child is LinkTag) _links.push(child);
			else if (child is ObjectDefinitionDecorator) _decorators.push(child);
			else throw new IllegalStateError("Unknown config type: " + getQualifiedClassName(child));
		}
	}
	
	private var _links: Array = new Array();
	private var _decorators: Array = new Array();
	
	/**
	 * @inheritDoc
	 */
	public function resolve (config: Configuration): ManagedCommandFactory {
		var delegate: CommandTag = new CommandTag();
		delegate.type = type;
		delegate.links = links;
		delegate.config = _decorators;
		return delegate.resolve(config);
	}

	/**
	 * @inheritDoc
	 */
	public function get links (): Array {
		return _links;
	}
	
	
}
}
