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

package org.spicefactory.parsley.core.view.handler {

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.util.ArrayUtil;
import org.spicefactory.lib.util.Flag;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ViewConfigurationEvent;
import org.spicefactory.parsley.core.events.ViewLifecycleEvent;
import org.spicefactory.parsley.core.state.GlobalState;
import org.spicefactory.parsley.core.view.ViewAutowireMode;
import org.spicefactory.parsley.core.view.ViewConfiguration;
import org.spicefactory.parsley.core.view.ViewLifecycle;
import org.spicefactory.parsley.core.view.ViewProcessor;
import org.spicefactory.parsley.core.view.ViewRootHandler;
import org.spicefactory.parsley.core.view.ViewSettings;
import org.spicefactory.parsley.core.view.impl.DefaultViewConfiguration;
import org.spicefactory.parsley.core.view.lifecycle.AutoremoveLifecycle;
import org.spicefactory.parsley.core.view.lifecycle.CustomEventLifecycle;
import org.spicefactory.parsley.core.view.metadata.Autoremove;
import org.spicefactory.parsley.core.view.util.ContextAwareEventHandler;
import org.spicefactory.parsley.core.view.util.ViewDefinitionLookup;

import flash.display.DisplayObject;
import flash.events.Event;

/**
 * ViewRootHandler implementation that deals with bubbling events from components that explicitly
 * signal that they wish to get wired to the Context or that are getting autowired.
 * 
 * @author Jens Halm
 */
public class ViewConfigurationHandler implements ViewRootHandler {

	
	private static const log:Logger = LogContext.getLogger(ViewConfigurationHandler);
	
	private static const LEGACY_CONFIGURE_EVENT:String = "configureIOC";

	
	private var explicitHandler:ContextAwareEventHandler;
	private var autowireHandler:ContextAwareEventHandler;
	private var activeConfigs:Array = new Array();
	
	private var context:Context;
	private var settings:ViewSettings;
	

	/**
	 * @inheritDoc
	 */	
	public function init (context:Context, settings:ViewSettings) : void {
		this.context = context;
		this.settings = settings;
		this.explicitHandler = new ContextAwareEventHandler(context, processExplicitEvent);
		this.autowireHandler = new ContextAwareEventHandler(context, processAutowireEvent);
	}

	/**
	 * @inheritDoc
	 */
	public function destroy () : void {
		explicitHandler.dispose();
		autowireHandler.dispose();
		for each (var config:ViewConfiguration in activeConfigs) {
			disposeLifecycle(config);
		}
		activeConfigs = null;
	}
	
	/**
	 * @inheritDoc
	 */
	public function addViewRoot (view:DisplayObject) : void {
		view.addEventListener(ViewConfigurationEvent.CONFIGURE_VIEW, handleExplicitEvent);
		view.addEventListener(LEGACY_CONFIGURE_EVENT, handleExplicitEvent);
		if (settings.autowireComponents) {
			view.addEventListener(settings.autowireFilter.eventType, prefilterView, true);
			view.addEventListener(settings.autowireFilter.eventType, prefilterView);
			view.addEventListener(ViewConfigurationEvent.AUTOWIRE_VIEW, handleAutowireEvent);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeViewRoot (view:DisplayObject) : void {
		view.removeEventListener(ViewConfigurationEvent.CONFIGURE_VIEW, handleExplicitEvent);
		view.removeEventListener(LEGACY_CONFIGURE_EVENT, handleExplicitEvent);
		if (settings.autowireComponents) {
			view.removeEventListener(settings.autowireFilter.eventType, prefilterView, true);
			view.removeEventListener(settings.autowireFilter.eventType, prefilterView);
			view.removeEventListener(ViewConfigurationEvent.AUTOWIRE_VIEW, handleAutowireEvent);
		}
	}
	
	
	private function prefilterView (event:Event) : void {
		if (!AutowirePrefilterCache.addEvent(event)) return;
		var view:DisplayObject = event.target as DisplayObject;
		if (settings.autowireFilter.prefilter(view) && !GlobalState.objects.isManaged(view)) {
			view.dispatchEvent(ViewConfigurationEvent.forAutowiring(view));
		}
	}
	
	private function handleAutowireEvent (event:Event) : void {
		event.stopImmediatePropagation();
		autowireHandler.handleEvent(event);
	}
	
	private function handleExplicitEvent (event:Event) : void {
		event.stopImmediatePropagation();
		if (event is ViewConfigurationEvent) {
			ViewConfigurationEvent(event).markAsReceived();
		}
		explicitHandler.handleEvent(event);
	}
	
	private function processAutowireEvent (event:ViewConfigurationEvent) : void {
		for each (var config:ViewConfiguration in event.configurations) {
			var mode:ViewAutowireMode = settings.autowireFilter.filter(config.view);
			if (mode == ViewAutowireMode.NEVER) {
				return;
			}
			if (mode == ViewAutowireMode.CONFIGURED && config.definition == null) {
				config.definition = ViewDefinitionLookup.findMatchingDefinition(config, context);
				if (config.definition == null) {
					return;
				}
				if (!config.autoremove) {
					setAutoremoveFromMetadata(config);
				}
			}
			processConfiguration(config);
		}
	}
	
	private function setAutoremoveFromMetadata (config:ViewConfiguration) : void {
		var info:ClassInfo = ClassInfo.forInstance(config.view, context.domain);
		if (info.hasMetadata(Autoremove)) {
			config.autoremove = new Flag((info.getMetadata(Autoremove)[0] as Autoremove).value);
		} 
	}
	
	private function processExplicitEvent (event:Event) : void {
		var configs:Array = (event is ViewConfigurationEvent)
			? ViewConfigurationEvent(event).configurations
			: [new DefaultViewConfiguration(DisplayObject(event.target))];
		
		for each (var config:ViewConfiguration in configs) {
			processConfiguration(config);
		}
		
		if (event is ViewConfigurationEvent) {
			ViewConfigurationEvent(event).markAsCompleted();
		}
	}
	
	private function processConfiguration (config:ViewConfiguration) : void {
		activeConfigs.push(config);
		log.debug("Process view '{0}' with {1}", config.target, context);
		if (!config.lifecycle) {
			config.lifecycle = getLifecycle(config);
		}
		if (!config.processor) {
			config.processor = settings.viewProcessor.newInstance() as ViewProcessor;
		}
		config.processor.init(config, context);
		if (config.lifecycle) {
			config.lifecycle.addEventListener(ViewLifecycleEvent.DESTROY_VIEW, viewDestroyed);
			if (config.reuse) {
				config.lifecycle.addEventListener(ViewLifecycleEvent.INIT_VIEW, viewInitialized);
			}
			config.lifecycle.start(config, context);
		}
	}
	
	private function viewDestroyed (event:ViewLifecycleEvent) : void {
		event.configuration.processor.destroy();
		if (!event.configuration.reuse) {
			disposeLifecycle(event.configuration);
			ArrayUtil.remove(activeConfigs, event.configuration);
		}
	}
	
	private function viewInitialized (event:ViewLifecycleEvent) : void {
		event.configuration.processor.init(event.configuration, context);
	}
	
	private function disposeLifecycle (config:ViewConfiguration) : void {
		if (config.lifecycle) {
			config.lifecycle.stop();
			config.lifecycle.removeEventListener(ViewLifecycleEvent.DESTROY_VIEW, viewDestroyed);
			config.lifecycle.removeEventListener(ViewLifecycleEvent.INIT_VIEW, viewInitialized);
		}
	}
	
	private function getLifecycle (config:ViewConfiguration) : ViewLifecycle {
		var lifecycle:ViewLifecycle = settings.newViewLifecycle(config.view);
		if (!lifecycle) {
			var autoremove:Boolean 
					= (config.autoremove) 
					? config.autoremove.value : 
					settings.autoremoveComponents;
			if (autoremove) {
				lifecycle = new AutoremoveLifecycle();
			}
			else {
				lifecycle = new CustomEventLifecycle();
			}
		}
		return lifecycle;
	}
	
	
}
}
	
