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

package org.spicefactory.parsley.core.registry.definition.impl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.definition.ConstructorArgRegistry;

[Deprecated]
/**
 * @author Jens Halm
 */
public class DefaultConstructorArgRegistry extends AbstractParameterRegistry implements ConstructorArgRegistry {

	function DefaultConstructorArgRegistry (def:ObjectDefinition) {
		super(def.type.getConstructor(), def);
	}
		
	public function addValue (value:*) : ConstructorArgRegistry {
		doAddValue(value);
		return this;
	}
	
	public function addIdReference (id:String) : ConstructorArgRegistry {
		doAddIdReference(id);
		return this;
	}
	
	public function addTypeReference (type:ClassInfo = null) : ConstructorArgRegistry {
		doAddTypeReference(type);
		return this;
	}
	
}

}
