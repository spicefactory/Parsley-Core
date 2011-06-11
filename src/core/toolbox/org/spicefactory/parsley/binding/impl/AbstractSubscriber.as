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
 
package org.spicefactory.parsley.binding.impl {
import org.spicefactory.lib.reflect.ClassInfo;

import flash.events.EventDispatcher;

/**
 * Abstract base class for all Subscriber implementations.
 * 
 * @author Jens Halm
 */
public class AbstractSubscriber extends EventDispatcher {
	
	
	private var _type:ClassInfo;
	private var _id:String;
	private var _unique:Boolean;

		
	/**
	 * Creates a new instance.
	 * 
	 * @param type the type of the subscribed value
	 * @param id the id the value is published with
	 * @param unique indicates whether there should only be one subscriber with
	 * the same type and id values
	 */
	function AbstractSubscriber (type:ClassInfo, id:String = null, unique:Boolean = false) {
		_type = type;
		_id = id;	
		_unique = unique;	
	}
	
	/**
	 * @copy org.spicefactory.parsley.binding.Publisher#type
	 */
	public function get type () : ClassInfo {
		return _type;
	}
	
	/**
	 * @copy org.spicefactory.parsley.binding.Publisher#id
	 */
	public function get id () : String {
		return _id;
	}
	
	/**
	 * @copy org.spicefactory.parsley.binding.Publisher#unique
	 */
	public function get unique () : Boolean {
		return _unique;
	}
	
	
}
}
