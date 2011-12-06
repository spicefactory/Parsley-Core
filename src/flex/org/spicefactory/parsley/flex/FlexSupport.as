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

package org.spicefactory.parsley.flex {

import org.spicefactory.lib.command.light.LightCommandAdapter;
import org.spicefactory.lib.command.result.ResultProcessors;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.logging.flex.FlexLogFactory;
import org.spicefactory.parsley.binding.impl.PropertyPublisher;
import org.spicefactory.parsley.core.bootstrap.BootstrapDefaults;
import org.spicefactory.parsley.flex.binding.FlexPropertyWatcher;
import org.spicefactory.parsley.flex.command.AsyncTokenResultProcessor;
import org.spicefactory.parsley.flex.modules.FlexApplicationDomainProvider;

import mx.rpc.AsyncToken;
import mx.rpc.Fault;

/**
 * Initializes all Flex specific features which are not built into the Parsley Core, like the support for Modules,
 * for Flex Logging and for Commands based on AsyncToken.
 * 
 * @author Jens Halm
 */
public class FlexSupport {
	
	
	private static const log:Logger = LogContext.getLogger(FlexSupport);
	
	
	private static var initialized:Boolean = false;
	
	/**
	 * Initializes the core Flex specific features of the IOC container. Usually there is no need for application code to call this
	 * method directly. It will be invoked by the standard <code>&lt;parsley:ContextBuilder/&gt;</code> tag, 
	 * by all static entry points in the <code>FlexContextBuilder</code>
	 * class and also by the DSL-based ContextBuilder. In rare cases where you only use some other 
	 * configuration mechanism like XML
	 * for your Flex application it may be necessary to invoke this method manually.
	 */
	public static function initialize () : void {
		if (initialized) return;
		
		log.info("Initialize Flex Support");
		initialized = true;
		
		ResultProcessors.forResultType(AsyncToken).processorType(AsyncTokenResultProcessor);
		LightCommandAdapter.addErrorType(Fault);
		
		if (LogContext.factory == null) LogContext.factory = new FlexLogFactory();
		BootstrapDefaults.config.domainProvider = new FlexApplicationDomainProvider();
		PropertyPublisher.propertyWatcherType = FlexPropertyWatcher;
	}
	
	
}
}
