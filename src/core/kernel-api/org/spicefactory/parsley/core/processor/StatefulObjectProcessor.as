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
package org.spicefactory.parsley.core.processor {


/**
 * Interface to be implemented by all object processors that keep state internally
 * that is tied to one specific target instance. An example is creating a message
 * receiver for a target instance and remembering it so that it can be unregistered
 * when the object gets removed.
 * 
 * @author Jens Halm
 */
public interface StatefulObjectProcessor extends ObjectProcessor {
	
	
	/**
	 * Creates a clone of this processor by omitting all
	 * internal state that is tied to one particular target instance.
	 * 
	 * @return a clone of this processor
	 */
	function clone (): StatefulObjectProcessor;
	
	
}
}
