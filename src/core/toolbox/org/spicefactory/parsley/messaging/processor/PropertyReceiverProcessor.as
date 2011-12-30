/*
 * Copyright 2011 the original author or authors.
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
package org.spicefactory.parsley.messaging.processor {

import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.messaging.receiver.MessageReceiver;
import org.spicefactory.parsley.core.processor.PropertyProcessor;
import org.spicefactory.parsley.core.processor.StatefulProcessor;
import org.spicefactory.parsley.messaging.receiver.PropertyReceiver;

/**
 * Processor that registers message receivers for a target property.
 * 
 * @author Jens Halm
 */
public class PropertyReceiverProcessor extends MessageReceiverProcessor implements PropertyProcessor {


	private var property: Property;


	/**
	 * Creates a new processor factory.
	 * 
	 * @param factory the factory that produces new MessageReceiver instances for each target object
	 * @param scopeName the name of the scope the receivers listen to
	 */
	public function PropertyReceiverProcessor (factory: Function, scopeName: String) {
		super(factory, scopeName);
	}


	/**
	 * @inheritDoc
	 */
	public function targetProperty (property: Property): void {
		this.property = property;
	}
	
	/**
	 * @private
	 */
	protected override function prepareReceiver (receiver: MessageReceiver, provider: ObjectProvider): void {
		PropertyReceiver(receiver).init(provider, property);
	}
	
	/**
	 * @private
	 */
	public override function clone (): StatefulProcessor {
		return new PropertyReceiverProcessor(receiverFactory, scopeName);
	}
	
	
}
}
