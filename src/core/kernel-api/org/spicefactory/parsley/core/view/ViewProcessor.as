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

package org.spicefactory.parsley.core.view {
import org.spicefactory.parsley.core.context.Context;

/**
 * Responsible for processing a single view instance.
 * The tasks performed by a processor may vary from adding the view to the Context
 * or just injecting an object from the Context into the view without turning
 * it into a managed object.
 * 
 * <p>The associated <code>ViewLifecycle</code> instance controls when the <code>init</code> and
 * <code>destroy</code> methods of this processor get invoked.</p> 
 * 
 * @author Jens Halm
 */
public interface ViewProcessor {
	
	/**
	 * Processes the target instance of the specified view configuration.
	 * Depending on the <code>reuse</code> property of the view configuration
	 * this method may get invoked multiple time for the same view target.
	 * 
	 * @param config the view configuration that holds the target this instance should process
 	 * @param context the Context associated with the target
	 */
	function init (config:ViewConfiguration, context:Context) : void;
	
	/**
	 * Disposes all configuration steps this processor has done in the init method.
	 */
	function destroy () : void;
	
}
}
