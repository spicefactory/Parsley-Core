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

package org.spicefactory.parsley.core.messaging.impl {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import org.spicefactory.lib.util.ArrayUtil;
import org.spicefactory.parsley.core.messaging.MessageReceiverKind;
import org.spicefactory.parsley.core.messaging.receiver.MessageReceiver;

/**
 * Dispatched when a message receiver was added to or removed from the collection.
 * 
 * @eventType flash.events.Event.CHANGE
 */
[Event(name="change", type="flash.events.Event")]

/**
 * A collection of message receivers for a particular message type.
 * 
 * @author Jens Halm
 */
public class MessageReceiverCollection extends EventDispatcher {
	
	
	private var byValue:Dictionary = new Dictionary();
	private var byType:Dictionary = new Dictionary();
	private var anySelector:Dictionary = new Dictionary();
	
	private var _messageType:Class;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param messageType the type of the message
	 */
	function MessageReceiverCollection (messageType:Class) {
		_messageType = messageType;
	}
	
	
	/**
	 * The type of message receivers in this collection are interested in.
	 */
	public function get messageType () : Class {
		return _messageType;
	}
	
	/**
	 * Returns all receivers of a particular kind that match for the specified selector value.
	 * 
	 * @param kind the kind of receiver to fetch
	 * @param selectorValue the value of the selector property
	 * @return all receivers of a particular kind that match for the specified selector value
	 */	
	public function getReceiversBySelectorValue (kind:MessageReceiverKind, selectorValue:*) : Array {
		if (selectorValue == undefined) {
			var any:Array = anySelector[kind] as Array;
			return (any) ? any : [];
		}
		var array:Array = (selectorValue is Class) 
				? byType[kind] as Array : byValue[kind] as Array;
		var filtered:Array = new Array();
		if (array != null) {
			for each (var receiver:MessageReceiver in array) {
				if (receiver.selector == selectorValue) {
					filtered.push(receiver);
				}
			}
		}
		return addReceiversMatchingAnySelector(kind, filtered);
	}
	
	public function getReceiversBySelectorType (kind:MessageReceiverKind, selectorValue:*) : Array {
		if (selectorValue == undefined) {
			var any:Array = anySelector[kind] as Array;
			return (any) ? any : [];
		}
		var array:Array = byType[kind] as Array;
		var filtered:Array = new Array();
		if (array != null) {
			for each (var receiver:MessageReceiver in array) {
				var type:Class = receiver.selector as Class;
				if (selectorValue is type) {
					filtered.push(receiver);
				}
			}
		}
		return addReceiversMatchingAnySelector(kind, filtered);
	}
	
	private function addReceiversMatchingAnySelector (kind:MessageReceiverKind, receivers:Array) : Array {
		var anys:Array = anySelector[kind] as Array;
		if (!anys || anys.length == 0) {
			return receivers;
		}
		else {
			return (receivers.length > 0) ? receivers.concat(anys) : anys;
		}
	}
	
	/**
	 * Adds a receiver to this collection.
	 * 
	 * @param kind the kind of the receiver
	 * @param receiver the receiver to add
	 */
	public function addReceiver (kind:MessageReceiverKind, receiver:MessageReceiver) : void {
		var map:Dictionary = getReceiverMap(receiver);
		var array:Array = map[kind] as Array;
		if (array == null) {
			array = new Array();
			map[kind] = array;
		}
		array.push(receiver);
		dispatchEvent(new Event(Event.CHANGE));
	}

	/**
	 * Removes a receiver from this collection.
	 * 
	 * @param kind the kind of the receiver
	 * @param receiver the receiver to remove
	 */
	public function removeReceiver (kind:MessageReceiverKind, receiver:MessageReceiver) : void {
		var map:Dictionary = getReceiverMap(receiver);
		var array:Array = map[kind] as Array;
		if (array == null) {
			return;
		}
		ArrayUtil.remove(array, receiver);
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	private function getReceiverMap (receiver:MessageReceiver) : Dictionary {
		return (receiver.selector == undefined) ? anySelector : ((receiver.selector is Class) ? byType : byValue);
	}
	
	
}
}
