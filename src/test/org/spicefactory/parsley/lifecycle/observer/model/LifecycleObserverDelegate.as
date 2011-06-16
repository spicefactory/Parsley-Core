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

package org.spicefactory.parsley.lifecycle.observer.model {

import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;
import org.spicefactory.parsley.core.lifecycle.LifecycleObserver;
	
/**
 * @author Jens Halm
 */
public class LifecycleObserverDelegate implements LifecycleObserver {

	private var _observedType:Class;
	private var _phase:ObjectLifecycle;
	private var _objectId:String;
	
	private var callback:Function;

	function LifecycleObserverDelegate (callback:Function, observedType:Class, 
			phase:ObjectLifecycle, objectId:String = null) {
		this.callback = callback;
		
		_observedType = observedType;
		_phase = phase;
		_objectId = objectId;
	}

	public function get observedType () : Class {
		return _observedType;
	}

	public function get phase () : ObjectLifecycle {
		return _phase;
	}

	public function get objectId () : String {
		return _objectId;
	}

	public function observe (observed:Object) : void {
		callback(observed);
	}
	
}
}
