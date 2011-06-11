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

package org.spicefactory.parsley.core.messaging.impl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.messaging.Message;

/**
 * Default implementation of the Message interface.
 * 
 * @author Jens Halm
 */
public class DefaultMessage implements Message {
	

	private var _instance:Object;
	private var _type:ClassInfo;
	private var _selector:*;
	private var _senderContext:Context;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param instance the message instance
	 * @param type the type of the message
	 * @param selector the selector to use to determine matching receivers
	 * @param senderContext the Context the message was dispatched from
	 */
	function DefaultMessage (instance:Object, type:ClassInfo, selector:*, senderContext:Context = null) {
		_instance = instance;
		_type = type;
		_selector = selector;
		_senderContext = senderContext;	
	}

	/**
	 * @inheritDoc
	 */
	public function get instance () : Object {
		return _instance;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get type () : ClassInfo {
		return _type;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get selector () : * {
		return _selector;
	}
	
	/**
	 * @inheritDoc
	 */
	public function set selector (value:*) : void {
		_selector = value;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get senderContext () : Context {
		return _senderContext;
	}
	
	
}
}
