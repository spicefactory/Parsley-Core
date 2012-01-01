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
import flash.events.Event;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.binding.PersistenceManager;
import org.spicefactory.parsley.core.binding.Publisher;
import org.spicefactory.parsley.core.binding.Subscriber;


/**
 * @author Jens Halm
 */
public class PersistentPublisher extends AbstractPublisher implements Publisher, Subscriber {
	
	private var manager:PersistenceManager;
	private var key:Object;
	private var subscriber:Subscriber;
	
	function PersistentPublisher (manager:PersistenceManager, type:ClassInfo, id:String = null, persistentKey:Object = null) {
		super(type, id, true);
		this.manager = manager;
		this.key = persistentKey || id;
		this.subscriber = new PersistentSubscriber(manager, type, id, persistentKey);
	}

	/**
	 * @inheritDoc
	 */
	public function init () : void {
		manager.addEventListener(Event.CHANGE, persistenceChange);
	}
	
	/**
	 * @inheritDoc
	 */
	public function dispose () : void {
		manager.removeEventListener(Event.CHANGE, persistenceChange);
	}
	
	private function persistenceChange (event:Event) : void {
		dispatchEvent(new Event(Event.CHANGE));
	}

	/**
	 * @inheritDoc
	 */
	public function get currentValue () : * {
		return manager.getValue(key);
	}
	
	/**
	 * Prevents any updates from getting passed to the persistence mechanism.
	 */
	public function disableSubscriber () : void {
		subscriber = null;
	}
	
	/**
	 * @inheritDoc
	 */
	public function update (newValue : *) : void {
		if (!subscriber) return;
		enabled = false;
		try {
			subscriber.update(newValue);
		}
		finally {
			enabled = true;
		}
	}
	
	
	/**
	 * @private
	 */
	public override function toString () : String {
		return "[PersistentPublishSubscribe(key=" + key + ",type=" + type.name 
				+ ((id) ? ",id=" + id : "") + ")]";
	}

}
}
