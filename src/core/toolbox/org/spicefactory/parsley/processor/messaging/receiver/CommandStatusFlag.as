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

package org.spicefactory.parsley.processor.messaging.receiver {

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.command.CommandManager;
import org.spicefactory.parsley.core.command.CommandObserverProcessor;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.impl.MessageReceiverKind;
import org.spicefactory.parsley.core.messaging.receiver.CommandObserver;
import org.spicefactory.parsley.processor.messaging.MessageReceiverFactory;
import org.spicefactory.parsley.processor.util.MessageReceiverFactories;

/**
 * A message target where a property value serves as a flag for indicating whether there is 
 * at least one active command matching the specified message type and selector. 
 *  
 * @author Jens Halm
 */
public class CommandStatusFlag extends AbstractObjectProviderReceiver implements CommandObserver {
	
	
	private var manager:CommandManager;
	
	private var _property:Property;
	
	private var _kind:MessageReceiverKind;
	
	
	/**
	 * Creates a new instance. 
	 * 
	 * @param provider the provider for the instance that contains the target property
	 * @param propertyName the name of the target property that should be bound
	 * @param manager the command manager to look up matching active commands
	 * @param status the command status this object is interested in
	 * @param messageType the type of the message
	 * @param selector an optional selector value to be used for selecting matching message targets
	 * @param order the execution order for this receiver
	 */
	function CommandStatusFlag (provider:ObjectProvider, propertyName:String, manager:CommandManager, 
			kind:MessageReceiverKind, messageType:ClassInfo, selector:* = undefined, order:int = int.MIN_VALUE) {
		super(provider, messageType.getClass(), selector, order);
		_property = provider.type.getProperty(propertyName);
		if (_property == null) {
			throw new ContextError("Target type " + provider.type.name 
					+ " does not contain a property with name " + _property);	
		}
		else if (!_property.writable) {
			throw new ContextError("Target " + _property + " is not writable");
		}
		else if (_property.type.getClass() != Boolean) {
			throw new ContextError("Target " + _property + " for CommandStatus must be of type Boolean");
		}
		_kind = kind;
		this.manager = manager;
	}
	
	/**
	 * The target property that should be bound.
	 */
	public function get property () : Property {
		return _property;
	}

	/**
	 * @inheritDoc
	 */
	public function observeCommand (processor:CommandObserverProcessor) : void {
		property.setValue(provider.instance, manager.hasActiveCommandsForTrigger(type, selector));
	}
	
	/**
	 * @inheritDoc
	 */
	public function get kind () : MessageReceiverKind {
		return _kind;
	}
	
	
	/**
	 * Creates a new factory that creates CommandStatusFlag instances. 
	 * Such a factory can be used for convenient registration of a <code>MessageReceiverProcessorFactory</code>
	 * with a target <code>ObjectDefinition</code>.
	 * 
	 * @param propertyName the name of the target property that should be bound
	 * @param manager the command manager to look up matching active commands
	 * @param status the command status this object is interested in
	 * @param messageType the type of the message
	 * @param selector an optional selector value to be used for selecting matching message targets
	 * @param order the execution order for this receiver
	 * @return a new factory that creates CommandStatusFlag instance
	 */
	public static function newFactory (propertyName:String, manager:CommandManager, kind:MessageReceiverKind, 
			messageType:ClassInfo, selector:* = undefined, order:int = int.MAX_VALUE) : MessageReceiverFactory {
				
		return MessageReceiverFactories.newFactory(CommandStatusFlag, [propertyName, manager, kind, messageType, selector, order]);
	}
	
	
}
}
