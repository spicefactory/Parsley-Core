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

package org.spicefactory.parsley.core.messaging.receiver.impl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;

[Deprecated(replacement="same class in new parsley.processor.messaging.receiver package")]
/**
 * @author Jens Halm
 */
public class AbstractMessageHandler extends AbstractMethodReceiver {
	
	private var messageProperties:Array;
	
	function AbstractMessageHandler (provider:ObjectProvider, methodName:String, selector:* = undefined, 
			messageType:ClassInfo = null, messageProperties:Array = null, order:int = int.MAX_VALUE) {
		super(provider, methodName, getMessageType(provider, methodName, messageType, messageProperties), selector, order);
		if (messageProperties != null) {
			setMessageProperties(messageProperties, messageType);
		}
	}

	private function getMessageType (provider:ObjectProvider, methodName:String, 
			explicitType:ClassInfo, messageProperties:Array) : Class {
		if (messageProperties != null) {
			return (explicitType != null) ? explicitType.getClass() : Object;
		}
		var targetMethod:Method = provider.type.getMethod(methodName);
		if (targetMethod == null) {
			throw new ContextError("Target instance of type " + provider.type.name 
					+ " does not contain a method with name " + methodName);
		}
		var params:Array = targetMethod.parameters;
		if (params.length > 1) {
			throw new ContextError("Target " + targetMethod  
				+ ": At most one parameter allowed for a MessageHandler.");
		}
		if (params.length == 1) {
			return getMessageTypeFromParameter(targetMethod, 0, explicitType);
		}
		else if (explicitType != null) {
			return explicitType.getClass();
		}		
		return Object;
	}
	
	private function setMessageProperties (messageProperties:Array, messageType:ClassInfo) : void {
		var requiredParams:uint = 0;
		var params:Array = targetMethod.parameters;
		for each (var param:Parameter in params) {
			if (param.required) requiredParams++;
		}
		if (requiredParams > messageProperties.length) {
			throw new ContextError("Number of specified parameter names does not match the number of required parameters of " 
				+ targetMethod + ". Required: " + requiredParams + " - actual: " + messageProperties.length);
			// We'll ignore if the the number of required params is less that needed, 
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
	
	protected function invokeMethod (message:Object) : * {
		var params:Array;
		if (messageProperties == null) {
			params = (targetMethod.parameters.length == 1) ? [message] : [];
		}
		else {
			params = new Array();
			for each (var messageProperty:Property in messageProperties) {
				var value:* = messageProperty.getValue(message);
				params.push(value);
			}
		}
		return targetMethod.invoke(targetInstance, params);
	}
	
	
}
}
