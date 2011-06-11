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
import org.spicefactory.parsley.core.messaging.receiver.MessageReceiver;

[Deprecated(replacement="same class in new parsley.processor.messaging.receiver package")]
/**
 * @author Jens Halm
 */
public class AbstractMessageReceiver implements MessageReceiver {

	private var _messageType:Class;
	private var _selector:*;
	private var _order:int;
	
	function AbstractMessageReceiver (messageType:Class = null, selector:* = undefined, order:int = int.MAX_VALUE) {
		_messageType = (messageType != null) ? messageType : Object;
		_selector = selector;
		_order = order;
	}

	public function get messageType () : Class {
		return _messageType;
	}
	
	public function get selector () : * {
		return _selector;
	}
	
	public function get order () : int {
		return _order;
	}
	
}
}
