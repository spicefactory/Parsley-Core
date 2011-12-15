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

package org.spicefactory.parsley.processor.messaging.receiver {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.processor.messaging.MessageReceiverFactory;
import org.spicefactory.parsley.processor.util.MessageReceiverFactories;

/**
 * A regular message handler where the message is simply passed to a method on the target instance.
 * 
 * @author Jens Halm
 */
public class MessageHandler extends AbstractMessageHandler implements MessageTarget {
	
	
	private var usesMessageProperties:Boolean;
	private var isInterceptor:Boolean;
	
	
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
	function MessageHandler (provider:ObjectProvider, methodName:String, selector:* = undefined, 
			messageType:ClassInfo = null, messageProperties:Array = null, order:int = int.MAX_VALUE) {
		super(provider, methodName, selector, messageType, messageProperties, order, true);
		usesMessageProperties = (messageProperties != null);
		isInterceptor = (targetMethod.parameters.length > 0) 
				? Parameter(targetMethod.parameters[targetMethod.parameters.length - 1])
						.type.isType(MessageProcessor)
				: false;
	}

	
	/**
	 * @private
	 */
	public override function get order () : int {
		if (super.order != int.MAX_VALUE) {
			return super.order;
		}
		return (isInterceptor) ? int.MIN_VALUE : int.MAX_VALUE;
	}

	/**
	 * @inheritDoc
	 */
	public function handleMessage (processor:MessageProcessor) : void {
		invokeMethod(processor);
	}
	
	
	/**
	 * Creates a new factory that creates MessageHandler instances. 
	 * Such a factory can be used for convenient registration of a <code>MessageReceiverProcessorFactory</code>
	 * with a target <code>ObjectDefinition</code>.
	 * 
	 * @param methodName the name of the target method that should be invoked
	 * @param selector an optional selector value to be used for selecting matching message targets
	 * @param messageType the type of the message or null if it should be autodetected by the parameter of the target method
	 * @param messageProperties the list of names of properties of the message that should be used as method parameters
	 * @param order the execution order for this receiver
	 * @return a new factory that creates MessageHandler instance
	 */
	public static function newFactory (methodName:String, selector:* = undefined, messageType:ClassInfo = null, 
			messageProperties:Array = null, order:int = int.MAX_VALUE) : MessageReceiverFactory {
				
		return MessageReceiverFactories.newFactory(MessageHandler, [methodName, selector, messageType, messageProperties, order]);
	}
	
	
}
}
