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
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;

[Deprecated(replacement="same class in new parsley.processor.messaging.receiver package")]
/**
 * @author Jens Halm
 */
public class MessageBinding extends AbstractTargetInstanceReceiver implements MessageTarget {
	
	private var targetProperty:Property;
	private var messageProperty:Property;
	
	function MessageBinding (provider:ObjectProvider, targetPropertyName:String, 
			messageType:ClassInfo, messagePropertyName:String, selector:* = undefined, order:int = int.MAX_VALUE) {
		super(provider, messageType.getClass(), selector, order);
		targetProperty = targetType.getProperty(targetPropertyName);
		if (targetProperty == null) {
			throw new ContextError("Target type " + targetType.name 
					+ " does not contain a property with name " + targetProperty);	
		}
		else if (!targetProperty.writable) {
			throw new ContextError("Target " + targetProperty + " is not writable");
		}
		messageProperty = messageType.getProperty(messagePropertyName);
		if (messageProperty == null) {
			throw new ContextError("Message type " + messageType.name 
					+ " does not contain a property with name " + messageProperty);	
		}
		else if (!messageProperty.readable) {
			throw new ContextError("Message " + messageProperty + " is not readable");
		}		
	}
	
	public function handleMessage (processor:MessageProcessor) : void {
		var value:* = messageProperty.getValue(processor.message);
		targetProperty.setValue(targetInstance, value);
	}
	
}
}
