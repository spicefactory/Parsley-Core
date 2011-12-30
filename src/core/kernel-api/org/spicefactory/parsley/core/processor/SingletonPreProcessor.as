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

import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;
	
/**
 * Interface to be implemented by all object processors that need to do some
 * early setup just after the Context has finished processing its configuration
 * but before any target instance gets created.
 * 
 * <p>This mechanism can be used to set up a message handler proxy for example
 * to ensure that matching messages are received even if the sender gets instantiated
 * before the receiver.</p>
 * 
 * <p>It will be ignored when the processor gets applied to
 * a non-singleton object definition.</p>
 * 
 * @author Jens Halm
 */
public interface SingletonPreProcessor extends ObjectProcessor {
	
	
	/**
	 * Allows the preprocessing of the specified object definition even
	 * before the target instance has been created. This allows to perform
	 * tasks like message handler registration early in the Context lifecycle.
	 * 
	 * @param definition the definition of the target singleton instance
	 */
	function preProcess (definition: SingletonObjectDefinition): void;
	
	/**
	 * Invoked when the Context gets destroyed before the target instance
	 * gets initialized. This hook allows to perform any necessary cleanup
	 * that usually happens in the <code>destroy</code> method which will 
	 * not get invoked in such a case.
	 * 
	 * @param definition the definition of the target singleton instance
	 */
	function destroyBeforeInit (definition: SingletonObjectDefinition): void;
	
	
}
}
