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

package org.spicefactory.parsley.xml.tag {
import org.spicefactory.lib.reflect.mapping.MappedProperty;
import org.spicefactory.parsley.messaging.tag.MessageHandlerDecorator;

[XmlMapping(elementName="message-handler")]
/**
 * Represents the message-handler XML tag.
 * 
 * @author Jens Halm
 */
public class MessageHandlerDecoratorTag extends MessageHandlerDecorator {

	
	[Attribute("message-properties")]
	/**
	 * The names of the properties of the message instance to be applied as method parameters on
	 * the target handler method as a single String concatenated with a ','.
	 */
	public function set messagePropertiesAsString (props:String) : void {
		messageProperties = MappedProperty.splitAndTrim(props);
	}
	
	
}
}
