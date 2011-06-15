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
package org.spicefactory.parsley.dsl.command {

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.command.ManagedCommand;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.core.messaging.Message;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.impl.DefaultMessage;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.processor.messaging.receiver.AbstractMessageReceiver;

/**
 * @author Jens Halm
 */
public class MappedCommandProxy extends AbstractMessageReceiver implements MessageTarget {


	private var factory:ManagedCommandFactory;


	public function MappedCommandProxy (factory:ManagedCommandFactory, 
			messageType:Class = null, selector:* = undefined, order:int = int.MAX_VALUE) {
		super(messageType, selector, order);
		this.factory = factory;
	}

	public function handleMessage (processor:MessageProcessor) : void {
		// TODO - change MessageProcessor interface, exposing Message directly instead
		var message:Message = new DefaultMessage(processor.message, 
				ClassInfo.forInstance(processor.message, processor.senderContext.domain), 
				processor.selector, processor.senderContext);
		var command:ManagedCommand = factory.newInstance(message);
		try {
			command.execute();
		}
		catch (e:Error) {
			return;
		}
		// TODO - managed command might call ScopeManager, too
		processor.senderContext.scopeManager.observeCommand(command);
	}
	
	
}
}

