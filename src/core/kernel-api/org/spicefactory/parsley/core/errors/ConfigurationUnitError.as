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

package org.spicefactory.parsley.core.errors {
import org.spicefactory.lib.errors.CompoundError;

/**
 * Error thrown for a particular configuration unit.
 * 
 * @author Jens Halm
 */
public class ConfigurationUnitError extends CompoundError {


	private var _configUnit:Object;


	/**
	 * Create a new instance.
	 * 
	 * @param configUnit the configuration unit that produced the error(s) or a string representation of that unit
	 * @param causes the causes of this Error
	 * @param message the error message
	 */
	public function ConfigurationUnitError (configUnit:Object, causes:Array = null, message:String = "") {
		super(getMessage(configUnit, message), causes);
		_configUnit = configUnit;
	}
	
	private function getMessage (configUnit:Object, message:String) : String {
		var msg:String = "One or more errors processing " + configUnit;
		if (message != null) {
			return msg += ": " + message;
		}
		return msg;
	}
	
	/**
	 * The configuration unit that produced the error(s) or a string representation of that unit.
	 */
	public function get configUnit () : Object {
		return _configUnit;
	}
	
	
}
}
