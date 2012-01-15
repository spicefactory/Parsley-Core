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

import org.spicefactory.lib.util.ArrayUtil;
import flash.events.Event;
import flash.utils.Dictionary;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.MessageReceiverCache;
import org.spicefactory.parsley.core.messaging.MessageReceiverKind;


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
		var collection:MessageReceiverCollection = event.target as MessageReceiverCollection;
		if (collection.empty) {
			collection.removeEventListener(Event.CHANGE, collectionChanged);
			ArrayUtil.remove(collections, collection);
		}
	}
	
	/**
	 * @inheritDoc
	 */	
	public function getReceivers (kind:MessageReceiverKind, selector:* = undefined) : Array {
		if (selectorMaps == null) {
			log.info("ApplicationDomain for type " + _messageType.name 
					+ " is no longer used, using empty list of message receivers");
			return [];
		}
		return getSelectorMap(kind).getReceivers(selector, _messageType.applicationDomain);
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
		selectorMaps = new Dictionary();
		for each (var collection:MessageReceiverCollection in collections) {
			collection.removeEventListener(Event.CHANGE, collectionChanged);
		}
		collections = new Array();
	}


}
}

import flash.system.ApplicationDomain;
import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.getQualifiedClassName;
import org.spicefactory.parsley.core.messaging.MessageReceiverKind;
import org.spicefactory.parsley.core.messaging.impl.MessageReceiverCollection;


class SelectorMap {
	
	private var kind:MessageReceiverKind;
	private var collections:Array;
	private var byValue:Dictionary = new Dictionary();
	private var byType:Dictionary = new Dictionary();
	
	function SelectorMap (collections:Array, kind:MessageReceiverKind) {
		this.collections = collections;
		this.kind = kind;
	}

	public function getReceivers (selector:*, domain:ApplicationDomain) : Array {
		if (selector == undefined
				|| selector is String 
				|| selector is Number 
				|| selector is Class
				) {
			return getReceiversBySelectorValue(selector);
		}
		else {
			return getReceiversBySelectorType(selector, domain);
		}
	}

	private function getReceiversBySelectorValue (selector:*) : Array {
		if (byValue[selector] != undefined) {
			return byValue[selector];		
		}
		var receivers:Array = new Array();
		for each (var collection:MessageReceiverCollection in collections) {
			var subset:Array = collection.getReceiversBySelectorValue(kind, selector);
			if (subset.length > 0) {
				receivers = (receivers.length > 0) ? receivers.concat(subset) : subset;
			}
		}
		byValue[selector] = receivers;
		return receivers;
	}
	
	private function getReceiversBySelectorType (selector:*, domain:ApplicationDomain) : Array {
		var type:Class = getSelectorType(selector, domain);
		if (byType[type] != undefined) {
			return byType[type];		
		}
		var receivers:Array = new Array();
		for each (var collection:MessageReceiverCollection in collections) {
			var subset:Array = collection.getReceiversBySelectorType(kind, selector);
			if (subset.length > 0) {
				receivers = (receivers.length > 0) ? receivers.concat(subset) : subset;
			}
		}
		byType[type] = receivers;
		return receivers;
	}
	
	private function getSelectorType (selector:*, domain:ApplicationDomain) : Class {
		var C:Class;
		if (!(selector is Proxy && selector is Number)) {
			// Cannot rely on Proxy subclasses to support the constructor property
			// For Number instance constructor property always returns Number (never int)
			C = selector.constructor as Class;
		}
		if (C == null) {
			C = domain.getDefinition(getQualifiedClassName(selector)) as Class;
		}
		return C;
	}
	
	
}

