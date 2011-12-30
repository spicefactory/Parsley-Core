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

package org.spicefactory.parsley.messaging.tag {

import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionDecorator;
import org.spicefactory.parsley.messaging.MessageError;

[Metadata(name="MessageError", types="method", multiple="true")]
[XmlMapping(elementName="message-error")]
/**
 * Represents a Metadata, MXML or XML tag that can be used on methods that should handle errors that were thrown
 * by a regular message target.
 * 
 * @author Jens Halm
 */
public class MessageErrorDecorator extends MessageReceiverDecoratorBase implements ObjectDefinitionDecorator {

	
	[Target]
	/**
	 * The name of the error handler method.
	 */
	public var method:String;
	
	/**
	 * The type of the error that this handler is interested in.
	 * The default is the top level Error class.
	 */
	public var errorType:Class;

	
	/**
	 * @inheritDoc
	 */
	public function decorate (builder:ObjectDefinitionBuilder) : void {
		MessageError
			.forMethod(method)
				.scope(scope)
				.type(type)
				.selector(selector)
				.errorType(errorType)
				.order(order)
					.apply(builder);
	}
	
	
}

}
