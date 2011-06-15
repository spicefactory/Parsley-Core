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

import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.config.RootConfigurationElement;
import org.spicefactory.parsley.dsl.command.MappedCommandBuilder;
	
[DefaultProperty("command")]
[XmlMapping(elementName="map-command")]
/**
 * @author Jens Halm
 */
public class MapCommandTag implements RootConfigurationElement {
	
	
	/**
	 * The command to map to the message.
	 */
	public var command:NestedCommandTag;
	
	/**
	 * The command class.
	 * If the command property is set this property will be ignored.
	 */
	public var type:Class;
	
	/**
	 * @copy org.spicefactory.parsley.tag.lifecycle.AbstractSynchronizedProviderDecorator#scope
	 */
	public var scope:String;

	/**
	 * @copy org.spicefactory.parsley.tag.messaging.AbstractMessageReceiverDecorator#type
	 */
	public var messageType:Class;

	[Attribute]
	/**
	 * @copy org.spicefactory.parsley.tag.messaging.AbstractMessageReceiverDecorator#selector
	 */
	public var selector:*;
	
	/**
	 * @copy org.spicefactory.parsley.tag.messaging.AbstractMessageReceiverDecorator#order
	 */
	public var order:int = int.MAX_VALUE;

	/**
	 * @inheritDoc
	 */
	public function process (config:Configuration) : void {
		
		if (!command && !type) {
			throw new IllegalStateError("Either command or type must be specified");
		}
		
		var builder:MappedCommandBuilder = (command)
				? MappedCommandBuilder.forFactory(command.resolve(config))
				: MappedCommandBuilder.forType(type);

		builder
			.messageType(messageType)
			.selector(selector)
			.scope(scope)
			.order(order)
			.register(config.context);
	}
	
	
}
}
