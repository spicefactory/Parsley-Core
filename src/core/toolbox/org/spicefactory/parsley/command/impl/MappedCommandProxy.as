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
package org.spicefactory.parsley.command.impl {

import org.spicefactory.parsley.messaging.receiver.MessageReceiverInfo;
import org.spicefactory.lib.command.data.DefaultCommandData;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.core.command.ManagedCommandProxy;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.messaging.receiver.AbstractMessageReceiver;

/**
 * Parsley message target that executes a command when a message is
 * received.
 * 
 * @author Jens Halm
 */
public class MappedCommandProxy extends AbstractMessageReceiver implements MessageTarget {


	private var factory:ManagedCommandFactory;
	private var context:Context;


	/**
	 * Creates a new instance.
	 * 
	 * @param factory the factory to use for creating new commands
	 * @param context the Context that should manage all commands executed by this proxy
	 * @param messageType the type of message that should trigger command execution
	 * @param selector the optional selector to match messages
	 * @param order the execution order for this receiver compared to other handlers for the same message
	 */
	function MappedCommandProxy (factory: ManagedCommandFactory, context: Context, info: MessageReceiverInfo) {
		super(info);
		this.factory = factory;
		this.context = context;
	}

	/**
	 * @inheritDoc
	 */
	public function handleMessage (processor:MessageProcessor) : void {
		var command:ManagedCommandProxy = factory.newInstance();
		var data:DefaultCommandData = new DefaultCommandData();
		data.addValue(processor.message.instance);
		command.prepare(new ManagedCommandLifecycle(context, command, processor.message), data);
		try {
			command.execute();
		}
		catch (e:Error) {
			return;
		}
	}
	
	
}
}

