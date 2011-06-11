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

package org.spicefactory.parsley.core.context {
import flash.system.ApplicationDomain;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.scope.ScopeManager;
import org.spicefactory.parsley.core.view.ViewManager;

import flash.events.IEventDispatcher;

/**
 * Dispatched when configuration for this Context has been fully processed.
 * This includes loading configuration files, reflecting on classes, processing metadata tags
 * or validating the configuration. After this property is set the configuration of the Context
 * is sealed an can no longer be modified.
 * 
 * <p>Some ContextBuilder implementations excute synchronously. In this case this
 * event will never fire. Thus before registering for this event you should check the
 * <code>configured</code> property on the Context.</p>
 * 
 * @eventType org.spicefactory.parsley.core.events.ContextEvent.CONFIGURED
 */
[Event(name="configured", type="org.spicefactory.parsley.core.events.ContextEvent")]

/**
 * Dispatched when the Context was fully initialized.
 * At this point all configuration was processed and all non-lazy singleton objects
 * in this Context have been instantiated and configured and their asynchronous
 * initializers (if any) have successfully completed.
 * 
 * <p>Some ContextBuilder implementations execute synchronously. In this case this
 * event will never fire. Thus before registering for this event you should check the
 * <code>initialized</code> property on the Context.</p>
 * 
 * @eventType org.spicefactory.parsley.core.events.ContextEvent.INITIALIZED
 */
[Event(name="initialized", type="org.spicefactory.parsley.core.events.ContextEvent")]

/**
 * Dispatched when Context initialization failed.
 * This may happen due to errors in processing the configuration or because some asynchronous
 * initializer on a non-lazy singleton failed. All objects that have already been created at
 * this point (partly or fully) will get their PreDestroy methods invoked.
 * 
 * <p>After the <code>INITIALIZED</code> event of this Context has fired and the
 * <code>initialized</code> property was set to true, this event can never fire.
 * In particular it does not fire if retrieving a lazy initializing object fails
 * after Context initialization.</p>
 * 
 * @eventType flash.events.ErrorEvent.ERROR
 */
[Event(name="error", type="flash.events.ErrorEvent")]

/**
 * Dispatched when the Context was destroyed.
 * At this point all methods marked with [Destroy] on objects managed by this context 
 * have been invoked and any child Context instances were destroyed, too.
 * 
 * @eventType org.spicefactory.parsley.core.events.ContextEvent.DESTROYED
 */
[Event(name="destroyed", type="org.spicefactory.parsley.core.events.ContextEvent")]

/**
 * The main interface of the IOC Container providing access to all configured objects.
 * 
 * <p>It is recommended that you avoid to work with the Context API directly in regular application development.
 * Parsley is designed in a way that helps you keep your objects decoupled from the framework (and decoupled from
 * each other). Thus you should probably prefer working with the Parsley Manual over using these Framework API Docs.</p>
 * 
 * <p>But if you are extending or modifying the framework, building your own framework on top of Parsley or just
 * creating a bunch of custom configuration tags, it is likely that you need access to the Context.</p>
 * 
 * <p>There are two ways to get access to a Context:</p>
 * 
 * <ul>
 * <li>Through all the various ContextBuilder entry points. Calling <code>FlexContextBuilder.build()</code> or
 * <code>XmlContextBuilder.build()</code> always returns a Context instance, although in most cases you'll simply
 * ignore the returned instance.</li>
 * <li>Through dependency injection. All objects added to a Context can have properties or constructor and method
 * parameters of type Context annotated with the <code>[Inject]</code> metadata tag and will get the Context they
 * belong to injected upon object creation.</li>
 * </ul>
 * 
 * <p>All builtin Context implementations like <code>DefaultContext</code>, <code>ChildContext</code> or
 * <code>DefaultDynamicContext</code> use an <code>ObjectDefinitionRegistry</code> internally. Thus with all
 * builtin Context implementations you'll be able to work with all MXML, XML or Metadata tags that map
 * to classes implementing <code>ObjectDefinitionDecorator</code>.</p>
 * 
 * <p>But implementations of this interface are not required to work with <code>ObjectDefinitions</code>,
 * for special requirements you can create custom implementations from scratch.</p>
 * 
 * <p>Context instances returned by the various ContextBuilder entry points may not be fully initialized yet, 
 * depending on whether the configuration mechanism used operates synchronously or asynchronously, and whether
 * the Context contains object which are defined to be asynchronously initializing (e.g. through the <code>[AsyncInit]</code>
 * metadata tag.</p>
 * 
 * <p>You can check the state of a Context instance through its <code>configured</code> and <code>initialized</code> properties.
 * The former is set to true as soon as all configuration artifacts have been processed (e.g. loading XML files, reflecting
 * on MXML configuration classes and so on). The latter will be set to true after all objects configured to be non-lazy
 * singletons have been instantiated and fully configured, including objects configured for asynchronous initialization.</p>
 * 
 * 
 * @author Jens Halm
 */
public interface Context extends IEventDispatcher {
	
	/**
	 * Returns the definition for the object with the specified id or null if no such object exists.
	 * 
	 * @param id the id of the object
	 * @param status internal status to avoid duplicate lookups, not used in normal application code
	 * @return the definition for the object with the specified id or null
	 */
	function findDefinition (id:String, status:LookupStatus = null) : ObjectDefinition;
	
	/**
	 * Returns one definition for the specified type. Throws an Error if there is more
	 * than one definition for the specified type. If this Context has parents, it should
	 * only look into parent Contexts if the definition cannot be found in the local Context.
	 * 
	 * @param type the type of the object to return
	 * @param status internal status to avoid duplicate lookups, not used in normal application code
	 * @return one definition for the specified type
	 */
	function findDefinitionByType (type:Class, status:LookupStatus = null) : ObjectDefinition;
	
	/**
	 * Returns all definitions for the specified type. 
	 * 
	 * @param type the type of the objects to return
	 * @param status internal status to avoid duplicate lookups, not used in normal application code
	 * @return all definitions for the specified type
	 */
	function findAllDefinitionsByType (type:Class, status:LookupStatus = null) : Array;
	
	/**
	 * Returns the number of objects in this Context that match the specified type.
	 * If the type parameter is omitted the number of all objects in this Context will be returned.
	 * 
	 * @param type the type to check for matches
	 * @return the number of objects in this Context that match the specified type
	 */
	function getObjectCount (type:Class = null) : uint;
	
	/**
	 * Checks whether this Contex contains an object with the specified id.
	 * 
	 * @param id the id to check
	 * @return true if this Context contains an object with the specified id  
	 */
	function containsObject (id:String) : Boolean;
	
	/**
	 * Returns the singleton object with the specified id. Throws an Error if no such object exists.
	 * 
	 * @param id the id of the object
	 * @return the object with the specified id
	 */
	function getObject (id:String) : Object;
	
	/**
	 * Returns a singleton object of the specified type. 
	 * This method will throw an Error if no object with a matching type exists in this Context
	 * or if it finds more than one match.
	 * 
	 * @param type the type of the object to return
	 * @return an object of the specified type
	 */
	function getObjectByType (type:Class) : Object;

	/**
	 * Returns all objects that match the specified type. This includes subclasses or objects implementing
	 * the interface in case the type parmeter is an interface. When no match is found an empty Array will be returned.
	 * 
	 * @param type the type of the objects to return
	 * @return all objects that match the specified type
	 */
	function getAllObjectsByType (type:Class) : Array;
	
	/**
	 * Returns a new dynamic object for the specified id. Throws an Error if no such object exists.
	 * Dynamic objects can only be created from DynamicObjectDefinitions, such as those created
	 * by the <code>&lt;DynamicObject&gt;</code> MXML tag or the <code>&lt;dynamic-object&gt;</code>
	 * XML tag.
	 * 
	 * @param id the id of the object
	 * @return a new dynamic object for the specified id
	 */
	function createDynamicObject (id:String) : DynamicObject;
	
	/**
	 * Returns a new dynamic object for the specified type. 
	 * This method will throw an Error if no object with a matching type exists in this Context
	 * or if it finds more than one match.
	 * Dynamic objects can only be created from DynamicObjectDefinitions, such as those created
	 * by the <code>&lt;DynamicObject&gt;</code> MXML tag or the <code>&lt;dynamic-object&gt;</code>
	 * XML tag.
	 * 
	 * @param type the type of the object to return
	 * @return a new dynamic object for the specified type
	 */
	function createDynamicObjectByType (type:Class) : DynamicObject;
	
	/**
	 * Dynamically adds the specified instance to the Context.
	 * 
	 * @param instance the object to add to the Context
	 * @param definition optional definition to apply to the existing instance
	 * @return an instance representing the dynamically created object and its definition
	 */
	function addDynamicObject (instance:Object, definition:DynamicObjectDefinition = null) : DynamicObject;
	
	/**
	 * Creates an object from the specified definition and dynamically adds it to the Context.
	 * 
	 * @param definition the definition to create an object from
	 * @return an instance representing the dynamically created object and its definition
	 */
	function addDynamicDefinition (definition:DynamicObjectDefinition) : DynamicObject;
	
	/**
	 * Indicates whether configuration for this Context has been fully processed.
	 * This includes loading configuration files, reflecting on classes, processing metadata tags
	 * or validating the configuration. After this property is set the configuration of the Context
	 * is sealed an can no longer be modified. If you try to access the content of this Context
	 * with methods like <code>getObject</code> before this property has been set to true, an Error
	 * will be thrown. In case this property is set to false after Context creation you can listen
	 * to the <code>ContextEvent.CONFIGURED</code> event.
	 */
	function get configured () : Boolean;
	
	/**
	 * Indicates whether this Context has been fully initialized. This includes processing the configuration
	 * (thus <code>configured</code> is always true if this property is true) and instantiating all objects
	 * that were configured as non-lazy singleton (the default). This includes processing all objects which
	 * were configured to be asynchronously initializing, waiting until all these objects have been fully
	 * initialized. In case this property is set to false after Context creation you can listen
	 * to the <code>ContextEvent.INITIALIZED</code> event.
	 * 
	 * <p>The objects contained in this Context can already be accessed before this property is set to true (as long
	 * as the <code>configured</code> property is set to true). This is necessary since objects that are instantiated and
	 * configured during the initialization process of the Context may need access to their dependencies.
	 * But you should be aware that you might mix up the initialization order so you should use the Context with
	 * caution before this property is set to true.</p>
	 */
	function get initialized () : Boolean;
	
	/**
	 * Indicates whether this Context has been destroyed.
	 * When this property is set to true, the Context can no longer be used and most of its methods will
	 * throw an Error.
	 */
	function get destroyed () : Boolean;
	
	/**
	 * Destroys this Context. This includes processing all lifecycle listeners for all objects that this
	 * Context has instantiated and calling their methods marked with <code>[Destroy]</code>.
	 * The Context may no longer be used after calling this method.
	 */
	function destroy () : void;
	
	/**
	 * All parent Contexts that this Context inherits from.
	 */
	function get parents () : Array;
	
	/**
	 * The scope manager that handles all scopes that this Context belongs to.
	 * This includes scopes inherited from parent Contexts as well as scopes
	 * created for this Context.
	 */
	function get scopeManager () : ScopeManager;
	
	/**
	 * The view manager used to dynamically wire view instances to this Context.
	 */
	function get viewManager () : ViewManager;
	
	/**
	 * The ApplicationDomain used to reflect on instance of this Context.
	 */
	function get domain () : ApplicationDomain;
	
	
	[Deprecated(replacement="findDefinition")]
	function getType (id:String) : Class;
	
	[Deprecated(replacement="findDefinition")]
	function isDynamic (id:String) : Boolean;
	
	[Deprecated(replacement="findAllDefinitions")]
	function getObjectIds (type:Class = null) : Array;
		 
	[Deprecated(replacement="findDefinition")]
	function getDefinition (id:String) : ObjectDefinition;		 
	
	[Deprecated(replacement="findDefinitionByType")]
	function getDefinitionByType (type:Class) : ObjectDefinition;
	
	[Deprecated(replacement="new methods for dynamic objects on the core Context interface")]
	function createDynamicContext () : DynamicContext;
	
}

}
