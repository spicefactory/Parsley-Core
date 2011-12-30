/*
 * Copyright 2010 the original author or authors.
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
 
package org.spicefactory.parsley.binding.tag {

import flash.events.Event;
import org.spicefactory.parsley.binding.impl.PropertyPublisher;
import org.spicefactory.parsley.binding.processor.PublisherProcessor;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionDecorator;


[Metadata(name="Publish", types="property")]
[XmlMapping(elementName="publish")]
/**
 * Represents a Metadata, MXML or XML tag that can be used on properties that hold a value that
 * should be published to matching subscribers.
 * 
 * @author Jens Halm
 */
public class PublishDecorator implements ObjectDefinitionDecorator {


	/**
	 * The scope the property value is published to.
	 */
	public var scope:String;

	/**
	 * The optional id the property value is published with.
	 */
	public var objectId:String;

	[Target]
	/**
	 * The property that holds the value to publish.
	 */
	public var property:String;
	
	/**
	 * The event that signals that the property value has changed.
	 * This property does not have any effect in Flex applications
	 * where the Flex Binding mechanism is used instead.
	 */
	public var changeEvent:String = Event.CHANGE; 

	/**
	 * Indicates whether the value published by this property should be 
	 * added to the Context (turned into a managed object) while being
	 * published. 
	 */
    public var managed:Boolean;

	
	/**
	 * @inheritDoc
	 */
	public function decorate (builder:ObjectDefinitionBuilder) : void {
	
		builder
			.property(property)
			.process(new PublisherProcessor(PropertyPublisher, scope, objectId, managed, changeEvent))
			.mustRead();
	
	}
	

}
}
