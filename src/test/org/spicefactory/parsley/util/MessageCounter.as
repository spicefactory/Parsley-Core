package org.spicefactory.parsley.util {
import org.spicefactory.lib.reflect.ClassInfo;

import flash.utils.Dictionary;

/**
 * @author Jens Halm
 */
public class MessageCounter {
	
	
	private var messages:Dictionary = new Dictionary();
	private var allMessages:Array = new Array();
	
	
	public function addMessage (message:Object, selector:* = undefined) : void {
		var type:Class = ClassInfo.forInstance(message).getClass();
		allMessages.push(message);
		var byType:MessagesByType = messages[type];
		if (byType == null) {
			byType = new MessagesByType();
			messages[type] = byType;
		}
		byType.addMessage(message, selector);
	}
	
	
	public function getCount (type:Class = null, selector:* = undefined) : int {
		if (type == null) {
			return allMessages.length;
		}
		else if (messages[type] == undefined) {
			return 0;
		}
		else {
			var byType:MessagesByType = messages[type];
			return byType.getCount(selector);
		}
	}
	
}
}

import flash.utils.Dictionary;

class MessagesByType {
	
	private var messages:Dictionary = new Dictionary();
	private var allMessages:Array = new Array();	
	
	public function addMessage (message:Object, selector:* = undefined) : void {
		allMessages.push(message);
		if (selector != undefined) {
			var bySelector:Array = messages[selector];
			if (bySelector == null) {
				bySelector = new Array();
				messages[selector] = bySelector;
			}
			bySelector.push(message);
		}
	}
	
	public function getCount (selector:* = undefined) : int {
		if (selector == undefined) {
			return allMessages.length;
		}
		else if (messages[selector] == undefined) {
			return 0;
		}
		else {
			var byType:Array = messages[selector];
			return byType.length;
		}
	}
	
}
