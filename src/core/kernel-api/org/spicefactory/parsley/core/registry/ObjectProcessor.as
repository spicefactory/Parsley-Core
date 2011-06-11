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

package org.spicefactory.parsley.core.registry {

/**
 * Responsible for processing an object when it gets initialized or destroyed.
 * This is one of the major hooks that configuration tags and other mechanisms
 * may use to configure an object. The <code>preInit</code> method usually
 * sets properties, registers message receivers or performs similar configuration
 * tasks for a target object.
 * 
 * <p>The container will manage a separate processor instance for each target instance.
 * Therefor the target instance will not be passed to the two lifecycle methods as it
 * will usually be set at the time the processor gets initialized, most likely through
 * an <code>ObjectProcessorFactory</code>.</p>
 * 
 * @author Jens Halm
 */
public interface ObjectProcessor {
	
	
	/**
	 * Invoked before the init method of the target instance will be invoked.
	 * Implementations will usually set properties, registers message receivers or performs similar configuration
 	 * tasks for the target instance managed by this processor.
	 */
	function preInit () : void;
	
	/**
	 * Invoked after the destroy method of the target instance has been invoked.
	 * Implementations will usually unregister message receivers, unwatch bindings, remove listeners
	 * or perform similar disposal tasks.
	 */
	function postDestroy () : void;
	
	
}
}
