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

package org.spicefactory.parsley.lifecycle.tag {

import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionDecorator;
import org.spicefactory.parsley.lifecycle.processor.FactoryDefinitionReplacer;

[Metadata(name="Factory", types="method")]
[XmlMapping(elementName="factory")]
/**
 * Represents a Metadata, MXML or XML tag that can be used to mark a method as a factory method.
 * 
 * @author Jens Halm
 */
public class FactoryMethodDecorator implements ObjectDefinitionDecorator {

	
	[Target]
	/**
	 * The name of the factory method.
	 */
	public var method:String;
	
	
	/**
	 * @inheritDoc
	 */
	public function decorate (builder:ObjectDefinitionBuilder) : void {
		var m:Method = builder.typeInfo.getMethod(method);
		if (!m) {
			throw new IllegalStateError("Class " + builder.typeInfo.name
				+ " does not contain a method with name " + method);
		}
		builder.replace(new FactoryDefinitionReplacer(m, builder.registry));
	}
	
}
}
