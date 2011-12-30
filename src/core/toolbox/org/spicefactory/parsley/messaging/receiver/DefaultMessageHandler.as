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

package org.spicefactory.parsley.messaging.receiver {

import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.MessageProcessor;

/**
 * Abstract base class for regular message handlers where the message is simply passed to a method on the target instance.
 * 
 * @author Jens Halm
 */
public class DefaultMessageHandler extends AbstractMethodReceiver implements MessageTarget {
	
	
	private var isInterceptor:Boolean;
	private var messageProperties:Array;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param info the mapping information for the receiver
	 * @param messageProperties the list of names of properties of the message that should be used as method parameters
	 */
	function DefaultMessageHandler (info: MessageReceiverInfo, messageProperties:Array = null) {
		
		super(info); 
			
		this.messageProperties = messageProperties;
	}


	/**
	 * @private
	 */
	public override function init (provider: ObjectProvider, method: Method): void {
		
		super.init(provider, method);
		
		if (!messageProperties) {	
			deduceMessageType();
			deduceSelector();
		}
		else {
			setMessageProperties();
		}
		
		var params: Array = targetMethod.parameters;
		isInterceptor = (params.length > 0) && Parameter(params[params.length - 1]).type.isType(MessageProcessor);
	}
	
	
	private function deduceMessageType () : void {
		
		var params:int = targetMethod.parameters.length;
		if (params > 3) {
			throw new ContextError("Target " + targetMethod  
				+ ": At most 3 parameters allowed for this type of message handler.");
		}
		if (params > 1 || (params == 1 && !targetMethod.parameters[0].type.isType(MessageProcessor))) {
			deduceMessageTypeFromParameter(targetMethod, 0);
		}
	}
	
	private function deduceSelector () : void {
		
		var params:Array = targetMethod.parameters;
		if (params.length >= 2) {
			var param:Parameter = params[1];
			if (!param.type.isType(MessageProcessor)) {
				info.selector = param.type.getClass();
			}
		}
	}
	
	private function setMessageProperties () : void {
		
		var requiredParams:uint = 0;
		var params:Array = targetMethod.parameters;
		for each (var param:Parameter in params) {
			if (param.required) requiredParams++;
		}
		if (requiredParams > 0) {
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
		var resolved:Array = new Array();
		for each (var propertyName:String in messageProperties) {
			var messageProperty:Property = info.type.getProperty(propertyName);
			if (messageProperty == null) {
				throw new ContextError("Message type " + info.type.name 
						+ " does not contain a property with name " + propertyName);	
			}
			else if (!messageProperty.readable) {
				throw new ContextError(messageProperty.toString() + " is not readable");
			}
			resolved.push(messageProperty);
		}
		messageProperties = resolved;
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
		var params:Array = new Array();
		if (messageProperties == null) {
			var cnt:int = targetMethod.parameters.length;
			if (cnt >= 1) {
				var param0:Parameter = targetMethod.parameters[0];
				if (param0.type.isType(MessageProcessor)) {
					params.push(processor);
				}
				else {
					params.push(processor.message.instance);
				}
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
		targetMethod.invoke(provider.instance, params);
	}
	
	
}
}
