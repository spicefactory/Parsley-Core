/*
 * Copyright 2008-2009 the original author or authors.
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

package org.spicefactory.parsley.tag.messaging {
import org.spicefactory.parsley.config.ObjectDefinitionDecorator;
import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;

[Metadata(name="MessageBinding", types="property", multiple="true")]
[XmlMapping(elementName="message-binding")]
/**
 * Represents a Metadata, MXML or XML tag that can be used on properties which wish to be bound to a property value
 * of a particular message type dispatched through Parsleys central message router.
 * 
 * @author Jens Halm
 */
public class MessageBindingDecorator extends MessageReceiverDecoratorBase implements ObjectDefinitionDecorator {


	[Required]
	/**
	 * The name of the property of the message type whose value should be bound to the target property.
	 */
	public var messageProperty:String;

	[Target]
	/**
	 * The name of the property of the managed object whose value should be bound to the message property.
	 */
	public var targetProperty:String;
	
	
	/**
	 * @inheritDoc
	 */
	public function decorate (builder:ObjectDefinitionBuilder) : void {
		builder
			.property(targetProperty)
				.messageBinding()
					.scope(scope)
					.type(type)
					.selector(selector)
					.messageProperty(messageProperty)
					.order(order);
	}
	
	
}

}
