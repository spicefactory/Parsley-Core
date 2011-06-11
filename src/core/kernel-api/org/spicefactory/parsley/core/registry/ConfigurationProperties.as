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

package org.spicefactory.parsley.core.registry {
import org.spicefactory.parsley.core.context.LookupStatus;

/**
 * Allows to read and write properties which may be used to build or process ObjectDefinitions
 * 
 * @author Jens Halm
 */
public interface ConfigurationProperties {

	/**
	 * Sets a property value.
	 * 
	 * @param name the name of the property
	 * @param value the value of the property
	 */
	function setValue (name:String, value:Object) : void;

	/**
	 * Returns the value of the property with the specified name or undefined if no such property exists.
	 * 
	 * @param name the name of the property 
	 * @param status optional paramater to avoid duplicate lookups, for internal use only 
	 * @return the value of the property
	 */
	function getValue (name:String, status:LookupStatus = null) : Object;
	
	/**
	 * Removes the property with the specifie name.
	 * 
	 * @param name the name of the property
	 */
	function removeValue (name:String) : void;
	
}
}
