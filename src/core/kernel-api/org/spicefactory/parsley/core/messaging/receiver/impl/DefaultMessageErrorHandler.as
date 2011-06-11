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
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;

[Deprecated(replacement="same class in new parsley.processor.messaging.receiver package")]
/**
 * @author Jens Halm
 */
public class DefaultMessageErrorHandler extends AbstractMethodReceiver implements MessageErrorHandler {

	private var _errorType:Class;

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

	public function get errorType () : Class {
		return _errorType;
	}
	
	public function handleError (processor:MessageProcessor, error:Error) : void {
		processor.suspend();
		var params:Array = (targetMethod.parameters.length == 2) ? [processor, error] : [processor];
		targetMethod.invoke(targetInstance, params);
	}

}
}
