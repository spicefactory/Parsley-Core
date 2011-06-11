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

package org.spicefactory.parsley.core.view.processor {
import org.spicefactory.parsley.core.state.GlobalState;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.view.ViewConfiguration;
import org.spicefactory.parsley.core.view.ViewProcessor;
import org.spicefactory.parsley.core.view.util.ViewDefinitionLookup;

/**
 * Default implementation of the ViewProcessor interface that simply adds the target to the Context.
 * 
 * @author Jens Halm
 */
public class DefaultViewProcessor implements ViewProcessor {

	
	private static const log:Logger = LogContext.getLogger(DefaultViewProcessor);
	
	
	private var dynamicObject:DynamicObject;
	
	
	/**
	 * @inheritDoc
	 */
	public function init (config:ViewConfiguration, context:Context) : void {
		if (GlobalState.objects.isManaged(config.target)) {
			log.warn("Target object is already managed: {0}", config.target);
		}
		if (!config.definition) {
			config.definition = ViewDefinitionLookup.findMatchingDefinition(config, context);
		}
		dynamicObject = context.addDynamicObject(config.target, config.definition);
		if (log.isDebugEnabled()) {
			log.debug("Add view '{0}' to {1}", dynamicObject.instance, dynamicObject.context);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function destroy () : void {
		if (log.isDebugEnabled()) {
			log.debug("Remove view '{0}' from {1}", dynamicObject.instance, dynamicObject.context);
		}
		dynamicObject.remove();
	}
	
	
}
}
