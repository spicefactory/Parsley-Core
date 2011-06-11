/*
 * Copyright 2009 the original author or authors.
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

package org.spicefactory.parsley.core.factory.impl {
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.core.factory.FactoryRegistry;
import org.spicefactory.parsley.core.factory.MessageRouterFactory;
import org.spicefactory.parsley.core.factory.ViewManagerFactory;
import org.spicefactory.parsley.core.messaging.MessageSettings;
import org.spicefactory.parsley.core.scope.ScopeExtensionRegistry;
import org.spicefactory.parsley.core.view.ViewSettings;

[Deprecated]
public class LegacyFactoryRegistry implements FactoryRegistry {
	
	private var config:BootstrapConfig;
	
	private var _viewManager:ViewManagerFactory;
	private var _messageRouter:MessageRouterFactory;
	
	function LegacyFactoryRegistry (config:BootstrapConfig) {
		this.config = config;
	}

	public function get viewManager () : ViewManagerFactory {
		if (_viewManager == null) {
			_viewManager = new DefaultViewManagerFactory(config.viewSettings);
		}
		return _viewManager;
	}
	
	public function get messageRouter () : MessageRouterFactory {
		if (_messageRouter == null) {
			_messageRouter = new DefaultMessageRouterFactory(config.messageSettings);
		}
		return _messageRouter;
	}
	
	public function get scopeExtensions () : ScopeExtensionRegistry {
		return config.scopeExtensions;
	}
	
	public function get messageSettings () : MessageSettings {
		return config.messageSettings;
	}

	public function get viewSettings () : ViewSettings {
		return config.viewSettings;
	}
	
}
}

import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.parsley.core.events.ViewConfigurationEvent;
import org.spicefactory.parsley.core.factory.MessageRouterFactory;
import org.spicefactory.parsley.core.factory.ViewManagerFactory;
import org.spicefactory.parsley.core.messaging.ErrorPolicy;
import org.spicefactory.parsley.core.messaging.MessageSettings;
import org.spicefactory.parsley.core.messaging.command.CommandFactory;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;
import org.spicefactory.parsley.core.view.ViewAutowireFilter;
import org.spicefactory.parsley.core.view.ViewSettings;

import flash.events.Event;

class DefaultViewManagerFactory implements ViewManagerFactory {
	
	private var settings:ViewSettings;
	
	private var defaultRemovedEvent:String = Event.REMOVED_FROM_STAGE;
	private var customRemovedEvent:String = "removeView";
	private var defaultAddedEvent:String = ViewConfigurationEvent.CONFIGURE_VIEW;


	function DefaultViewManagerFactory (settings:ViewSettings) {
		this.settings = settings;
	}

	public function get viewRootRemovedEvent () : String {
		return (settings.autoremoveViewRoots) ? defaultRemovedEvent : customRemovedEvent;
	}
	
	public function set viewRootRemovedEvent (viewRootRemovedEvent:String) : void {
		settings.autoremoveViewRoots = (viewRootRemovedEvent == defaultRemovedEvent);
	}

	public function get componentRemovedEvent () : String {
		return (settings.autoremoveComponents) ? defaultRemovedEvent : customRemovedEvent;
	}
	
	public function set componentRemovedEvent (componentRemovedEvent:String) : void {
		settings.autoremoveComponents = (viewRootRemovedEvent == defaultRemovedEvent);
	}
	
	public function get componentAddedEvent () : String {
		return defaultAddedEvent;
	}
	
	public function set componentAddedEvent (componentAddedEvent:String) : void {
		if (componentAddedEvent != defaultAddedEvent) {
			throw new IllegalArgumentError("Custom event types for componentAddedEvent are no longer supported");
		}
	}
	
	public function get autowireFilter () : ViewAutowireFilter {
		return settings.autowireFilter;
	}
	
	public function set autowireFilter (value:ViewAutowireFilter) : void {
		settings.autowireFilter = value;
	}
	
	
}

class DefaultMessageRouterFactory implements MessageRouterFactory {

	private var settings:MessageSettings;
	
	function DefaultMessageRouterFactory (settings:MessageSettings) {
		this.settings = settings;
	}

	public function get unhandledError () : ErrorPolicy {
		return settings.unhandledError;
	}

	public function set unhandledError (policy:ErrorPolicy) : void {
		settings.unhandledError = policy;
	}

	public function addErrorHandler (handler:MessageErrorHandler) : void {
		settings.addErrorHandler(handler);
	}
	
	public function addCommandFactory (type:Class, factory:CommandFactory) : void {
		settings.commandFactories.addCommandFactory(type, factory);
	}

	
}
