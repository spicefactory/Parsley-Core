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

package org.spicefactory.parsley.core.view {

/**
 * Enumeration for the selection mode of autowired views.
 * 
 * @author Jens Halm
 */
public class ViewAutowireMode {
	
	
	/**
	 * Constant for indicating that a view should always be wired to the Context,
	 * no matter whether MXML/XML configuration for that view exists.
	 */
	public static const ALWAYS:ViewAutowireMode = new ViewAutowireMode("always");

	/**
	 * Constant for indicating that a view should only be wired to the Context
	 * if MXML/XML configuration for that view exists.
	 */
	public static const CONFIGURED:ViewAutowireMode = new ViewAutowireMode("configured");

	/**
	 * Constant for indicating that a view should never be wired to the Context,
	 * even if MXML/XML configuration for that view exists.
	 */
	public static const NEVER:ViewAutowireMode = new ViewAutowireMode("never");

	
	private var _key:String;
	
	/**
	 * @private
	 */
	function ViewAutowireMode (key:String) {
		_key = key;
	}
	
	/**
	 * The unique key representing this enumeration value.
	 */
	public function get key () : String {
		return _key;
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return _key;
	}
	
	
}
}
