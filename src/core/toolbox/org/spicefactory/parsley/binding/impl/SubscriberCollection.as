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

import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.binding.Publisher;
import org.spicefactory.parsley.binding.Subscriber;

import flash.events.Event;
import flash.utils.Dictionary;

/**
 * Internal collection utility used by the default BindingManager implementation.
 * 
 * @author Jens Halm
 */
public class SubscriberCollection {
	
	
	private static const log:Logger = LogContext.getLogger(SubscriberCollection);
	
	
	private var _type:ClassInfo;
	
	private var subscribers:ArrayMap = new ArrayMap();
	private var publishers:ArrayMap = new ArrayMap();
	
	private var currentValue:Dictionary = new Dictionary();
	
	/**
	 * Creates a new instance.
	 * 
	 * @param type the type the elements of this collection subscribe to
	 */
	function SubscriberCollection (type:ClassInfo) {
		_type = type;
	}
	
	
	/**
	 * The type the elements of this collection subscribe to.
	 */
	public function get type () : ClassInfo {
		return _type;
	}
	
	/**
	 * Indicates whether this collection does not contain any subscribers.
	 * Publishers are not considered.
	 */
	public function get empty () : Boolean {
		return subscribers.empty;
	}
	
	/**
	 * Indicates whether the specified publisher would affect the subscribers of this collection.
	 * 
	 * @param publisher the publisher to check
	 * @return true if the specified publisher would affect the subscribers of this collection
	 */
	public function isMatchingType (publisher:Publisher) : Boolean {
		return publisher.type.isType(type.getClass());
	}
	
	/**
	 * Adds a publisher that affects the subscribers of this collection.
	 * 
	 * @param publisher the publisher to add
	 */
	public function addPublisher (publisher:Publisher) : void {
		if (publishers.getSize(publisher.id) > 0) {
			var all:Array = publishers.getAll(publisher.id);
			validate(all[all.length - 1] as Publisher, publisher, publisher.id);
		}
		publishers.put(publisher.id, publisher);
		processPublisherValue(publisher);
		publisher.addEventListener(Event.CHANGE, publisherChanged);
	}
	
	private function publisherChanged (event:Event) : void {
		processPublisherValue(event.target as Publisher);
	}
	
	private function processPublisherValue (publisher:Publisher) : void {
		if (log.isInfoEnabled()) {
			log.info("Updated value for {0}", publisher);
		}
		setCurrentValue(publisher.id, publisher.currentValue);	
	}
		
	private function setCurrentValue (id:String, value:*) : void {
		if (currentValue[id] === value) return;
		currentValue[id] = value;
		for each (var subscriber:Subscriber in subscribers.getAll(id)) {
			subscriber.update(value);
		}
	}
	
	private function validate (p1:Publisher, p2:Publisher, id:String) : void {
		var idMsg:String = (id == null) ? " without id" : " with id " + id;
		if (p1.type.getClass() != p2.type.getClass()) {
			throw new IllegalArgumentError("Ambiguous publishers for subscribers of type " + type.name + idMsg 
					+ ": " + p1 + " and " + p2 + " - all publishers must publish exactly the same type in this case");
		}
		if (!(p1 is Subscriber) || !(p2 is Subscriber)) {
			throw new IllegalArgumentError("Multiple publishers for suscribers of type " + type.name + idMsg
					+ ": all publishers must also be subscribers in this case");
		}
	}
	
	/**
	 * Removes a publisher from this collection.
	 * 
	 * @param publisher the publisher to remove
	 */
	public function removePublisher (publisher:Publisher) : void {
		publisher.removeEventListener(Event.CHANGE, publisherChanged);
		publishers.remove(publisher.id, publisher);
		if (publishers.getSize(publisher.id) == 0) {
			setCurrentValue(publisher.id, undefined);
		}
	}
	
	
	/**
	 * Adds a subscriber to this collection.
	 * 
	 * @param subscriber the subscriber to add
	 */
	public function addSubscriber (subscriber:Subscriber) : void {
		subscribers.put(subscriber.id, subscriber);
		if (!(subscriber is Publisher) || publishers.getSize(subscriber.id) > 0) {
			subscriber.update(currentValue[subscriber.id]);
		}
	}

	/**
	 * Removes a subscriber from this collection.
	 * 
	 * @param subscriber the subscriber to remove
	 */
	public function removeSubscriber (subscriber:Subscriber) : void {
		subscribers.remove(subscriber.id, subscriber);
		subscriber.update(undefined);
	}
	
	
}
}
