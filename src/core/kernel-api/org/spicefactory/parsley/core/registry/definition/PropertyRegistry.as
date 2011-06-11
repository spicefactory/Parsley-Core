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

package org.spicefactory.parsley.core.registry.definition {
import org.spicefactory.lib.reflect.ClassInfo;

[Deprecated(replacement="new configuration DSL")]
/**
 * @author Jens Halm
 */
public interface PropertyRegistry {
	
	function addValue (name:String, value:*) : PropertyRegistry;
	
	function addIdReference (name:String, id:String, required:Boolean = true) : PropertyRegistry;

	function addTypeReference (name:String, required:Boolean = true, type:ClassInfo = null) : PropertyRegistry;
	
	function removeValue (name:String) : void;
	
	function getValue (name:String) : *;

	function getAll () : Array;
		
}
}
