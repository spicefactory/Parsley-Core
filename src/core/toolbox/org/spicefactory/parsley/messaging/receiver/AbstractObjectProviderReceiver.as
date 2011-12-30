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
import org.spicefactory.parsley.core.context.provider.ObjectProvider;

/**
 * Abstract base class for all types of message receivers that use an ObjectProvider for determining
 * the target instance handling the message.
 * An object provider is a convenient way to register lazy intializing message receivers where
 * the instantiation of the actual instance handling the message may be deferred until the first
 * matching message is dispatched. 
 * 
 * @author Jens Halm
 */
public class AbstractObjectProviderReceiver extends AbstractMessageReceiver {
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param info the mapping information for this receiver
	 */
	function AbstractObjectProviderReceiver (info: MessageReceiverInfo) {
		super(info);
	}


	private var _provider:ObjectProvider;
	
	/**
	 * Sets the provider for target instances for this receiver.
	 * 
	 * @param provider the provider for target instances for this receiver
	 */
	protected function setProvider (provider: ObjectProvider): void {
		_provider = provider;
	}
	
	/**
	 * The provider for the actual instance handling the message.
	 * Accessing the instance property of the provider may lead to initialization of the target instance in case
	 * it is lazy-intializing.
	 */
	public function get provider () : ObjectProvider {
		return _provider;
	}

	
}
}
