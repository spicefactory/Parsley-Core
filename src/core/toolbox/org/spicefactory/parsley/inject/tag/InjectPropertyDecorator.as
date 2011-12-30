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

package org.spicefactory.parsley.inject.tag {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.inject.Inject;
import org.spicefactory.parsley.inject.model.ObjectTypeReferenceArray;

[Metadata(name="Inject", types="property")]
/**
 * Represents a Metadata, MXML or XML tag that can be used on properties for which dependency injection should
 * be performed.
 *
 * @author Jens Halm
 */
public class InjectPropertyDecorator implements ObjectDefinitionDecorator {


	[DefaultProperty]
	/**
	 * The id of the dependency to inject. If this property is null,
	 * dependency injection by type will be performed.
	 */
	public var id:String;
	
	/**
	 * Indicates whether the dependency is required or optional.
	 */
	public var required:Boolean = true;
	
	/**
	 * The type to inject, only applicable for Array properties.
	 * In this case all objects with a matching type will be included.
	 */
	public var type:Class;

	[Target]
	/**
	 * The name of the property.
	 */
	public var property:String;
	
	
	/**
	 * @inheritDoc
	 */
	public function decorate (builder:ObjectDefinitionBuilder) : void {
		if (type != null) {
			if (!builder.typeInfo.getProperty(property).type.isType(Array)) {
				throw new ContextError("type attribute may only be used for Array properties");
			}
			builder
				.property(property)
				.value(new ObjectTypeReferenceArray(ClassInfo.forClass(type, builder.registry.domain)));
		}
		else if (id != null) {
			var idRef:Object = (required) ? Inject.byId(id) : Inject.ifIdAvailable(id);
			builder
				.property(property)
				.value(idRef);
		}
		else {
			var typeRef:Object = (required) ? Inject.byType(type) : Inject.ifTypeAvailable(type);
			builder
				.property(property)
				.value(typeRef);
		}
	}
	
	
}

}
