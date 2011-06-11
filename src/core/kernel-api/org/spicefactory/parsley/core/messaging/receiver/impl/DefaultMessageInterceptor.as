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
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;

[Deprecated(replacement="DefaultMessageHandler in parsley.processor.messaging.receiver package")]
/**
 * @author Jens Halm
 */
public class DefaultMessageInterceptor extends AbstractMethodReceiver implements MessageTarget {

	function DefaultMessageInterceptor (provider:ObjectProvider, methodName:String, messageType:Class,
			selector:* = undefined, order:int = int.MIN_VALUE) {
		super(provider, methodName, messageType, selector, order);
		var params:Array = targetMethod.parameters;
		if (params.length != 1 || Parameter(params[0]).type.getClass() != MessageProcessor) {
			throw new ContextError("Target " + targetMethod 
				+ ": Method must have exactly one parameter of type org.spicefactory.parsley.core.messaging.MessageProcessor.");
		}
	}
	
	public function handleMessage (processor:MessageProcessor) : void {
		processor.suspend();
		targetMethod.invoke(targetInstance, [processor]);
	}
	
}
}
