/*
 * Copyright 2011 the original author or authors.
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

package org.spicefactory.parsley.core.scope {

/**
 * The definition for a single scope.
 * 
 * @author Jens Halm
 */
public class ScopeDefinition {
	
	
	private var _name:String;
	private var _inherited:Boolean;
	private var _uuid:String;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param name the name of the scope
	 * @param inherited whether this scope will be inherited by child Contexts
	 * @param uuid the globally unique id of this scope
	 * 
	 */
	function ScopeDefinition (name:String, inherited:Boolean, uuid:String) {
		_name = name;
		_inherited = inherited;
		_uuid = uuid;
	}
	
	/**
	 * The name of the scope.
	 */
	public function get name () : String {
		return _name;
	}
	
	
	/**
	 * Indicates whether this scope will be inherited by child Contexts.
	 */
	public function get inherited () : Boolean {
		return _inherited;
	}
	
	/**
	 * @copy org.spicefactory.parsley.core.scope.Scope#uuid
	 */
	public function get uuid () : String {
		return _uuid;
	}
	
}
}
