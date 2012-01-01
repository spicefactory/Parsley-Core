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
 
package org.spicefactory.parsley.core.binding {
import org.spicefactory.lib.reflect.ClassInfo;

/**
 * Subscribes to the values of one or more matching publishers.
 * 
 * @author Jens Halm
 */
public interface Subscriber {
	
	
	/**
	 * The type of the published value.
	 * May be an interface or supertype of the actual published value.
	 */
	function get type () : ClassInfo;
	
	/**
	 * The optional id of the published value.
	 * If omitted subscribers and publishers will solely be matched by type.
	 */
	function get id () : String;
	
	/**
	 * Notifies this suscriber that the published value has changed.
	 * 
	 * @param newValue the new value of the matching publisher
	 */
	function update (newValue:*) : void;
	
	/**
	 * Indicates whether there should only be one subscriber with
	 * the same type and id values for one particular implementation of this interface.
	 */
	function get unique () : Boolean; 
	
}
}
