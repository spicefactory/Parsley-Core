/*
 * Copyright 2008-2009 the original author or authors.
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

package org.spicefactory.parsley.asconfig {

import org.spicefactory.parsley.asconfig.processor.ActionScriptConfigurationProcessor;
import org.spicefactory.parsley.core.bootstrap.BootstrapDefaults;
import org.spicefactory.parsley.core.bootstrap.BootstrapManager;
import org.spicefactory.parsley.core.context.Context;

import flash.display.DisplayObject;

/**
 * Static entry point methods for building a Context from ActionScript configuration classes.
 * 
 * <p>For details see 
 * <a href="http://www.spicefactory.org/parsley/docs/2.4/manual?page=config&amp;section=as3">3.6 ActionScript Configuration</a>
 * in the Parsley Manual.</p>
 * 
 * @author Jens Halm
 */
public class ActionScriptContextBuilder {
	
	
	/**
	 * Builds a Context from the specified ActionScript configuration class.
	 * The returned Context instance may not be fully initialized if it requires asynchronous operations.
	 * You can check its state with its <code>configured</code> and <code>initialized</code> properties.
	 * 
	 * @param configClass the class that contains the ActionScript configuration
	 * @param viewRoot the initial view root for dynamically wiring view objects
	 * @return a new Context instance, possibly not fully initialized yet
	 */
	public static function build (configClass:Class, viewRoot:DisplayObject = null) : Context {
		var manager:BootstrapManager = BootstrapDefaults.config.services.bootstrapManager.newInstance() as BootstrapManager;
		manager.config.viewRoot = viewRoot;
		manager.config.addProcessor(new ActionScriptConfigurationProcessor([configClass]));
		return manager.createProcessor().process();
	}
	
	
}
}

