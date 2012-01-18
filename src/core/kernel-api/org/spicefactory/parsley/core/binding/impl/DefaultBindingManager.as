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
 
package org.spicefactory.parsley.core.binding.impl {

import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.util.ArrayUtil;
import org.spicefactory.parsley.core.binding.BindingManager;
import org.spicefactory.parsley.core.binding.Publisher;
import org.spicefactory.parsley.core.binding.Subscriber;

/**
 * Default implementation of the BindingManager interface.
 * 
 * @author Jens Halm
 */
public class DefaultBindingManager implements BindingManager {


	private var publishers:Array = new Array();
	private var subscribers:Map = new Map();
	private var uniqueElements:UniqueElements = new UniqueElements();


	/**
	 * @inheritDoc
	 */
	public function addPublisher (publisher:Publisher) : void {
		if (publisher.unique && !uniqueElements.addPublisher(publisher)) {
			return;
		}
		doAddPublisher(publisher, true);
	}
	
	private function doAddPublisher (publisher:Publisher, checkSubsriber:Boolean) : void {
		/*
		 * TODO - 3.1 - this is probably a bit too much black magic - for the persistent publisher
		 * the publisher must be added before the subscriber, for a regular publisher it's the other way
		 * round. Probably it should be left to the processor to add subscribers and publishers separately,
		 * even if the same instance is implementing both interfaces. This way all implementations can decide
		 * themselves on the right order.
		 */
		if (checkSubsriber && publisher is Subscriber && !publisher.unique) doAddSubscriber(publisher as Subscriber, false);
		publisher.init();
		publishers.push(publisher);
		for each (var collection:SubscriberCollection in subscribers.values) {
			if (collection.isMatchingType(publisher)) {
				collection.addPublisher(publisher);
			}
		}
		if (checkSubsriber && publisher is Subscriber && publisher.unique) doAddSubscriber(publisher as Subscriber, false);
	}


	/**
	 * @inheritDoc
	 */
	public function removePublisher (publisher:Publisher) : void {
		if (publisher.unique && !uniqueElements.removePublisher(publisher)) {
			return;
		}
		doRemovePublisher(publisher, true);
	}
	
	private function doRemovePublisher (publisher:Publisher, checkSubsriber:Boolean) : void {
		publisher.dispose();
		ArrayUtil.remove(publishers, publisher);
		for each (var collection:SubscriberCollection in subscribers.values) {
			if (collection.isMatchingType(publisher)) {
				collection.removePublisher(publisher);
			}
		}
		if (checkSubsriber && publisher is Subscriber) doRemoveSubscriber(publisher as Subscriber, false);
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function addSubscriber (subscriber:Subscriber) : void {
		if (subscriber.unique && !uniqueElements.addSubscriber(subscriber)) {
			return;
		}
		doAddSubscriber(subscriber, true);
	}
	
	private function doAddSubscriber (subscriber:Subscriber, checkPublisher:Boolean) : void {
		var collection:SubscriberCollection = getCollection(subscriber.type);
		if (collection.empty) {
			for each (var publisher:Publisher in publishers.concat()) {
				if (collection.isMatchingType(publisher)) {
					collection.addPublisher(publisher);
				}
			}
		}
		collection.addSubscriber(subscriber);
		if (checkPublisher && subscriber is Publisher) doAddPublisher(subscriber as Publisher, false);
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeSubscriber (subscriber:Subscriber) : void {
		if (subscriber.unique && !uniqueElements.removeSubscriber(subscriber)) {
			return;
		}
		doRemoveSubscriber(subscriber, true);
	}
	
	private function doRemoveSubscriber (subscriber:Subscriber, checkPublisher:Boolean) : void {
		var collection:SubscriberCollection = getCollection(subscriber.type, false);
		if (collection != null) {
			collection.removeSubscriber(subscriber);
			if (collection.empty) {
				collection.dispose();
				subscribers.remove(subscriber.type.getClass());
			}
		}
		if (checkPublisher && subscriber is Publisher) doRemovePublisher(subscriber as Publisher, false);
	}
	
	
	private function getCollection (type:ClassInfo, create:Boolean = true) : SubscriberCollection {
		var collection:SubscriberCollection = subscribers.get(type.getClass()) as SubscriberCollection;
		if (collection == null && create) {
			collection = new SubscriberCollection(type);
			subscribers.put(type.getClass(), collection);
		}
		return collection;
	}
}
}

import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.util.DictionaryUtil;
import org.spicefactory.parsley.core.binding.Publisher;
import org.spicefactory.parsley.core.binding.Subscriber;


class UniqueElements {
	
	private var publishers:Dictionary = new Dictionary();
	private var subscribers:Dictionary = new Dictionary();
	
	public function addPublisher (publisher:Publisher) : Boolean {
		return addElement(publishers, publisher.type.getClass(), id(publisher, publisher.id));
	}
	
	public function addSubscriber (subscriber:Subscriber) : Boolean {
		return addElement(subscribers, subscriber.type.getClass(), id(subscriber, subscriber.id));
	}
	
	public function removePublisher (publisher:Publisher) : Boolean {
		return removeElement(publishers, publisher.type.getClass(), id(publisher, publisher.id));
	}
	
	public function removeSubscriber (subscriber:Subscriber) : Boolean {
		return removeElement(subscribers, subscriber.type.getClass(), id(subscriber, subscriber.id));
	}
	
	private function id (element:Object, id:String) : String {
		return getQualifiedClassName(element) + "#" + id;
	}
	
	private function addElement (elements:Dictionary, type:Class, id:String) : Boolean {
		var ids:Dictionary = elements[type] as Dictionary;
		if (!ids) {
			ids = new Dictionary();
			elements[type] = ids;
		}
		if (ids[id]) {
			ids[id]++;
			return false;
		}
		else 
		{
			ids[id] = 1;
			return true;
		}
	}
	
	private function removeElement (elements:Dictionary, type:Class, id:String) : Boolean {
		var ids:Dictionary = elements[type] as Dictionary;
		if (!ids) {
			throw new IllegalStateError("No elements managed for type " + type);
		}
		if (ids[id] > 1)
		{
			ids[id]--;
			return false;
		}
		else 
		{
			delete ids[id];
			if (DictionaryUtil.isEmpty(ids)) {
				delete elements[type];
			}
			return true;
		}
	}
	
}


