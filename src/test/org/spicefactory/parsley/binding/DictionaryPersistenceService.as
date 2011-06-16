package org.spicefactory.parsley.binding {
import flash.utils.Dictionary;
import flash.events.EventDispatcher;
import flash.utils.getQualifiedClassName;

/**
 * @author Jens Halm
 */
public class DictionaryPersistenceService extends EventDispatcher implements PersistenceManager {
	
	private static var data:Dictionary = new Dictionary();
	public static var changeCount:int;
	
	public function saveValue (scopeId:String, baseType:Class, id:String, value:Object) : void {
		var uuid:String = getUuid(scopeId, baseType, id);
		if (data[uuid] !== value) {
			changeCount++;
			data[uuid] = value;
		}
	}
	
	public function deleteValue (scopeId:String, baseType:Class, id:String) : void {
		changeCount++;
		delete data[getUuid(scopeId, baseType, id)];
	}
	
	public function getValue (scopeId:String, baseType:Class, id:String) : Object {
		return data[getUuid(scopeId, baseType, id)];
	}
	
	private static function getUuid (scopeId:String, baseType:Class, id:String) : String {
		return scopeId + "_" + getQualifiedClassName(baseType) + "_" + id;
 	}
 	
 	
 	public static function getStoredValue (scopeId:String, baseType:Class, id:String) : Object {
		return data[getUuid(scopeId, baseType, id)];
	}
	
	public static function hasStoredValue (scopeId:String, baseType:Class, id:String) : Object {
		return (data[getUuid(scopeId, baseType, id)] != undefined);
	}
	
	public static function putStoredValue (scopeId:String, baseType:Class, id:String, value:Object) : void {
		data[getUuid(scopeId, baseType, id)] = value;
	}
	
	public static function reset () : void {
		data = new Dictionary();
		changeCount = 0;
	}
	
	
}
}
