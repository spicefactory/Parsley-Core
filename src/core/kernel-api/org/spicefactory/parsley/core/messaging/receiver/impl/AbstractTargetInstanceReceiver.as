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
import org.spicefactory.parsley.core.context.provider.ObjectProvider;

[Deprecated(replacement="same class in new parsley.processor.messaging.receiver package")]
/**
 * @author Jens Halm
 */
public class AbstractTargetInstanceReceiver extends AbstractMessageReceiver {
	
	private var provider:ObjectProvider;
	
	function AbstractTargetInstanceReceiver (provider:ObjectProvider, 
			messageType:Class = null, selector:* = undefined, order:int = int.MAX_VALUE) {
		super(messageType, selector, order);
		this.provider = provider;
	}

	protected function get targetInstance () : Object {
		return provider.instance;
	}
	
	protected function get targetType () : ClassInfo {
		return provider.type;
	}
	
}
}
