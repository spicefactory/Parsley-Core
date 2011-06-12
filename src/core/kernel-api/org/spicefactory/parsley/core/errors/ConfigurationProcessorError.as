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
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;

/**
 * Error thrown while processing a <code>ConfigurationProcessor</code>.
 * 
 * @author Jens Halm
 */
public class ConfigurationProcessorError extends CompoundError {


	private var _processor:ConfigurationProcessor;


	/**
	 * Create a new instance.
	 * 
	 * @param processor the processor that produced the Error
	 * @param causes the causes of this Error
	 * @param message the error message
	 */
	public function ConfigurationProcessorError (processor:ConfigurationProcessor, causes:Array = null, message:String = "") {
		super(getMessage(processor, message), causes);
		_processor = processor;
	}
	
	private function getMessage (processor:ConfigurationProcessor, message:String) : String {
		var msg:String = "One or more errors processing " + processor;
		if (message != null) {
			return msg += ": " + message;
		}
		return msg;
	}
	
	/**
	 * The processor that produced the Error.
	 */
	public function get processor () : ConfigurationProcessor {
		return _processor;
	}
	
	
}
}
