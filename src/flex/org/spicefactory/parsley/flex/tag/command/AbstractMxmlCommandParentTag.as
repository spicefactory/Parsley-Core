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
import org.spicefactory.parsley.command.tag.AbstractCommandParentTag;
import org.spicefactory.parsley.command.tag.CommandConfiguration;
import org.spicefactory.parsley.command.tag.NestedCommandTag;
import org.spicefactory.parsley.command.tag.link.LinkTag;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;


[DefaultProperty("config")]
/**
 * Base class for any kind of MXML tag that accepts an Array of command tags
 * as children.
 * 
 * @author Jens Halm
 */
public class AbstractMxmlCommandParentTag implements NestedCommandTag {


	private var delegate: AbstractCommandParentTag;
	
	function AbstractMxmlCommandParentTag (delegate: AbstractCommandParentTag) {
		this.delegate = delegate;
	}
	
	[ArrayElementType("org.spicefactory.parsley.command.tag.CommandConfiguration")]
	/**
	 * The command configuration or flow links for this command definition.
	 */
	public function set config (value: Array): void {
		for each (var child: CommandConfiguration in value) {
			if (child is LinkTag) _links.push(child);
			else if (child is NestedCommandTag) _commands.push(child);
			else throw new IllegalStateError("Unknown config type: " + getQualifiedClassName(child));
		}
	}
	
	private var _links: Array = new Array();
	private var _commands: Array = new Array();
	
	/**
	 * @inheritDoc
	 */
	public function resolve (registry: ObjectDefinitionRegistry): ManagedCommandFactory {
		delegate.links = links;
		delegate.commands = _commands;
		return delegate.resolve(registry);
	}

	/**
	 * @inheritDoc
	 */
	public function get links (): Array {
		return _links;
	}
	
	
}
}
