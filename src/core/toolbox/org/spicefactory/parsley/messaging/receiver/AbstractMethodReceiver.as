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
public class AbstractMethodReceiver extends AbstractObjectProviderReceiver implements MethodReceiver {
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param info the mapping information for this receiver
	 */
	function AbstractMethodReceiver (info: MessageReceiverInfo) {
		
		super(info);
		
		/*
		if (_targetMethod == null) {
			throw new ContextError("Target instance of type " + provider.type.name 
					+ " does not contain a method with name " + methodName);
		}
		 */
	}
	
	/**
	 * @inheritDoc
	 */
	public function init (provider: ObjectProvider, method: Method): void {
		setProvider(provider);
		_targetMethod = method;
	}

	private var _targetMethod:Method;

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
	 */
	protected function deduceMessageTypeFromParameter (method:Method, paramIndex:uint) : void {
		var param:Parameter = method.parameters[paramIndex];
		if (!info.type) {
			info.type = param.type;
		}
		else if (!info.type.isType(param.type.getClass())) {
			throw new ContextError("Target " + method
				+ ": Method parameter of type " + param.type.name
				+ " is not applicable to message type " + info.type.name);
		}
	}

	
}
}
