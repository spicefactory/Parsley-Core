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
import org.spicefactory.parsley.core.messaging.command.CommandObserverProcessor;
import org.spicefactory.parsley.core.messaging.command.CommandStatus;
import org.spicefactory.parsley.core.messaging.receiver.CommandObserver;

[Deprecated(replacement="same class in new parsley.processor.messaging.receiver package")]
/**
 * @author Jens Halm
 */
public class DefaultCommandObserver extends AbstractMethodReceiver implements CommandObserver {
	
	private var _status:CommandStatus;
	
	function DefaultCommandObserver (provider:ObjectProvider, methodName:String, status:CommandStatus, 
			selector:* = undefined, messageType:ClassInfo = null, order:int = int.MAX_VALUE) {
		super(provider, methodName, getMessageType(provider, methodName, messageType), selector, order);
		_status = status;
	}

	private function getMessageType (provider:ObjectProvider, methodName:String, 
			explicitType:ClassInfo) : Class {
		var targetMethod:Method = provider.type.getMethod(methodName);
		if (targetMethod == null) {
			throw new ContextError("Target instance of type " + provider.type.name 
					+ " does not contain a method with name " + methodName);
		}
		var params:Array = targetMethod.parameters;
		if (params.length > 2) {
			throw new ContextError("Target " + targetMethod  
				+ ": At most two parameters allowed for a MessageHandler.");
		}
		if (params.length == 2) {
			return getMessageTypeFromParameter(targetMethod, 1, explicitType);
		}
		else if (explicitType != null) {
			return explicitType.getClass();
		}		
		return Object;
	}
		
	public function observeCommand (processor:CommandObserverProcessor) : void {
		var paramTypes:Array = targetMethod.parameters;
		var params:Array = new Array();
		if (paramTypes.length >= 1) {
			var resultType:ClassInfo = Parameter(paramTypes[0]).type;
			params.push(processor.command.getResult(resultType));
		}
		if (paramTypes.length == 2) {
			params.push(processor.command.message);
		}
		targetMethod.invoke(targetInstance, params);
	}
	
	public function get status () : CommandStatus {
		return _status;
	}
	
}
}
