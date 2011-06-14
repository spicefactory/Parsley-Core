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
import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
	
/**
 * @author Jens Halm
 */
public class MappedCommandBuilder {
	
	
	private var target:MessageTarget;

	private var factory:ManagedCommandFactory;
	private var config:Configuration;
	
	private var messageType:Class;
	private var selector:*;
	
	private var scope:String;
	private var order:int;
	
	
	function MappedCommandBuilder (factory:ManagedCommandFactory, config:Configuration,
			messageType:Class, selector:*, scope:String, order:int) {
		this.factory = factory;
		this.config = config;
		this.messageType = messageType;
		this.selector = selector;
		this.scope = scope;
		this.order = order;
	}
	
	
	/**
	 * Builds and registers the dynamic command.
	 */
	public function build () : void {
		
		var messageInfo:ClassInfo = (messageType) 
			? ClassInfo.forClass(messageType, config.domain)
			: deduceMessageType();
		
		target = new MappedCommandProxy(factory, messageInfo.getClass(), selector, order);
				
		config.context.scopeManager.getScope(scope).messageReceivers.addTarget(target);
		
		config.context.addEventListener(ContextEvent.DESTROYED, contextDestroyed);
	}
	
	private function deduceMessageType () : ClassInfo {
		// TODO - implement - concrete logic is different for most command adapter types
		return null;
	}
	
	private function contextDestroyed (event:ContextEvent) : void {
		Context(event.target).scopeManager.getScope(scope).messageReceivers.removeTarget(target);
	}
	
	
}
}
