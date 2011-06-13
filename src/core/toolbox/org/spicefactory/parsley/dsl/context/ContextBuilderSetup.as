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

package org.spicefactory.parsley.dsl.context {
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.core.bootstrap.BootstrapDefaults;
import org.spicefactory.parsley.core.bootstrap.BootstrapManager;
import org.spicefactory.parsley.core.context.Context;

import flash.display.DisplayObject;
import flash.system.ApplicationDomain;

/**
 * Allows to specify the options for a ContextBuilder before creating it.
 * 
 * @author Jens Halm
 */
public class ContextBuilderSetup {
	
	
	private var _viewRoot:DisplayObject;
	private var _domain:ApplicationDomain;
	private var _parents:Array = new Array();
	private var _findParentInView:Boolean = true;
	private var _description:String;
	private var _localScopeUuid:String;
	private var scopes:Array = new Array();
	
	private var parts:Array = new Array();
	
	
	/**
	 * Sets the view root the target Context should use to listen for bubbling
	 * events from components below that wish to get wired to the Context.
	 * 
	 * @param viewRoot the view root for the target Context
	 * @return this builder instance for method chaining 
	 */
	public function viewRoot (viewRoot:DisplayObject) : ContextBuilderSetup {
		_viewRoot = viewRoot;
		return this;
	}
	
	/**
	 * Sets the ApplicationDomain to use for reflection.
	 * 
	 * @param domain the ApplicationDomain to use for reflection
	 * @return this builder instance for method chaining 
	 */
	public function domain (domain:ApplicationDomain) : ContextBuilderSetup {
		_domain = domain;
		return this;
	}
	
	/**
	 * Sets the parent to use for the target Context to look up shared dependencies.
	 * Will usually automatically detected in the view hierarchy and only has to be specified
	 * if this is not possible, for example when the parent Context is not associated with
	 * a view root DisplayObject.
	 * 
	 * @param parent the parent to use for the target Context to look up shared dependencies
	 * @return this builder instance for method chaining 
	 */
	public function parent (parent:Context) : ContextBuilderSetup {
		_parents.push(parent);
		return this;
	}
	
	/**
	 * Specifies whether the new Context should automatically find a parent Context
	 * in the view hierarchy above the view root. The default is true. When a parent
	 * is found in the view hierarchy it will get added to the list of Contexts specified
	 * explicitly on this instance.
	 * 
	 * @param findParent whether the new Context should automatically find a parent Context
	 * in the view hierarchy above the view root
	 * @return this builder instance for method chaining 
	 */
	public function findParentInView (findParent:Boolean) : ContextBuilderSetup {
		_findParentInView = findParent;
		return this;
	}
	
	/**
	 * Sets a description to be passed to the Context for logging or monitoring purposes.
	 * 
	 * @param description a description to be passed to the Context for logging or monitoring purposes
	 * @return this builder instance for method chaining 
	 */
	public function description (description:String) : ContextBuilderSetup {
		_description = description;
		return this;
	}
	
	/**
	 * Allows to specify messaging settings.
	 * 
	 * @return a builder that allows to specify messaging settings 
	 */
	public function messageSettings () : MessageSettingsBuilder {
		var part:MessageSettingsBuilder = new MessageSettingsBuilder(this);
		addPart(part);
		return part;
	}
	
	/**
	 * Allows to specify settings for view wiring.
	 * 
	 * @return a builder that allows to specify settings for view wiring 
	 */
	public function viewSettings () : ViewSettingsBuilder {
		var part:ViewSettingsBuilder = new ViewSettingsBuilder(this);
		addPart(part);
		return part;
	}
	
	/**
	 * Allows to register scope extensions.
	 * 
	 * @return a builder that allows to register scope extensions
	 */
	public function scopeExtensions () : ScopeExtensionsBuilder {
		var part:ScopeExtensionsBuilder = new ScopeExtensionsBuilder(this);
		addPart(part);
		return part;
	}
	
	/**
	 * Allows to specify implementations or decorators for the IOC kernel services.
	 * 
	 * @return a builder that allows to specify factories for the IOC kernel services 
	 */
	public function services () : ServiceRegistryBuilder {
		var part:ServiceRegistryBuilder = new ServiceRegistryBuilder(this);
		addPart(part);
		return part;
	}
	
	/**
	 * Sets the ApplicationDomain to use for reflection.
	 * 
	 * @param domain the ApplicationDomain to use for reflection
	 * @return this builder instance for method chaining 
	 */
	public function scope (scope:String, inherited:Boolean = true, uuid:String = null) : ContextBuilderSetup {
		scopes.push(new Scope(scope, inherited, uuid));
		return this;
	}
	
	/**
	 * Sets the uuid for the local scope of the new Context.
	 * 
	 * @param uuid the uuid for the local scope of the new Context
	 * @return this builder instance for method chaining 
	 */
	public function localScopeUuid (uuid:String) : ContextBuilderSetup {
		_localScopeUuid = uuid;
		return this;
	}
	
	/**
	 * Creates a new ContextBuilder based on the settings of this setup instance.
	 * 
	 * @return a new ContextBuilder based on the settings of this setup instance
	 */
	public function newBuilder () : ContextBuilder {
		
		var manager:BootstrapManager = BootstrapDefaults.config.services.bootstrapManager.newInstance() as BootstrapManager;
		var config:BootstrapConfig = manager.config;
		config.viewRoot = _viewRoot;
		for each (var parent:Context in _parents) {
			config.addParent(parent);
		}
		config.findParentInView = _findParentInView;
		config.domain = _domain;
		config.description = _description;
		if (_localScopeUuid) config.localScopeUuid = _localScopeUuid;
		for each (var scope:Scope in scopes) {
			config.addScope(scope.name, scope.inherited, scope.uuid);
		}
		for each (var part:SetupPart in parts) {
			part.apply(config);
		}
		return new ContextBuilder(manager.createProcessor());
	}
	
	private function addPart (part:SetupPart) : void {
		parts.push(part);
	}
	
	
}
}

class Scope {

	public var name:String;
	public var inherited:Boolean;
	public var uuid:String;
	
	function Scope (name:String, inherited:Boolean, uuid:String) {
		this.name = name;
		this.inherited = inherited;
		this.uuid = uuid;
	}
	
}
