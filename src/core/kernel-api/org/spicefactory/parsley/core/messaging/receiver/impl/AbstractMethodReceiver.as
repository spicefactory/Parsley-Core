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
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;

[Deprecated(replacement="same class in new parsley.processor.messaging.receiver package")]
/**
 * @author Jens Halm
 */
public class AbstractMethodReceiver extends AbstractTargetInstanceReceiver {
	
	private var _targetMethod:Method;
	
	function AbstractMethodReceiver (provider:ObjectProvider, methodName:String,  
			messageType:Class = null, selector:* = undefined, order:int = int.MAX_VALUE) {
		super(provider, messageType, selector, order);
		_targetMethod = targetType.getMethod(methodName);
		if (_targetMethod == null) {
			throw new ContextError("Target instance of type " + targetType.name 
					+ " does not contain a method with name " + methodName);
		}
	}

	protected function get targetMethod () : Method {
		return _targetMethod;
	}
	
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
