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

package org.spicefactory.parsley.resources.tag {
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionDecorator;
import org.spicefactory.parsley.resources.processor.ResourceBindingProcessor;

[Metadata(name="ResourceBinding", types="property")]
[XmlMapping(elementName="resource-binding")]
/**
 * Represents a Metadata, MXML or XML tag that can be used to bind a property value to a resource, updating
 * automatically when the ResourceManager updates.
 * 
 * @author Jens Halm
 */
public class ResourceBindingDecorator implements ObjectDefinitionDecorator {


	/**
	 * The resource key.
	 */
	public var key:String;

	/**
	 * The bundle name.
	 */
	public var bundle:String;

	[Target]
	/**
	 * The property to bind to.
	 */
	public var property:String;
	
	
	/**
	 * @inheritDoc
	 */
	public function decorate (builder:ObjectDefinitionBuilder) : void {
		builder
			.property(property)
			.process(new ResourceBindingProcessor(bundle, key))
			.mustWrite();
	}
	

}
}
