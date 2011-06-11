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
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.command.Command;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;

[Deprecated(replacement="same class in new parsley.processor.messaging.receiver package")]
/**
 * @author Jens Halm
 */
public class DefaultCommandTarget extends AbstractMessageHandler implements MessageTarget {
	
	private var _returnType:Class;
	
	function DefaultCommandTarget (provider:ObjectProvider, methodName:String, selector:* = undefined, 
			messageType:ClassInfo = null, messageProperties:Array = null, order:int = int.MAX_VALUE) {
		super(provider, methodName, selector, messageType, messageProperties, order);
		setReturnType(provider.type, methodName);
	}
	
	private function setReturnType (type:ClassInfo, methodName:String) : void {
		var targetMethod:Method = type.getMethod(methodName);
		_returnType = targetMethod.returnType.getClass();
	}
	
	public function get returnType () : Class {
		return _returnType;
	}
	
	public function handleMessage (processor:MessageProcessor) : void {
		var returnValue:* = invokeMethod(processor.message);
		var command:Command = processor.createCommand(returnValue);
		processor.senderContext.scopeManager.observeCommand(command);
	}
	
}
}
