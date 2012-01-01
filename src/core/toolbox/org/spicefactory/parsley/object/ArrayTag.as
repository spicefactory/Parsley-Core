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

package org.spicefactory.parsley.object {

import org.spicefactory.parsley.config.NestedConfigurationElement;
import org.spicefactory.parsley.core.builder.ref.ManagedArray;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.util.ConfigurationValueResolver;

[DefaultProperty("values")]
[XmlMapping(elementName="array")]
/**
 * Represents an Array value. Can be used in MXML and XML configuration.
 * 
 * @author Jens Halm
 */
public class ArrayTag implements NestedConfigurationElement {
	
	
	private static const valueResolver:ConfigurationValueResolver = new ConfigurationValueResolver(); 
	
	
	[ChoiceId("nestedElements")]
	/**
	 * The elements of the Array.
	 */
	public var values:Array;
	
	/**
	 * @inheritDoc
	 */
	public function resolve (registry:ObjectDefinitionRegistry) : Object {
		var managedArray:Array = new ManagedArray();
		for (var i:int = 0; i < values.length; i++) {
			var value:* = valueResolver.resolveValue(values[i], registry);
			managedArray.push(value);
		}
		return managedArray;
	}
	
	
}
}
