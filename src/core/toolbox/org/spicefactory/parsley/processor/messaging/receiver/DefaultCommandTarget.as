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
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.command.Command;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.processor.messaging.MessageReceiverFactory;
import org.spicefactory.parsley.processor.util.MessageReceiverFactories;

/**
 * Default implementation of the CommandTarget interface.
 * 
 * @author Jens Halm
 */
public class DefaultCommandTarget extends AbstractMessageHandler implements MessageTarget {
	
	
	private var _returnType:Class;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param provider the provider for the instance that contains the target method
	 * @param methodName the name of the target method that should be invoked
	 * @param selector an optional selector value to be used for selecting matching message targets
	 * @param messageType the type of the message or null if it should be autodetected by the parameter of the target method
	 * @param messageProperties the list of names of properties of the message that should be used as method parameters
	 * @param order the execution order for this receiver
	 */
	function DefaultCommandTarget (provider:ObjectProvider, methodName:String, selector:* = undefined, 
			messageType:ClassInfo = null, messageProperties:Array = null, order:int = int.MAX_VALUE) {
		super(provider, methodName, selector, messageType, messageProperties, order);
		setReturnType(provider.type, methodName);
	}
	
	private function setReturnType (type:ClassInfo, methodName:String) : void {
		var targetMethod:Method = type.getMethod(methodName);
		_returnType = targetMethod.returnType.getClass();
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function get returnType () : Class {
		return _returnType;
	}
	
	/**
	 * @inheritDoc
	 */
	public function handleMessage (processor:MessageProcessor) : void {
		var returnValue:* = invokeMethod(processor);
		var command:Command = processor.createCommand(returnValue);
		processor.senderContext.scopeManager.observeCommand(command);
	}
	
	
	
	
	/**
	 * Creates a new factory that creates DefaultCommandTarget instances. 
	 * Such a factory can be used for convenient registration of a <code>MessageReceiverProcessorFactory</code>
	 * with a target <code>ObjectDefinition</code>.
	 * 
	 * @param methodName the name of the target method that should be invoked
	 * @param selector an optional selector value to be used for selecting matching message targets
	 * @param messageType the type of the message or null if it should be autodetected by the parameter of the target method
	 * @param messageProperties the list of names of properties of the message that should be used as method parameters
	 * @param order the execution order for this receiver
	 * @return a new factory that creates DefaultCommandTarget instance
	 */
	public static function newFactory (methodName:String, selector:* = undefined, messageType:ClassInfo = null, 
			messageProperties:Array = null, order:int = int.MAX_VALUE) : MessageReceiverFactory {
				
		return MessageReceiverFactories.newFactory(DefaultCommandTarget, [methodName, selector, messageType, messageProperties, order]);
	}
	
	
}
}
