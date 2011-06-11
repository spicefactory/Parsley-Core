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
import org.spicefactory.parsley.core.registry.ObjectDefinition;

/**
 * Error thrown while processing an <code>ObjectDefinition</code>.
 * 
 * @author Jens Halm
 */
public class ObjectDefinitionError extends CompoundError {


	private var _definition:ObjectDefinition;


	/**
	 * Create a new instance.
	 * 
	 * @param definition the definition being processed
	 * @param causes the causes of this Error
	 * @param message the error message
	 */
	public function ObjectDefinitionError (definition:ObjectDefinition, causes:Array = null, message:String = "") {
		super(getMessage(definition, message), causes);
		_definition = definition;
	}
	
	private function getMessage (definition:ObjectDefinition, message:String) : String {
		var msg:String = "One or more errors processing " + definition;
		if (message != null) {
			return msg += ": " + message;
		}
		return msg;
	}
	
	/**
	 * The definition that has been processed while the Error was thrown.
	 */
	public function get definition ():ObjectDefinition {
		return _definition;
	}
	
	
}
}
