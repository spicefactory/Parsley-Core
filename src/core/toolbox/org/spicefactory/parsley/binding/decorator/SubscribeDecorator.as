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
 
package org.spicefactory.parsley.binding.decorator {
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.binding.processor.SubscriberProcessor;
import org.spicefactory.parsley.config.ObjectDefinitionDecorator;
import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;
import org.spicefactory.parsley.tag.util.ReflectionUtil;

[Metadata(name="Subscribe", types="property")]
[XmlMapping(elementName="subscribe")]
/**
 * Represents a Metadata, MXML or XML tag that can be used on properties that
 * should be bound to the value of a matching publisher.
 * 
 * @author Jens Halm
 */
public class SubscribeDecorator implements ObjectDefinitionDecorator {


	/**
	 * The scope the binding listens to.
	 */
	public var scope:String;

	/**
	 * The id the source is published with.
	 */
	public var objectId:String;

	[Target]
	/**
	 * The property that binds to the subscribed value.
	 */
	public var property:String;
	
	
	/**
	 * @inheritDoc
	 */
	public function decorate (builder:ObjectDefinitionBuilder) : void {
		var p:Property = ReflectionUtil.getProperty(property, builder.typeInfo, false, true);
		builder.lifecycle().processorFactory(SubscriberProcessor.newFactory(p, scope, objectId));
	}
	

}
}
