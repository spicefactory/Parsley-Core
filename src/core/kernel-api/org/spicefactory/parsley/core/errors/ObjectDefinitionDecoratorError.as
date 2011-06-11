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
import org.spicefactory.lib.errors.NestedError;
import org.spicefactory.parsley.core.registry.ObjectDefinitionDecorator;

[Deprecated]
/**
 * @author Jens Halm
 */
public class ObjectDefinitionDecoratorError extends NestedError {

	private var _decorator:ObjectDefinitionDecorator;

	public function ObjectDefinitionDecoratorError (decorator:ObjectDefinitionDecorator, cause:Error = null, message:String = "") {
		super(getMessage(decorator, message), cause);
		_decorator = decorator;
	}
	
	private function getMessage (decorator:ObjectDefinitionDecorator, message:String) : String {
		var msg:String = "Error processing " + decorator;
		if (message != null) {
			return msg += ": " + message;
		}
		return msg;
	}
	
	public function get decorator () : ObjectDefinitionDecorator {
		return _decorator;
	}
	
}
}
