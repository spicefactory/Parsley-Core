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

package org.spicefactory.parsley.core.processor {

import org.spicefactory.parsley.core.lifecycle.ManagedObject;

/**
 * Responsible for processing an object when it gets initialized or destroyed.
 * This is one of the major hooks that configuration tags and other mechanisms
 * may use to configure an object. The <code>init</code> method usually
 * sets properties, registers message receivers or performs similar configuration
 * tasks for a target object.
 * 
 * <p>If the container should manage a separate processor instance for each target instance
 * the processor also has to implement the <code>StatefulProcessor</code> interface.</p>
 * 
 * @author Jens Halm
 */
public interface ObjectProcessor {
	
	
	/**
	 * Invoked during initialization of the target instance.
	 * Implementations will usually set properties, registers message receivers or performs similar configuration
 	 * tasks for the target instance managed by this processor.
 	 * 
 	 * @param target the target instance that is getting initialized
	 */
	function init (target: ManagedObject) : void;
	
	/**
	 * Invoked when the target instance gets removed from the Context.
	 * Implementations will usually unregister message receivers, unwatch bindings, remove listeners
	 * or perform similar disposal tasks.
	 * 
	 * @param target the target instance that is getting removed from the Context 
	 */
	function destroy (target: ManagedObject) : void;
	
	
}
}
