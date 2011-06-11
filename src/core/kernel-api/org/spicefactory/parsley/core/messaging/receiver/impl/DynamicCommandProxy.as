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

package org.spicefactory.parsley.core.messaging.receiver.impl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.context.provider.Provider;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.command.Command;
import org.spicefactory.parsley.core.messaging.command.CommandStatus;
import org.spicefactory.parsley.core.messaging.receiver.CommandObserver;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;

import flash.system.ApplicationDomain;

[Deprecated(replacement="same class in new parsley.processor.messaging.receiver package")]
/**
 * @author Jens Halm
 */
public class DynamicCommandProxy extends AbstractMessageReceiver implements MessageTarget {
	
	private var context:Context;
	private var definition:DynamicObjectDefinition;
	private var stateful:Boolean;
	
	private var execute:String;
	private var result:String;
	private var error:String;
	
	private var messageInfo:ClassInfo;
	private var messageProperties:Array;
	private var _returnType:Class;
	
	private var statefulTarget:DynamicObject;
	
	function DynamicCommandProxy (
			messageInfo:ClassInfo, 
			selector:*, 
			order:int, 
			context:Context,
			definition:DynamicObjectDefinition,
			stateful:Boolean,
			returnType:Class,
			execute:String,
			result:String = null,
			error:String = null,
			messageProperties:Array = null
			) {
				
		super(messageInfo.getClass(), selector, order);
		
		this.definition = definition;
		this.context = context;
		this.stateful = stateful;
		this.execute = execute;
		this.result = result;
		this.error = error;
		
		this.messageInfo = messageInfo;
		this.messageProperties = messageProperties;
		_returnType = returnType;
	}

	public function get returnType () : Class {
		return _returnType;
	}
	
	public function handleMessage (processor:MessageProcessor) : void {
		
		var object:DynamicObject = createObject();
		
		var command:Command;
		var domain:ApplicationDomain = definition.type.applicationDomain;
		try {
			var invoker:DynamicCommandTarget
					= new DynamicCommandTarget(Provider.forInstance(object.instance, domain), execute, 
					selector, messageInfo, messageProperties, order);
					
			var returnValue:* = invoker.invoke(processor.message);
			command = processor.createCommand(returnValue);
		}
		catch (e:Error) {
			object.remove();
			throw e;
		}
		if (result != null) {
			var resultHandler:CommandObserver
					= new DynamicCommandObserver(object, stateful, result, CommandStatus.COMPLETE, 
					selector, messageInfo, int.MIN_VALUE, domain);
			command.addObserver(resultHandler);
		}
		if (error != null) {
			var errorHandler:CommandObserver
					= new DynamicCommandObserver(object, stateful, error, CommandStatus.ERROR, 
					selector, messageInfo, int.MIN_VALUE, domain);
			command.addObserver(errorHandler);
		}
		if (!stateful) {
			command.addStatusHandler(checkCommandStatus, object, (result != null), (error != null));
		}
	}
	
	private function createObject () : DynamicObject {
		if (!stateful) {
			return context.addDynamicDefinition(definition);
		}
		else {
			if (statefulTarget == null) {
				statefulTarget = context.addDynamicDefinition(definition);			
			}
			return statefulTarget;
		}
	}
	
	private function checkCommandStatus (command:Command, object:DynamicObject,
			ignoreComplete:Boolean, ignoreError:Boolean) : void {
				
		var status:CommandStatus = command.status;
		if (status == CommandStatus.CANCEL 
				|| (status == CommandStatus.COMPLETE && !ignoreComplete)
				|| (status == CommandStatus.ERROR && !ignoreError)
				) {
			object.remove();		
		}
	}
}
}

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.context.provider.Provider;
import org.spicefactory.parsley.core.messaging.command.CommandObserverProcessor;
import org.spicefactory.parsley.core.messaging.command.CommandStatus;
import org.spicefactory.parsley.core.messaging.receiver.impl.DefaultCommandObserver;
import org.spicefactory.parsley.core.messaging.receiver.impl.DefaultCommandTarget;

import flash.system.ApplicationDomain;

class DynamicCommandTarget extends DefaultCommandTarget {
	
	function DynamicCommandTarget (
			provider:ObjectProvider, 
			methodName:String, 
			selector:*, 
			messageType:ClassInfo, 
			messageProperties:Array, 
			order:int
			) {
		super(provider, methodName, selector, messageType, messageProperties, order);
	}
	
	public function invoke (message:Object) : * {
		return invokeMethod(message);
	}
	
}

class DynamicCommandObserver extends DefaultCommandObserver {
	
	private var object:DynamicObject;
	private var stateful:Boolean;
	
	function DynamicCommandObserver (
			object:DynamicObject, 
			stateful:Boolean, 
			methodName:String, 
			status:CommandStatus, 
			selector:* = undefined, 
			messageType:ClassInfo = null, 
			order:int = int.MAX_VALUE,
			domain:ApplicationDomain = null
			) {
		super(Provider.forInstance(object.instance, domain), methodName, status, selector, messageType, order);
		this.object = object;
		this.stateful = stateful;
	}

	public override function observeCommand (processor:CommandObserverProcessor) : void {
		try {
			super.observeCommand(processor);
		}
		finally {
			if (!stateful) {
				object.remove();
			}
		}
	}
	
}
