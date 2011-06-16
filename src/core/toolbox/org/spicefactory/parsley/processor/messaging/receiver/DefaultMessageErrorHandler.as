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
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;
import org.spicefactory.parsley.processor.messaging.MessageReceiverFactory;
import org.spicefactory.parsley.processor.util.MessageReceiverFactories;

/**
 * Default implementation of the MessageErrorHandler interface.
 * 
 * @author Jens Halm
 */
public class DefaultMessageErrorHandler extends AbstractMethodReceiver implements MessageErrorHandler {


	private var _errorType:Class;

	
	/**
	 * Creates a new instance.
	 * The target method must have a parameter of type <code>org.spicefactory.parsley.messaging.MessageProcessor</code>
	 * and a second parameter of type Error (or a subtype).
	 * 
	 * @param provider the provider for the actual instance handling the message
	 * @param methodName the name of the method to invoke for matching messages
	 * @param messageType the type of the message this error handler is interested in
	 * @param selector an additional selector value to be used to determine matching messages
	 * @param errorType the type of Error this handler is interested in
	 * @param order the execution order for this receiver
	 */
	function DefaultMessageErrorHandler (provider:ObjectProvider, methodName:String, messageType:Class,
			selector:* = undefined, errorType:ClassInfo = null, order:int = int.MAX_VALUE) {
		super(provider, methodName, messageType, selector, order);
		var params:Array = targetMethod.parameters;
		if (params.length < 1 || params.length > 2) {
			throw new ContextError("Target " + targetMethod 
				+ ": Method must have one or two parameters.");
		}
		if (Parameter(params[0]).type.getClass() != MessageProcessor) {
			throw new ContextError("Target " + targetMethod 
				+ ": First parameter must be of type org.spicefactory.parsley.core.messaging.MessageProcessor.");
			
		}
		if (params.length == 2) {
			var paramType:ClassInfo = Parameter(params[1]).type;
			if (!paramType.isType(Error)) {
				throw new ContextError("Target " + targetMethod 
					+ ": Second parameter must be of type Error or a subtype");
			}
			if (errorType == null) {
				errorType = paramType;
			}
			else if (!errorType.isType(paramType.getClass())) {
				throw new ContextError("Target " + targetMethod
					+ ": Method parameter of type " + paramType.name
					+ " is not applicable to error type " + errorType.name);
			}
			_errorType = errorType.getClass();
		}
		else if (errorType == null) {
			_errorType = Error;
		}			
	}


	/**
	 * @inheritDoc
	 */
	public function get errorType () : Class {
		return _errorType;
	}
	
	/**
	 * @inheritDoc
	 */
	public function handleError (processor:MessageProcessor, error:Error) : void {
		//processor.suspend();
		var params:Array = (targetMethod.parameters.length == 2) ? [processor, error] : [processor];
		targetMethod.invoke(provider.instance, params);
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
	public static function newFactory (methodName:String, messageType:Class, 
			selector:* = undefined, errorType:ClassInfo = null, order:int = int.MAX_VALUE) : MessageReceiverFactory {
				
		return MessageReceiverFactories.newFactory(DefaultMessageErrorHandler, [methodName, messageType, selector, errorType, order]);
	}
	

}
}
