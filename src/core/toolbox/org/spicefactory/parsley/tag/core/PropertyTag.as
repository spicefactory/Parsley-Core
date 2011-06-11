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

package org.spicefactory.parsley.tag.core {
import org.spicefactory.parsley.config.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.errors.ObjectDefinitionBuilderError;
import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;
import org.spicefactory.parsley.tag.util.ConfigurationValueResolver;

[DefaultProperty("value")]
[XmlMapping(elementName="property")]
/**
 * Represent the property value for an object definition. Can be used in MXML and XML configuration.
 * 
 * @author Jens Halm
 */
public class PropertyTag extends ObjectReferenceTag implements ObjectDefinitionDecorator {


	/**
	 * The resolver for value declarations.
	 */
	protected static const valueResolver:ConfigurationValueResolver = new ConfigurationValueResolver(); 
	
	[ChoiceId("nestedElements")]
	/**
	 * The value of the property mapped as a child element.
	 */
	public var childValue:*;

	[Attribute]
	/**
	 * The value of the property mapped as an attribute.
	 */
	public var value:*;

	[Required]
	/**
	 * The name of the property. 
	 */
	public var name:String;
	
	/**
	 * Validates the properties of this tag instance.
	 */
	protected function validate () : void {
		var valueCount:int = 0;
		if (childValue !== undefined) valueCount++;
		if (value !== undefined) valueCount++;
		if (idRef != null) valueCount++;
		if (typeRef != null) valueCount++;
		if (valueCount != 1) {
			throw new ObjectDefinitionBuilderError("Exactly one attribute of value, id-ref or type-ref or a child node without" +
				" attributes must be specified");
		}
	}


	/**
	 * @inheritDoc
	 */
	public function decorate (builder:ObjectDefinitionBuilder) : void {
		validate();

		if (idRef != null) {
			builder.property(name).injectById(idRef, !required);
		}
		else if (typeRef != null) {
			builder.property(name).injectByType(typeRef);
		}
		else if (childValue != null) {
			builder.property(name).value(valueResolver.resolveValue(childValue, builder.config));
		}
		else if (value != null) {
			builder.property(name).value(valueResolver.resolveValue(value, builder.config));
		}
		else {
			builder.property(name).injectByType(null, !required);
		}
	}
	
	
}
}
