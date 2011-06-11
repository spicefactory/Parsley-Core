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

package org.spicefactory.parsley.tag.messaging {
import org.spicefactory.parsley.config.ObjectDefinitionDecorator;
import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;

[Metadata(name="CommandResult", types="method", multiple="true")]
[XmlMapping(elementName="command-result")]
/**
 * Represents a Metadata, MXML or XML tag that can be used on methods which wish to be invoked when
 * the result of a matching asynchronous command execution has been received.
 * 
 * @author Jens Halm
 */
public class CommandResultDecorator extends MessageReceiverDecoratorBase implements ObjectDefinitionDecorator {
	
	
	[Target]
	/**
	 * The name of the method that wishes to handle the message.
	 */
	public var method:String;
	
	
	public function decorate (builder:ObjectDefinitionBuilder) : void {
		builder
			.method(method)
				.commandResult()
					.scope(scope)
					.type(type)
					.selector(selector)
					.order(order);
	}
	
}
}
