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
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionDecorator;

[Metadata(name="InjectConstructor", types="class")]
/**
 * Represents a Metadata, MXML or XML tag that can be used on clases for which constructor injection should
 * be performed. 
 * 
 * <p>Note that since the Flash Player currently ignores metadata on constructors this tag has to be added
 * to the class declaration.</p>
 *
 * @author Jens Halm
 */
public class InjectConstructorDecorator implements ObjectDefinitionDecorator {


	/**
	 * @inheritDoc
	 */
	public function decorate (builder:ObjectDefinitionBuilder) : void {
		/*
		var refs:Array = ReflectionUtil.getTypeReferencesForParameters(definition.type.getConstructor());
		definition.instantiator = new ConstructorInstantiator(refs);
		return definition;
		 */
		builder.constructorArgs();
	}
	
	
}
}
