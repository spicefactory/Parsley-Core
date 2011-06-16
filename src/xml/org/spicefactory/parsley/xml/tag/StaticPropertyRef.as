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

package org.spicefactory.parsley.xml.tag {
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;

import flash.system.ApplicationDomain;

/**
 * Represents the static-property-ref XML tag.
 * 
 * @author Jens Halm
 */
public class StaticPropertyRef {


	[Required]
	/**
	 * The type to extract the value of a static property from.
	 */
	public var type:Class;
	
	[Required]
	/**
	 * The name of the static property.
	 */
	public var property:String;
	
	
	/**
	 * Resolves the static property, using the specified domain for reflection.
	 * 
	 * @param domain the ApplicationDomain to use for reflection
	 * @return the value of the static property
	 */
	public function resolve (domain:ApplicationDomain) : * {
		var ci:ClassInfo = ClassInfo.forClass(type, domain);
		var p:Property = ci.getStaticProperty(property);
		if (p == null) {
			throw new IllegalArgumentError("Class "+ ci.name + " does not have a static property with name " + property);
		}
		else if (!p.readable) {
			throw new IllegalArgumentError(p.toString() + " is not readable");
		}
		return p.getValue(null);
	}

	
}
}
