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

/**
 * Represents the variable XML tag, defining a single variable value. This value may be referenced in 
 * XML text nodes and attributes with the notation <code>${variablename}</code>.
 * 
 * @author Jens Halm
 */
public class Variable {

	
	[Required]
	/**
	 * The name of the variable.
	 */
	public var name:String;
	
	[Required]
	/**
	 * The value of the variable.
	 */
	public var value:String;
	
	
}
}
