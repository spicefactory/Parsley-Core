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

[Metadata(name="MessageDispatcher", types="property")]
[XmlMapping(elementName="message-dispatcher")]
/**
 * Represents a Metadata, MXML or XML tag that can be used on properties where a message dispatcher function
 * should be injected.
 * 
 * This is an alternative to declaring managed events, useful when working with message types which do not
 * extend <code>flash.events.Event</code>.
 * 
 * @author Jens Halm
 */
public class MessageDispatcherDecorator implements ObjectDefinitionDecorator {


	[Target]
	/**
	 * The name of the property.
	 */
	public var property:String;
	
	/**
	 * The scope messages should be dispatched through.
	 * If this attribute is omitted the message will be dispatched through 
	 * all scopes of the corresponding Context.
	 */
	public var scope:String;
	
	
	/**
	 * @inheritDoc
	 */
	public function decorate (builder:ObjectDefinitionBuilder) : void {
		builder.property(property).messageDispatcher(scope);
	}
	
	
}

}
