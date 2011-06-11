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
import flash.events.TimerEvent;
import flash.utils.getQualifiedClassName;
import flash.net.SharedObject;
import flash.utils.Timer;
import flash.events.EventDispatcher;
import org.spicefactory.parsley.binding.PersistenceManager;

/**
 * Default implementation of the PersistenceManager interface that persists to a local SharedObject.
 * 
 * @author Jens Halm
 */
public class LocalPersistenceManager extends EventDispatcher implements PersistenceManager {
	
	private var timer:Timer;
	private var lso:SharedObject;
	
	function LocalPersistenceManager (name:String = "parsley_persistence") {
		lso = SharedObject.getLocal(name);
	}
	
	/**
	 * @inheritDoc
	 */
	public function saveValue (scopeId:String, baseType:Class, id:String, value:Object) : void {
		var uuid:String = getUuid(scopeId, baseType, id);
		if (lso.data[uuid] !== value) {
			lso.data[uuid] = value;
			checkTimer();
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function deleteValue (scopeId:String, baseType:Class, id:String) : void {
		var uuid:String = getUuid(scopeId, baseType, id);
		delete lso.data[uuid];		
		checkTimer();
	}
	
	/**
	 * @inheritDoc
	 */
	public function getValue (scopeId:String, baseType:Class, id:String) : Object {
		var uuid:String = getUuid(scopeId, baseType, id);
		return lso.data[uuid];
	}
	
	private function getUuid (scopeId:String, baseType:Class, id:String) : String {
		return scopeId + "_" + getQualifiedClassName(baseType) + "_" + id;
 	}
	
	private function checkTimer () : void {
		if (!timer) {
			timer = new Timer(1, 1);
			timer.addEventListener(TimerEvent.TIMER, flush);
			timer.start();
		}
	}
	
	private function flush (event:TimerEvent = null) : void {
		timer = null;
		lso.flush();
	}
	
}
}
