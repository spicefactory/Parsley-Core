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

package org.spicefactory.parsley.comobserver.tag {

import org.spicefactory.parsley.comobserver.CommandStatus;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionDecorator;

[Metadata(name="CommandStatus", types="property", multiple="false")]
[XmlMapping(elementName="command-status")]

/**
 * Represents a Metadata, MXML or XML tag that can be used on properties that serve as a flag
 * for indicating whether any matching asynchronous command is currently active.
 * 
 * @author Jens Halm
 */
public class CommandStatusDecorator implements ObjectDefinitionDecorator {
	
	
	
	/**
	 * The name of the scope this tag should be applied to.
	 */
	public var scope:String;
	
	/**
	 * The type of the messages the receiver wants to handle.
	 */
	public var type:Class;

	[Attribute]
	/**
	 * An optional selector value to be used in addition to selecting messages by type.
	 * Will be checked against the value of the property in the message marked with <code>[Selector]</code>
	 * or against the event type if the message is an event and does not have a selector property specified explicitly.
	 */
	public var selector:*;
	
	[Target]
	/**
	 * The name of the property that serves as a status flag.
	 */
	public var property:String;
	
	
	/**
	 * @inheritDoc
	 */
	public function decorate (builder:ObjectDefinitionBuilder) : void {
		CommandStatus
			.forProperty(property)
				.type(type)
				.selector(selector)
				.scope(scope)
					.apply(builder);
	}
	
	
}
}
