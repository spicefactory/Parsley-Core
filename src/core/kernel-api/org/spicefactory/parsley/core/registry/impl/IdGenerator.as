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

package org.spicefactory.parsley.core.registry.impl {

/**
 * Simple generator for internal object ids in case they are not specified by the user.
 * 
 * @author Jens Halm
 */
public class IdGenerator {


	private static var _nextId:int = 1;
	

	/**	
	 * The next available object id.
	 */
	public static function get nextObjectId () : String {
		return "[[Object " + _nextId++ + "]]";
	}
	
	
}

}
