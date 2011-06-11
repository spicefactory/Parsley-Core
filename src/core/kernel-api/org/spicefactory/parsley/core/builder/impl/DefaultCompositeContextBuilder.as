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

package org.spicefactory.parsley.core.builder.impl {
import org.spicefactory.parsley.core.factory.impl.LegacyFactoryRegistry;
import org.spicefactory.parsley.core.builder.AsyncObjectDefinitionBuilder;
import org.spicefactory.parsley.core.bootstrap.BootstrapDefaults;
import org.spicefactory.parsley.core.bootstrap.BootstrapManager;
import org.spicefactory.parsley.core.bootstrap.BootstrapProcessor;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.core.builder.CompositeContextBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.factory.FactoryRegistry;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;

import flash.display.DisplayObject;
import flash.system.ApplicationDomain;

[Deprecated(replacement="DefaultBootstrapManager")]
public class DefaultCompositeContextBuilder implements CompositeContextBuilder {
	
	private var manager:BootstrapManager;
	private var processor:BootstrapProcessor;
	
	function DefaultCompositeContextBuilder (viewRoot:DisplayObject = null, parent:Context = null, 
			domain:ApplicationDomain = null, description:String = null, manager:BootstrapManager = null) {
		this.manager = (manager) 
				? manager
				: BootstrapDefaults.config.services.bootstrapManager.newInstance() as BootstrapManager;
		this.manager.config.viewRoot = viewRoot;
		if (parent) this.manager.config.addParent(parent);
		this.manager.config.domain = domain;
		this.manager.config.description = description;
	}

	
	[Deprecated(replacement="addProcessor")]
	public function addBuilder (builder:ObjectDefinitionBuilder) : void {
		if (builder is AsyncObjectDefinitionBuilder) {
			addProcessor(new WrappedAsyncConfigurationProcessor(builder as AsyncObjectDefinitionBuilder)); 
		}
		else {
			addProcessor(new WrappedConfigurationProcessor(builder));
		}
	}
	
	public function addProcessor (processor:ConfigurationProcessor) : void {
		manager.config.addProcessor(processor);
	}
	
	public function addScope (name:String, inherited:Boolean = true, uuid:String = null) : void {
		manager.config.addScope(name, inherited, uuid);
	}
	
	private var _factories:FactoryRegistry;
	/**
	 * @inheritDoc
	 */
	public function get factories () : FactoryRegistry {
		if (!_factories) {
			_factories = new LegacyFactoryRegistry(manager.config);
		}
		return _factories;
	}
	
	public function build () : Context {
		prepareRegistry();
		return processor.process();
	}
	
	public function prepareRegistry () : ObjectDefinitionRegistry {
		if (!processor) {
			processor = manager.createProcessor();
		}
		return processor.info.registry;
	}
	

}
}

import org.spicefactory.parsley.core.bootstrap.AsyncConfigurationProcessor;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.builder.AsyncObjectDefinitionBuilder;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;

class WrappedConfigurationProcessor implements ConfigurationProcessor {

	private var legacyBuilder:ObjectDefinitionBuilder;
	
	function WrappedConfigurationProcessor (legacyBuilder:ObjectDefinitionBuilder) {
		this.legacyBuilder = legacyBuilder;
	}

	public function processConfiguration (registry:ObjectDefinitionRegistry) : void {
		legacyBuilder.build(registry);
	}
	
	public function toString () : String {
		return (legacyBuilder as Object).toString();
	}
}

class WrappedAsyncConfigurationProcessor extends EventDispatcher 
		implements org.spicefactory.parsley.core.bootstrap.AsyncConfigurationProcessor {

	private var legacyBuilder:AsyncObjectDefinitionBuilder;
	
	function WrappedAsyncConfigurationProcessor (legacyBuilder:AsyncObjectDefinitionBuilder) {
		this.legacyBuilder = legacyBuilder;
		legacyBuilder.addEventListener(Event.COMPLETE, dispatchEvent);
		legacyBuilder.addEventListener(ErrorEvent.ERROR, dispatchEvent);
	}
	
	public function processConfiguration (registry:ObjectDefinitionRegistry) : void {
		legacyBuilder.build(registry);
	}
	
	public function cancel () : void {
		legacyBuilder.cancel();
	}
	
	public override function toString () : String {
		return (legacyBuilder as Object).toString();
	}
}


