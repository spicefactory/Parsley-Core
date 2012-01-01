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

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;

/**
 * Default implementation of the MessageErrorHandler interface.
 * 
 * @author Jens Halm
 */
public class DefaultMessageErrorHandler extends AbstractMethodReceiver implements MessageErrorHandler {


	private var _errorType:ClassInfo;

	
	/**
	 * Creates a new instance.
	 * The target method must have a parameter of type <code>org.spicefactory.parsley.messaging.MessageProcessor</code>
	 * and a second parameter of type Error (or a subtype).
	 * 
	 * @param info the mapping information for the receiver
	 * @param errorType the type of Error this handler is interested in
	 */
	function DefaultMessageErrorHandler (info:MessageReceiverInfo = null, errorType:ClassInfo = null) {
		
		super(info || new MessageReceiverInfo());
		_errorType = errorType;
	}
	
	
	/**
	 * @private
	 */
	public override function init (provider: ObjectProvider, method: Method): void {
		
		super.init(provider, method);	
		
		var params:Array = targetMethod.parameters;
		if (params.length > 4 || params.length < 1) {
			throw new ContextError("Target " + targetMethod 
				+ ": An error handler must have a minimum of 1 and a maximum of 4 parameters:"
				+ " (error, [message, [selector]], [MessageProcessor].");
		}

		deduceErrorType();
		if (deduceMessageType()) deduceSelector();
	}
	
	private function deduceMessageType () : Boolean {
		var params:Array = targetMethod.parameters;
		if (params.length >= 2 && !targetMethod.parameters[1].type.isType(MessageProcessor)) {
			deduceMessageTypeFromParameter(targetMethod, 1);
			return true;
		}
		return false;
	}
	
	private function deduceSelector () : void {
		var params:Array = targetMethod.parameters;
		if (params.length >= 3 && !targetMethod.parameters[2].type.isType(MessageProcessor)) {
			info.selector = targetMethod.parameters[2].type.getClass();
		}
	}
	
	private function deduceErrorType (): void {
		var params:Array = targetMethod.parameters;
		var explicitType: ClassInfo = _errorType;
		var paramType:ClassInfo = Parameter(params[0]).type;
		if (!paramType.isType(Error)) {
			throw new ContextError("Target " + targetMethod 
				+ ": First Parameter must be of type Error or a subtype");
		}
		if (!explicitType) {
			_errorType = paramType;
		}
		else if (!explicitType.isType(paramType.getClass())) {
			throw new ContextError("Target " + targetMethod
				+ ": Method parameter of type " + paramType.name
				+ " is not applicable to error type " + explicitType.name);
		}
		else {
			_errorType = explicitType;
		}
	}


	/**
	 * @inheritDoc
	 */
	public function get errorType () : Class {
		return _errorType.getClass();
	}
	
	/**
	 * @inheritDoc
	 */
	public function handleError (processor:MessageProcessor, error:Error) : void {
		var params:Array = new Array();
		params.push(error);

		var cnt:int = targetMethod.parameters.length;

		if (cnt >= 2) {
			var param1:Parameter = targetMethod.parameters[1];
			if (param1.type.isType(MessageProcessor)) {
				params.push(processor);
			}
			else {
				params.push(processor.message.instance);
			}
			if (cnt >= 3) {
				var param2:Parameter = targetMethod.parameters[2];
				if (param2.type.isType(MessageProcessor)) {
					params.push(processor);
				}
				else if (processor.message.selector is Class) {
					params.push(null);
				}
				else {
					params.push(processor.message.selector);
				}
				if (cnt >= 4) {
					params.push(processor);
				}
			}
		}
		targetMethod.invoke(provider.instance, params);
	}
	

}
}
