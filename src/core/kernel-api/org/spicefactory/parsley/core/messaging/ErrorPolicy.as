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

package org.spicefactory.parsley.core.messaging {

/**
 * Enumeration for the policy to apply for unhandled errors.
 * 
 * @author Jens Halm
 */
public class ErrorPolicy {
	
	
	/**
	 * Constant for the policy that causes errors thrown by message receivers to be rethrown.
	 */
	public static const RETHROW:ErrorPolicy = new ErrorPolicy("rethrow");

	/**
	 * Constant for the policy that causes message processing to abort 
	 * after an error has been thrown by a message receiver.
	 */
	public static const ABORT:ErrorPolicy = new ErrorPolicy("abort");

	/**
	 * Constant for the policy that causes message processing to continue 
	 * after an error has been thrown by a message receiver.
	 */
	public static const IGNORE:ErrorPolicy = new ErrorPolicy("ignore");

	
	private var _key:String;
	
	/**
	 * @private
	 */
	function ErrorPolicy (key:String) {
		_key = key;
	}

	/**
	 * @private
	 */
	public function toString () : String {
		return _key;
	}
	
	
}
}
