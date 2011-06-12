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

package org.spicefactory.parsley.core.bootstrap.impl {
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.binding.BindingSupport;
import org.spicefactory.parsley.core.bootstrap.ApplicationDomainProvider;
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.core.bootstrap.BootstrapDefaults;
import org.spicefactory.parsley.core.bootstrap.BootstrapInfo;
import org.spicefactory.parsley.core.bootstrap.BootstrapProcessor;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.core.bootstrap.ServiceRegistry;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ContextConfigurationEvent;
import org.spicefactory.parsley.core.events.ContextCreationEvent;
import org.spicefactory.parsley.core.messaging.MessageSettings;
import org.spicefactory.parsley.core.messaging.impl.DefaultMessageSettings;
import org.spicefactory.parsley.core.registry.ConfigurationProperties;
import org.spicefactory.parsley.core.scope.ScopeDefinition;
import org.spicefactory.parsley.core.scope.ScopeExtensionRegistry;
import org.spicefactory.parsley.core.scope.ScopeInfoRegistry;
import org.spicefactory.parsley.core.scope.ScopeName;
import org.spicefactory.parsley.core.scope.impl.DefaultScopeExtensionRegistry;
import org.spicefactory.parsley.core.scope.impl.DefaultScopeInfoRegistry;
import org.spicefactory.parsley.core.state.GlobalState;
import org.spicefactory.parsley.core.state.manager.GlobalStateManager;
import org.spicefactory.parsley.core.view.ViewSettings;
import org.spicefactory.parsley.core.view.impl.DefaultViewSettings;

import flash.display.DisplayObject;
import flash.system.ApplicationDomain;

/**
 * Default implementation of the BootstrapConfig interface.
 * 
 * @author Jens Halm
 */
public class DefaultBootstrapConfig implements BootstrapConfig {
	
	
	private static const log:Logger = LogContext.getLogger(DefaultBootstrapManager);
	
	
	private var newScopes:Array = new Array();
	private var processors:Array = new Array();
	private var parentConfigs:Array = new Array();
	
	private var stateManager:GlobalStateManager = GlobalStateAccessor.stateManager;
	
	
	private var _services:DefaultServiceRegistry = new DefaultServiceRegistry();
	
	/**
	 * @inheritDoc
	 */
	public function get services () : ServiceRegistry {
		return _services;
	}
	
	
	private var _viewSettings:DefaultViewSettings = new DefaultViewSettings();
	
	/**
	 * @inheritDoc
	 */
	public function get viewSettings () : ViewSettings {
		return _viewSettings;
	}
	
	
	private var _messageSettings:DefaultMessageSettings = new DefaultMessageSettings();
	
	/**
	 * @inheritDoc
	 */
	public function get messageSettings () : MessageSettings {
		return _messageSettings;
	}


	private var _scopeExtensions:DefaultScopeExtensionRegistry = new DefaultScopeExtensionRegistry();
	
	/**
	 * @inheritDoc
	 */
	public function get scopeExtensions () : ScopeExtensionRegistry {
		return _scopeExtensions;
	}
	
	
	private var _properties:DefaultProperties = new DefaultProperties();
	
	/**
	 * @inheritDoc
	 */
	public function get properties () : ConfigurationProperties {
		return _properties;
	}

	
	private var _domain:ApplicationDomain;
	
	/**
	 * @inheritDoc
	 */
	public function get domain () : ApplicationDomain {
		return _domain;
	}
	
	/**
	 * @inheritDoc
	 */
	public function set domain (value:ApplicationDomain) : void {
		_domain = value;
	}
	
	
	private var _domainProvider:ApplicationDomainProvider;
	
	/**
	 * @inheritDoc
	 */
	public function get domainProvider () : ApplicationDomainProvider {
		return (_domainProvider) ? _domainProvider : (parentConfigs.length) ? parentConfigs[0].domainProvider : null;
	}
	
	/**
	 * @inheritDoc
	 */
	public function set domainProvider (value:ApplicationDomainProvider) : void {
		_domainProvider = value;
	}
	

	private var _parents:Array = new Array();
	
	/**
	 * @inheritDoc
	 */
	public function get parents () : Array {
		return _parents.concat();
	}
	
	/**
	 * @inheritDoc
	 */
	public function addParent (parent:Context) : void {
		_parents.push(parent);
	}
	

	private var _findParentInView:Boolean = true; 
	
	public function get findParentInView () : Boolean {
		return _findParentInView;
	}
	
	public function set findParentInView (value:Boolean) : void {
		_findParentInView = value;
	}

	
	private var _viewRoot:DisplayObject;
	
	/**
	 * @inheritDoc
	 */
	public function get viewRoot () : DisplayObject {
		return _viewRoot;
	}
	
	/**
	 * @inheritDoc
	 */
	public function set viewRoot (value:DisplayObject) : void {
		_viewRoot = value;
	}


	private var _description:String;
	
	/**
	 * @inheritDoc
	 */
	public function get description () : String {
		return _description;
	}

	/**
	 * @inheritDoc
	 */
	public function set description (value:String) : void {
		_description = value;
	}


	private var _localScopeUuid:String;
	/**
	 * @inheritDoc
	 */
	public function get localScopeUuid () : String {
		return _localScopeUuid;
	}

	/**
	 * @inheritDoc
	 */
	public function set localScopeUuid (value:String) : void {
		_localScopeUuid = value;
	}
	
	/**
	 * @inheritDoc
	 */
	public function addScope (name:String, inherited:Boolean = true, uuid:String = null) : void {
		newScopes.push(createScopeDefinition(name, inherited, uuid));
	}
	
	/**
	 * @inheritDoc
	 */
	public function addProcessor (processor:ConfigurationProcessor) : void {
		processors.push(processor);
	}
	
	
	/**
	 * @private
	 */
	internal function createProcessor () : BootstrapProcessor {
		//new FlexApplicationDomainProvider();
		BindingSupport.initialize();
		findParent();
		var info:BootstrapInfo = prepareBootstrapInfo();
		var processor:BootstrapProcessor = new DefaultBootstrapProcessor(info);
		for each (var cp:ConfigurationProcessor in processors) {
			processor.addProcessor(cp);
		}
		return processor;
	}
	
	private function findParent () : void {
		var viewParent:Context;
		if (_viewRoot != null && findParentInView) {
			if (viewRoot.stage == null) {
				log.warn("Probably unable to look for parent Context in the view hierarchy " +
						" - specified view root has not been added to the stage yet");
			}
			var event:ContextConfigurationEvent = new ContextConfigurationEvent(this);
			viewRoot.dispatchEvent(event);
			viewParent = event.viewParent;
		}
		
		if (viewParent) {
			/* For internal services the parent found in the view serves as a first element to use for lookups.
			   For dependency lookups in the Context it will be the last, as user-specified parents should have precedence. */
			handleParentConfig(stateManager.contexts.getBootstrapConfig(viewParent));
		}
		if (_parents.length) {
			for each (var parent:Context in _parents) {
				handleParentConfig(stateManager.contexts.getBootstrapConfig(parent));
			}
		}
		else {
			handleParentConfig(BootstrapDefaults.config); // TODO - 2.4 - maybe set even when there are parents
		}
		
		if (viewParent) {
			_parents.push(viewParent);
		}
		
		if (!_domain && _viewRoot && domainProvider) {
			_domain = domainProvider.getDomainForView(viewRoot, stateManager.domains);
		}
		if (!_domain) {
			_domain = (viewParent) ? viewParent.domain : (_parents.length) ? _parents[0].domain : ClassInfo.currentDomain;
		}
	}
	
	private function handleParentConfig (parentConfig:BootstrapConfig) : void {
		_services.addParent(parentConfig.services);
		_viewSettings.addParent(parentConfig.viewSettings);
		_messageSettings.addParent(parentConfig.messageSettings);
		_properties.addParent(parentConfig.properties);
		_scopeExtensions.addParent(parentConfig.scopeExtensions);
		
		parentConfigs.push(parentConfig);
	}
	
	private function assembleNewScopes () : Array {
		var scopes:Array = newScopes.concat();
		scopes.push(createScopeDefinition(ScopeName.LOCAL, false, localScopeUuid));
		if (!parents.length) {
			scopes.push(createScopeDefinition(ScopeName.GLOBAL, true));
		}
		return scopes;
	}
	
	private function createScopeDefinition (name:String, inherited:Boolean, uuid:String = null) : ScopeDefinition {
		if (!uuid) {
			uuid = GlobalState.scopes.nextUuidForName(name);
		}
		return new ScopeDefinition(name, inherited, uuid);
		//var extensions:Dictionary = _scopeExtensions.getAll();
		//return new ScopeDefinition(name, inherited, uuid, services, extensions, stateManager.domains);
	}

	private function prepareBootstrapInfo () : BootstrapInfo {
		if (description == null) {
			description = processors.join(","); // TODO - ignores processors added later
		}
		var allParentScopes:Array = new Array();
		var parentScopes:Array;
		for each (var parent:Context in parents) {
			parentScopes = stateManager.contexts.getInheritedScopes(parent);
			if (parentScopes.length) {
				allParentScopes = allParentScopes.concat(parentScopes);
			}
		}
		var scopes:ScopeInfoRegistry = new DefaultScopeInfoRegistry(assembleNewScopes(), parentScopes);
		var info:BootstrapInfo = new DefaultBootstrapInfo(this, scopes, _scopeExtensions.getAll(), stateManager);
		var context:Context = info.context;
		if (log.isInfoEnabled()) {
			log.info("Creating Context " + context + 
					((_parents.length) ? " with parent(s) " + _parents.join(",") : " without parent"));
		}
		stateManager.contexts.addContext(context, this, scopes);
		if (_viewRoot != null) {
			viewRoot.dispatchEvent(new ContextCreationEvent(context));
		}
		return info;
	}
}
}

import org.spicefactory.parsley.core.context.LookupStatus;
import org.spicefactory.parsley.core.context.impl.DefaultLookupStatus;
import org.spicefactory.parsley.core.registry.ConfigurationProperties;

import flash.utils.Dictionary;

class DefaultProperties implements ConfigurationProperties {
	
	private var map:Dictionary = new Dictionary();
	
	private var parents:Array = new Array();

	public function addParent (parent:ConfigurationProperties) : void {
		parents.push(parent);
	}

	public function setValue (name:String, value:Object) : void {
		map[name] = value;
	}
	
	public function getValue (name:String, status:LookupStatus = null) : Object {
		if (map[name]) {
			return map[name];
		}
		var value:Object;
		for each (var parent:ConfigurationProperties in parents) {
			if (!status) {
				status = new DefaultLookupStatus(this);
			}
			if (status.addInstance(parent)) {
				value = parent.getValue(name, status);
				if (value) {
					return value;
				}
			}
		}
		return null;
	}
	
	public function removeValue (name:String) : void {
		delete map[name];
	}
	
}

