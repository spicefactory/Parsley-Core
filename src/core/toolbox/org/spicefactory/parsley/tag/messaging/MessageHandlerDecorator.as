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

[Metadata(name="MessageHandler", types="method", multiple="true")]
/**
 * Represents a Metadata, MXML or XML tag that can be used on methods which wish to handle messages
 * dispatched through Parsleys central message router.
 * 
 * @author Jens Halm
 */
public class MessageHandlerDecorator extends MessageReceiverDecoratorBase implements ObjectDefinitionDecorator {

	[Ignore]
	/**
	 * Optional list of names of properties of the message that should be used as method parameters
	 * instead passing the message itself as a parameter.
	 */
	public var messageProperties:Array;

	[Target]
	/**
	 * The name of the method that wishes to handle the message.
	 */
	public var method:String;
	
	
	/**
	 * @inheritDoc
	 */
	public function decorate (builder:ObjectDefinitionBuilder) : void {
		builder
			.method(method)
				.messageHandler()
					.scope(scope)
					.type(type)
					.selector(selector)
					.messageProperties(messageProperties)
					.order(order);
	}
	
	
}
}

