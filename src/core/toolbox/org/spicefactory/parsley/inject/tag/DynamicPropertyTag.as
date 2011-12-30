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

package org.spicefactory.parsley.inject.tag {

import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.errors.ObjectDefinitionBuilderError;
import org.spicefactory.parsley.inject.model.ObjectIdReference;
import org.spicefactory.parsley.inject.model.ObjectTypeReference;
import org.spicefactory.parsley.inject.processor.DynamicPropertyProcessor;

[DefaultProperty("value")]
[XmlMapping(elementName="dynamic-property")]
/**
 * Represent the value for a dynamic property. Can be used in MXML and XML configuration.
 * 
 * <p>This allows values to be set on dynamic objects like a Dictionary or a generic Object.
 * Since reflection on dynamic properties is not possible, injection by type is not supported by this tag.
 * In all cases where the property is not dynamic, the regular Property tag should be preferred.</p>
 * 
 * @author Jens Halm
 */
public class DynamicPropertyTag extends PropertyTag implements ObjectDefinitionDecorator {


	/**
	 * @inheritDoc
	 */
	public override function decorate (builder:ObjectDefinitionBuilder) : void {
		validate();

		var unresolvedValue:*;
		if (idRef != null) {
			unresolvedValue = new ObjectIdReference(idRef, required);
		}
		else if (typeRef != null) {
			unresolvedValue = new ObjectTypeReference(typeRef, required);
		}
		else if (childValue != null) {
			unresolvedValue = valueResolver.resolveValue(childValue, builder.registry);
		}
		else if (value != null) {
			unresolvedValue = valueResolver.resolveValue(value, builder.registry);
		}
		else {
			throw new ObjectDefinitionBuilderError("No value specified for dynamic property with name " + name);
		}
		
		builder.process(new DynamicPropertyProcessor(name, unresolvedValue));
	}
	
	
}
}
