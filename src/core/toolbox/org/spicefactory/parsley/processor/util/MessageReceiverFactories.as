/*
 * Copyright 2010 the original author or authors.
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

package org.spicefactory.parsley.processor.util {
import org.spicefactory.parsley.processor.messaging.MessageReceiverFactory;

/**
 * Utility methods for creating MessageReceiverFactory instances.
 * 
 * @author Jens Halm
 */
public class MessageReceiverFactories {

	
	/**
	 * Create a new receiver factory instance of the specified type, using the provided constructor arguments.
	 * The specified arguments will always be added to the provider argument of type <code>ObjectProvider</code>
	 * which will always be the first argument. The specified type must implement the <code>MessageReceiver</code>
	 * interface.
	 * 
	 * @param receiverType the type of receiver to create
	 * @param additionalArgs constructor arguments for the receiver in addition to the provider argument
	 * @return a new MessageReceiverFactory instance
	 */
	public static function newFactory (receiverType:Class, additionalArgs:Array = null) : MessageReceiverFactory {
		if (additionalArgs == null) additionalArgs = [];
		return new SimpleMessageReceiverFactory(receiverType, additionalArgs);
	}
	
	
}
}

import org.spicefactory.lib.util.ClassUtil;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.messaging.receiver.MessageReceiver;
import org.spicefactory.parsley.processor.messaging.MessageReceiverFactory;

class SimpleMessageReceiverFactory implements MessageReceiverFactory {

	private var receiverType:Class;
	private var additionalArgs:Array;

	function SimpleMessageReceiverFactory (receiverType:Class, additionalArgs:Array) {
		this.receiverType = receiverType;
		this.additionalArgs = additionalArgs;
	}

	public function createReceiver (provider:ObjectProvider) : MessageReceiver {
		var args:Array = additionalArgs.concat();
		args.unshift(provider);
		return MessageReceiver(ClassUtil.createNewInstance(receiverType, args));
	}
	
}