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
import org.spicefactory.parsley.core.messaging.receiver.MessageReceiver;

/**
 * Abstract base class for all types of message receivers.
 * 
 * @author Jens Halm
 */
public class AbstractMessageReceiver implements MessageReceiver {


	private var _info: MessageReceiverInfo;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param info the mapping information for the receiver
	 */
	function AbstractMessageReceiver (info: MessageReceiverInfo) {
		_info = info;
	}


	/**
	 * The receiver configuration in one (mutable) model object.
	 */
	protected function get info (): MessageReceiverInfo {
		return _info;
	}

	/**
	 * @inheritDoc
	 */
	public function get type () : Class {
		return (_info.type) ? _info.type.getClass() : Object;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get selector () : * {
		return _info.selector;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get order () : int {
		return _info.order;
	}
	
	
}
}
