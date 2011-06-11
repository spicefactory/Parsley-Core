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

package org.spicefactory.parsley.dsl.lifecycle.impl {
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.registry.AsyncInitConfig;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionBuilderPart;
import org.spicefactory.parsley.dsl.lifecycle.AsyncInitBuilder;

/**
 * Default implementation of the AsyncInitBuilder interface.
 * 
 * @author Jens Halm
 */
public class DefaultAsyncInitBuilder implements AsyncInitBuilder, ObjectDefinitionBuilderPart {

	
	private static const log:Logger = LogContext.getLogger(DefaultAsyncInitBuilder);
	
	
	private var _completeEvent:String;
	private var _errorEvent:String;

	
	/**
	 * @inheritDoc
	 */
	public function completeEvent (type:String) : AsyncInitBuilder {
		_completeEvent = type;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function errorEvent (type:String) : AsyncInitBuilder {
		_errorEvent = type;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function apply (target:ObjectDefinition) : void {
		if (!(target is SingletonObjectDefinition) || SingletonObjectDefinition(target).lazy) {
			log.warn("AsyncInit only has an effect on non-lazy singletons " +
					"and will be ignored for " + target);
			return;
		}
		var config:AsyncInitConfig = new AsyncInitConfig();
		if (_completeEvent) {
			config.completeEvent = _completeEvent;
		}
		if (_errorEvent) {
			config.errorEvent = _errorEvent;
		}
		SingletonObjectDefinition(target).asyncInitConfig = config;
	}
	
	
}
}
