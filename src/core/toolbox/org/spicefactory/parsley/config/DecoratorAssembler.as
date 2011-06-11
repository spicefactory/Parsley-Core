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

package org.spicefactory.parsley.config {
import org.spicefactory.lib.reflect.ClassInfo;

/**
 * Assembles decorators for a single ObjectDefinitionBuilder.
 * DecoratorAssemblers can be added to an ConfigurationFactory to assemble decorators in addition to the
 * ones provided by the core configuration mechanism in use (e.g. MXML or XML). The only builtin implementation
 * is responsible for processing metadata tags on classes, but any custom implementation may be added to a factory. 
 * 
 * @author Jens Halm
 */
public interface DecoratorAssembler {
	
	
	/**
	 * Assembles the definition decorators for the specified class.
	 * The returned array contains instances of the <code>ObjectDefinitionDecorator</code> interface.
	 * 
	 * @param type the class to assemble all decorators for
	 * @return decorators for the specified class
	 */	
	function assemble (type:ClassInfo) : Array;
	
	
}
}
