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

import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;

/**
 * A message target where a property value of matching messages is bound to a property of the target instance. 
 *  
 * @author Jens Halm
 */
public class DefaultMessageBinding extends AbstractPropertyReceiver implements MessageTarget {
	
	
	/**
	 * Creates a new instance. 
	 *
	 * @param info the mapping information for this receiver 
	 * @param messagePropertyName the name of the property of the message that should be bound to the target property
	 */
	function DefaultMessageBinding (info: MessageReceiverInfo, messagePropertyName: String) {
		
		super(info);
		
		_messageProperty = info.type.getProperty(messagePropertyName);
		if (_messageProperty == null) {
			throw new ContextError("Message type " + info.type.name 
					+ " does not contain a property with name " + _messageProperty);	
		}
		else if (!_messageProperty.readable) {
			throw new ContextError("Message " + _messageProperty + " is not readable");
		}		
	}
	
	
	private var _messageProperty:Property;
	
	/**
	 * The property of the message that should be bound to the target property.
	 */
	public function get messageProperty () : Property {
		return _messageProperty;
	}
		
		
	/**
	 * @inheritDoc
	 */
	public function handleMessage (processor:MessageProcessor) : void {
		var value:* = messageProperty.getValue(processor.message.instance);
		targetProperty.setValue(provider.instance, value);
	}
	

}
}
