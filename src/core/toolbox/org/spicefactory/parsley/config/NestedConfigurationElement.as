/*
 * Copyright 2010 the original author or authors.
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

package org.spicefactory.parsley.config {
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;

/**
 * Represents a nested configuration element that needs to be resolved before being passed to 
 * an ObjectDefinition. Can be used for any tag that specifies a nested value
 * in an ObjectDefinition, like those tags nested within <code>ConstructorArgs</code>
 * or <code>Array</code> tags. For any nested tags that do not implement this 
 * interface the tag instance itself will be used as the value.
 * 
 * @author Jens Halm
 */
public interface NestedConfigurationElement {
	
	
	/**
	 * Returns the resolved value represented by this element.
	 * 
	 * @param registry the registry associated with this element
	 * @return the resolved value represented by this element
	 */
	function resolve (registry: ObjectDefinitionRegistry): Object;
	
	
}
}
