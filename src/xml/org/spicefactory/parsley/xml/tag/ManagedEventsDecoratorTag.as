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
import org.spicefactory.parsley.messaging.tag.ManagedEventsDecorator;

[XmlMapping(elementName="managed-events")]
/**
 * Represents the managed-events XML tag.
 * 
 * @author Jens Halm
 */
public class ManagedEventsDecoratorTag extends ManagedEventsDecorator {

	
	[Attribute("names")]
	/**
	 * The names of the events to manage as a single String concatenated with a ','.
	 */
	public function set namesAsString (nameStr:String) : void {
		names = MappedProperty.splitAndTrim(nameStr);
	}
	
	
}
}
