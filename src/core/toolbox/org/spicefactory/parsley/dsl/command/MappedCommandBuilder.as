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

package org.spicefactory.parsley.dsl.command {

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
	
/**
 * A builder DSL for mapping commands to messages.
 * This API adds on top of the standalone Spicelib Commands builder APIs the ability
 * to let commands get managed by a Parsley Context during execution and to trigger execution
 * based on a message.
 * 
 * @author Jens Halm
 */
public class MappedCommandBuilder {
	
	
	private var factory:ManagedCommandFactory;
	
	// TODO - 3.0.M1 - check where to set the defaults
	private var _messageType:Class;
	private var _selector:*;
	private var _scope:String;
	private var _order:int;
	
	private var target:MessageTarget;

	
	/**
	 * @private
	 */
	public static function forFactory (factory:ManagedCommandFactory) : MappedCommandBuilder {
		return new MappedCommandBuilder(factory);
	}
	
	/**
	 * @private
	 */
	public static function forType (type:Class) : MappedCommandBuilder {
		return new MappedCommandBuilder(new Factory(type));
	}
	
	/**
	 * @private
	 */
	public static function forFactoryFunction (f:Function, type:Class) : MappedCommandBuilder {
		return new MappedCommandBuilder(new Factory(type, f));
	}
	
	
	/**
	 * @private
	 */
	function MappedCommandBuilder (factory:ManagedCommandFactory) {
		this.factory = factory;
	}
	
	
	/**
	 * The type of message (including subtypes) that should trigger
	 * command execution.
	 * 
	 * @param type the type of message that should trigger command execution
	 * @return this builder instance for method chaining
	 */
	public function messageType (type:Class) : MappedCommandBuilder {
		_messageType = type;
		return this;
	}
	
	/**
	 * The optional selector for mapping matching messages.
	 * 
	 * @param selector the selector to use for matching messages
	 * @return this builder instance for method chaining
	 */
	public function selector (selector:*) : MappedCommandBuilder {
		_selector = selector;
		return this;
	}
	
	/**
	 * The execution order in relation to other message receivers.
	 * This order attribute affects all types of message receivers,
	 * not only those that execute commands.
	 * 
	 * @param order the execution order in relation to other message receivers
	 * @return this builder instance for method chaining
	 */
	public function order (order:int) : MappedCommandBuilder {
		_order = order;
		return this;
	}
	
	/**
	 * The name of the scope in which to listen for messages.
	 * 
	 * @param scope the name of the scope in which to listen for messages
	 * @return this builder instance for method chaining
	 */
	public function scope (scope:String) : MappedCommandBuilder {
		_scope = scope;
		return this;
	}
	
	
	/**
	 * Registers this mapping with the specified Context.
	 * 
	 * @param context the Context this mapping is applied to
	 */
	public function register (context:Context) : void {
		
		if (factory is Factory) 
			Factory(factory).init(context);
		
		var messageInfo:ClassInfo = (_messageType) 
			? ClassInfo.forClass(_messageType, context.domain)
			: deduceMessageType();
			
		var message:Class = (messageInfo) ? messageInfo.getClass() : Object;
		
		target = new MappedCommandProxy(factory, context, message, _selector, _order);
				
		context.scopeManager.getScope(_scope).messageReceivers.addTarget(target);
		
		context.addEventListener(ContextEvent.DESTROYED, contextDestroyed);
	}
	
	private function deduceMessageType () : ClassInfo {
		return CommandTriggerProviders.defaultProvider.getTriggerType(factory.type);
	}
	
	private function contextDestroyed (event:ContextEvent) : void {
		Context(event.target).scopeManager.getScope(_scope).messageReceivers.removeTarget(target);
	}
	
	
}
}


import org.spicefactory.lib.command.builder.CommandProxyBuilder;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.core.command.ManagedCommandProxy;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.dsl.command.DefaultManagedCommandProxy;

class Factory implements ManagedCommandFactory {

	private var factory:Function;
	private var _type:Class;
	private var typeInfo:ClassInfo;
	private var context:Context;

	function Factory (type:Class, factory:Function = null) {
		_type = type;		
		this.factory = factory;
	}
	
	public function init (context:Context) : void {
		this.context = context;
		typeInfo = ClassInfo.forClass(_type, context.domain);
	}

	public function get type () : ClassInfo {
		return typeInfo;
	}

	public function newInstance () : ManagedCommandProxy {
		var target:Object = (factory != null) ? factory() : type.getClass();
		var proxy:DefaultManagedCommandProxy = new DefaultManagedCommandProxy(context);
		var builder:CommandProxyBuilder = new CommandProxyBuilder(target, proxy);
		builder.build();
		return proxy;
	}
	
}

