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
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;

/**
 * Abstract base class for all message handlers where the message is handled
 * by a method invocation on the target instance.
 * 
 * @author Jens Halm
 */
public class AbstractMethodReceiver extends AbstractObjectProviderReceiver {
	
	
	private var _targetMethod:Method;
	
	/**
	 * Creates a new instance.
	 * 
	 * @param provider the provider for the actual instance handling the message
	 * @param methodName the name of the method to invoke for matching messages
	 * @param messageType the type of the message this receiver is interested in
	 * @param selector an additional selector value to be used to determine matching messages
	 * @param order the execution order for this receiver
	 */
	function AbstractMethodReceiver (provider:ObjectProvider, methodName:String,  
			messageType:Class = null, selector:* = undefined, order:int = int.MAX_VALUE) {
		super(provider, messageType, selector, order);
		_targetMethod = provider.type.getMethod(methodName);
		if (_targetMethod == null) {
			throw new ContextError("Target instance of type " + provider.type.name 
					+ " does not contain a method with name " + methodName);
		}
	}

	/**
	 * The method to invoke for matching messages.
	 */
	public function get targetMethod () : Method {
		return _targetMethod;
	}
	
	/**
	 * Returns the Class to use as the message type.
	 * When the explicit type is set, this method will validate if it matches the target parameter of the method
	 * (subtypes are allowed). If omitted the message type will be solely determined by the parameter type.
	 * 
	 * @param method the target method
	 * @param paramIndex the index of the parameter that expects the dispatched message
	 * @param explicitType the message type explicitly set for this receiver
	 */
	protected function getMessageTypeFromParameter (method:Method, paramIndex:uint, explicitType:ClassInfo = null) : Class {
		var param:Parameter = method.parameters[paramIndex];
		if (explicitType == null) {
			return param.type.getClass();
		}
		else if (!explicitType.isType(param.type.getClass())) {
			throw new ContextError("Target " + method
				+ ": Method parameter of type " + param.type.name
				+ " is not applicable to message type " + explicitType.name);
		}
		else {
			return explicitType.getClass();
		}
	}
	
	
}
}
