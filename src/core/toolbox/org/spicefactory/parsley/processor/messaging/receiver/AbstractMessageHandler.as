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
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;

/**
 * Abstract base class for regular message handlers where the message is simply passed to a method on the target instance.
 * 
 * @author Jens Halm
 */
public class AbstractMessageHandler extends AbstractMethodReceiver {
	
	
	private var messageProperties:Array;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param provider the provider for the instance that contains the target method
	 * @param methodName the name of the target method that should be invoked
	 * @param selector an optional selector value to be used for selecting matching message targets
	 * @param messageType the type of the message or null if it should be autodetected by the parameter of the target method
	 * @param messageProperties the list of names of properties of the message that should be used as method parameters
	 * @param order the execution order for this receiver
	 * @param supportsProcessorParam whether this handler type supports an additional parameter of type MessageProcessor
	 */
	function AbstractMessageHandler (provider:ObjectProvider, methodName:String, selector:* = undefined, 
			messageType:ClassInfo = null, messageProperties:Array = null, 
			order:int = int.MAX_VALUE, supportsProcessorParam:Boolean = false) {
		super(provider, methodName, 
				getMessageType(provider, methodName, messageType, messageProperties, supportsProcessorParam), 
				getSelector(provider, methodName, selector, messageProperties, supportsProcessorParam),
				order);
		if (messageProperties != null) {
			setMessageProperties(messageProperties, messageType, supportsProcessorParam);
		}
	}

	
	private function getMessageType (provider:ObjectProvider, methodName:String, 
			explicitType:ClassInfo, messageProperties:Array, supportsProcessorParam:Boolean) : Class {
		if (messageProperties != null) {
			return (explicitType != null) ? explicitType.getClass() : Object;
		}
		var targetMethod:Method = provider.type.getMethod(methodName);
		if (targetMethod == null) {
			throw new ContextError("Target instance of type " + provider.type.name 
					+ " does not contain a method with name " + methodName);
		}
		var params:int = targetMethod.parameters.length;
		var maxParams:int = (supportsProcessorParam) ? 3 : 2;
		if (params > maxParams) {
			throw new ContextError("Target " + targetMethod  
				+ ": At most " + maxParams + " parameter(s) allowed for this type of message handler.");
		}
		if (params >= 1) {
			return getMessageTypeFromParameter(targetMethod, 0, explicitType);
		}
		else if (explicitType != null) {
			return explicitType.getClass();
		}		
		return Object;
	}
	
	private function getSelector (provider:ObjectProvider, methodName:String, 
			explicitSelector:*, messageProperties:Array, supportsProcessorParam:Boolean) : * {
		if (messageProperties != null) {
			return explicitSelector;
		}
		var params:Array = provider.type.getMethod(methodName).parameters;
		if (params.length >= 2) {
			var param:Parameter = params[1];
			if (!supportsProcessorParam || !param.type.isType(MessageProcessor)) {
				return param.type.getClass();
			}
		}
		return explicitSelector;
	}
	
	
	private function setMessageProperties (messageProperties:Array, messageType:ClassInfo,
			supportsProcessorParam:Boolean) : void {
		var requiredParams:uint = 0;
		var params:Array = targetMethod.parameters;
		for each (var param:Parameter in params) {
			if (param.required) requiredParams++;
		}
		if (supportsProcessorParam && requiredParams > 0) {
			var last:Parameter = params[params.length - 1] as Parameter;
			if (last.type.isType(MessageProcessor) && last.required) {
				requiredParams--;
			}
		}
		if (requiredParams > messageProperties.length) {
			throw new ContextError("Number of specified parameter names does not match the number of required parameters of " 
				+ targetMethod + ". Required: " + requiredParams + " - actual: " + messageProperties.length);
			// We'll ignore if the the number of required params is less than needed, 
			// since we can't reflect on varargs in AS3.
		}
		this.messageProperties = new Array();
		for each (var propertyName:String in messageProperties) {
			var messageProperty:Property = messageType.getProperty(propertyName);
			if (messageProperty == null) {
				throw new ContextError("Message type " + messageType.name 
						+ " does not contain a property with name " + propertyName);	
			}
			else if (!messageProperty.readable) {
				throw new ContextError(messageProperty.toString() + " is not readable");
			}
			this.messageProperties.push(messageProperty);
		}
	}
	
	
	/**
	 * @inheritDoc
	 */
	protected function invokeMethod (processor:MessageProcessor) : * {
		var params:Array = new Array();
		if (messageProperties == null) {
			var cnt:int = targetMethod.parameters.length;
			if (cnt >= 1) {
				params.push(processor.message);
			}
			if (cnt >= 2) {
				var param:Parameter = targetMethod.parameters[1];
				if (param.type.isType(MessageProcessor)) {
					params.push(processor);
				}
				else {
					if (processor.message.selector is Class) {
						params.push(null);
					}
					else {
						params.push(processor.message.selector);
					}
					if (cnt == 3) {
						params.push(processor);
					}
				}
			}
		}
		else {
			for each (var messageProperty:Property in messageProperties) {
				var value:* = messageProperty.getValue(processor.message.instance);
				params.push(value);
			}
			if (targetMethod.parameters.length > params.length) {
				params.push(processor);
			}
		}
		return targetMethod.invoke(provider.instance, params);
	}
	
	
}
}
