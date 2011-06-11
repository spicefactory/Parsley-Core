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
import flash.events.IEventDispatcher;
import org.spicefactory.parsley.core.context.Context;

/**
 * Represents an object that controls the lifecycle of one particular view instance.
 * The primary purpose of this lifecycle instance is to invoke the <code>init</code>
 * and <code>destroy</code> methods of the associated <code>ViewProcessor</code>
 * based on the lifecycle of the view.
 * 
 * <p>Parsley comes with two default implementations. One controls the lifecycle
 * of the view based on stage events (<code>addedToStage</code> and <code>removedFromStage</code>)
 * the other based on custom events (<code>configureView</code> and <code>removeView</code>)
 * dispatched by the view instance. The <code>autoremoveComponents</code> and <code>autoremoveViewRoots</code>
 * attributes of the <code>&lt;ViewSettings&gt;</code> tag (or the <code>ViewSettings</code> class in the 
 * ContextBuilder API) control which of the two built-in lifecycles will be used.</p>
 * 
 * <p>A custom lifecycle can be specified with the <code>&lt;ViewLifecycle&gt;</code> tag inside
 * the <code>&lt;ContextBuilder&gt;</code> tag.</p>
 * 
 * @author Jens Halm
 */
public interface ViewLifecycle extends IEventDispatcher {
	
	
	/**
	 * Starts controlling the lifecycle of the view instance contained in the specified
	 * configuration instance. The primary purpose of this lifecycle instance is to invoke the <code>init</code>
 	 * and <code>destroy</code> methods of the associated <code>ViewProcessor</code>
 	 * based on the lifecycle of the view.
 	 * 
 	 * @param config the view configuration that holds the view this lifecycle instance should control
 	 * @param context the Context associated with this view
	 */
	function start (config:ViewConfiguration, context:Context) : void;

	/**
	 * Stops controlling the lifecycle of the view instance.
	 * After this method has been called this lifecycle instance should no longer
	 * invoke the <code>init</code> and <code>destroy</code> methods of the associated
	 * <code>ViewProcessor</code> and free all resources it is holding.
	 */
	function stop () : void;
	
	
}
}
