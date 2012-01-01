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
import org.spicefactory.parsley.core.builder.support.ConstructorInstantiator;
import org.spicefactory.parsley.object.ArrayTag;
import org.spicefactory.parsley.util.ConfigurationValueResolver;

[XmlMapping(elementName="constructor-args")]
/**
 * Represent the constructor arguments for an object definition. Can be used in MXML and XML configuration.
 * 
 * @author Jens Halm
 */
public class ConstructorTag extends ArrayTag implements ObjectDefinitionDecorator {


	private static const valueResolver:ConfigurationValueResolver = new ConfigurationValueResolver(); 


	/**
	 * @inheritDoc
	 */
	public function decorate (builder:ObjectDefinitionBuilder) : void {
		valueResolver.resolveValues(values, builder.registry);
		builder.instantiate(new ConstructorInstantiator(values));
	}
	
	
}
}
