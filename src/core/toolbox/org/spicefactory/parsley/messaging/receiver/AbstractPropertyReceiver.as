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
import org.spicefactory.parsley.core.context.provider.ObjectProvider;

/**
 * Abstract base class for all message handlers where the message is handled
 * by or applied to a single property of the target instance.
 * 
 * @author Jens Halm
 */
public class AbstractPropertyReceiver extends AbstractObjectProviderReceiver implements PropertyReceiver {
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param info the mapping information for this receiver
	 */
	function AbstractPropertyReceiver (info: MessageReceiverInfo) {
		super(info);
	}
	
	/**
	 * @inheritDoc
	 */
	public function init (provider: ObjectProvider, property: Property): void {
		setProvider(provider);
		_targetProperty = property;
	}

	private var _targetProperty:Property;

	/**
	 * The property to process for matching messages.
	 */
	public function get targetProperty () : Property {
		return _targetProperty;
	}

	
}
}
