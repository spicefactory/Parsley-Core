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

package org.spicefactory.parsley.core.messaging.impl {
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.Message;
import org.spicefactory.parsley.core.messaging.MessageReceiverCache;

import flash.events.Event;
import flash.utils.Dictionary;

/**
 * A cached selection of receivers for a particular message type and its subtypes.
 * Will be used by the default MessageRouter implementation as a performance optimization.
 * 
 * @author Jens Halm
 */
public class DefaultMessageReceiverCache implements MessageReceiverCache {
	
	
	private static const log:Logger = LogContext.getLogger(DefaultMessageReceiverCache);
	
	
	private var _messageType:ClassInfo;
	private var collections:Array;
	private var selectorProperty:Property;
	private var selectorMaps:Dictionary = new Dictionary();
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param type the type of the message
	 * @param collections the collections of receivers applicable for this message type and its subtypes
	 */
	function DefaultMessageReceiverCache (type:ClassInfo, collections:Array) {
		_messageType = type;
		this.collections = collections;
		for each (var collection:MessageReceiverCollection in collections) {
			addListener(collection);
		}
		setSelectorProperty();
	}
	
	private function setSelectorProperty () : void {
		for each (var p:Property in _messageType.getProperties()) {
			if (p.getMetadata(Selector).length > 0) {
				if (selectorProperty == null) {
					selectorProperty = p;
				}
				else {
					throw new ContextError("Class " + _messageType.name 
							+ " contains more than one Selector metadata tag");
				}
			}
		}
		if (selectorProperty == null && _messageType.isType(Event)) {
			selectorProperty = _messageType.getProperty("type");
		}
	}
	
	/**
	 * @inheritDoc
	 */	
	public function getSelectorValue (message:Object) : * {
		if (selectorProperty != null) {
			return selectorProperty.getValue(message);
		}
		else {
			return message.toString();
		}
	}
	
	/**
	 * Checks whether the specified new collection matches the message type of this cache and adds
	 * it in that case.
	 * 
	 * @param collection the new collection to check
	 */
	public function checkNewCollection (collection:MessageReceiverCollection) : void {
		if (_messageType.isType(collection.messageType)) {
			collections.push(collection);
			selectorMaps = new Dictionary();
			addListener(collection);
		}
	}
	
	private function addListener (collection:MessageReceiverCollection) : void {
		collection.addEventListener(Event.CHANGE, collectionChanged);
	}
	
	private function collectionChanged (event:Event) : void {
		selectorMaps = new Dictionary();
	}
	
	/**
	 * @inheritDoc
	 */	
	public function getReceivers (message:Message, kind:MessageReceiverKind) : Array {
		if (selectorMaps == null) {
			log.info("ApplicationDomain for type " + _messageType.name 
					+ " is no longer used, using empty list of message receivers");
			return [];
		}
		return getSelectorMap(kind).getReceivers(message);
	}
	
	private function getSelectorMap (kind:MessageReceiverKind) : SelectorMap {
		var map:SelectorMap = selectorMaps[kind] as SelectorMap;
		if (!map) {
			map = new SelectorMap(collections, kind);
			selectorMaps[kind] = map;
		}
		return map;
	}
	
	/**
	 * Releases this selection cache in case it is no longer used.
	 * Usually only called by the framework when there is no Context left that uses the
	 * ApplicationDomain the message type of this cache belongs to.
	 */
	public function release () : void {
		selectorMaps = null;
		for each (var collection:MessageReceiverCollection in collections) {
			collection.removeEventListener(Event.CHANGE, collectionChanged);
		}
	}


}
}

import flash.utils.getQualifiedClassName;

import org.spicefactory.parsley.core.messaging.Message;
import org.spicefactory.parsley.core.messaging.impl.MessageReceiverCollection;
import org.spicefactory.parsley.core.messaging.impl.MessageReceiverKind;

import flash.utils.Dictionary;
import flash.utils.Proxy;

class SelectorMap {
	
	private var kind:MessageReceiverKind;
	private var collections:Array;
	private var byValue:Dictionary = new Dictionary();
	private var byType:Dictionary = new Dictionary();
	
	function SelectorMap (collections:Array, kind:MessageReceiverKind) {
		this.collections = collections;
		this.kind = kind;
	}

	public function getReceivers (message:Message) : Array {
		var selector:* = message.selector;
		if (selector == undefined
				|| selector is String 
				|| selector is Number 
				|| selector is Class
				) {
			return getReceiversBySelectorValue(message);
		}
		else {
			return getReceiversBySelectorType(message);
		}
	}

	private function getReceiversBySelectorValue (message:Message) : Array {
		if (byValue[message.selector] != undefined) {
			return byValue[message.selector];		
		}
		var receivers:Array = new Array();
		for each (var collection:MessageReceiverCollection in collections) {
			var subset:Array = collection.getReceiversBySelectorValue(kind, message.selector);
			if (subset.length > 0) {
				receivers = (receivers.length > 0) ? receivers.concat(subset) : subset;
			}
		}
		byValue[message.selector] = receivers;
		return receivers;
	}
	
	private function getReceiversBySelectorType (message:Message) : Array {
		var type:Class = getSelectorType(message);
		if (byType[type] != undefined) {
			return byType[type];		
		}
		var receivers:Array = new Array();
		for each (var collection:MessageReceiverCollection in collections) {
			var subset:Array = collection.getReceiversBySelectorType(kind, message.selector);
			if (subset.length > 0) {
				receivers = (receivers.length > 0) ? receivers.concat(subset) : subset;
			}
		}
		byType[type] = receivers;
		return receivers;
	}
	
	private function getSelectorType (message:Message) : Class {
		var C:Class;
		if (!(message.selector is Proxy && message.selector is Number)) {
			// Cannot rely on Proxy subclasses to support the constructor property
			// For Number instance constructor property always returns Number (never int)
			C = message.selector.constructor as Class;
		}
		if (C == null) {
			C = message.type.applicationDomain.getDefinition(getQualifiedClassName(message.selector)) as Class;
		}
		return C;
	}
	
	
}

