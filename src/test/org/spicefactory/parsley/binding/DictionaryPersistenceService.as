package org.spicefactory.parsley.binding {

import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import org.spicefactory.parsley.core.binding.PersistenceManager;
import org.spicefactory.parsley.core.scope.InitializingExtension;
import org.spicefactory.parsley.core.scope.Scope;


/**
 * @author Jens Halm
 */
public class DictionaryPersistenceService extends EventDispatcher implements PersistenceManager, InitializingExtension {
	
	private static var data:Dictionary = new Dictionary();
	public static var changeCount:int;
	
	private var scopeUuid:String;
	
	public function init (scope: Scope): void {
		this.scopeUuid = scope.uuid;
	}
	
	public function saveValue (key:Object, value:Object) : void {
		var uuid:String = getUuid(key);
		if (data[uuid] !== value) {
			changeCount++;
			data[uuid] = value;
		}
	}
	
	public function deleteValue (key:Object) : void {
		changeCount++;
		delete data[getUuid(key)];
	}
	
	public function getValue (key:Object) : Object {
		return data[getUuid(key)];
	}
	
	private function getUuid (key:Object) : String {
		return scopeUuid + "_" + key;
 	}
 	
 	
 	public static function getStoredValue (scopeUuid:String, key:Object) : Object {
		return data[scopeUuid + "_" + key];
	}
	
	public static function hasStoredValue (scopeUuid:String, key:Object) : Object {
		return (data[scopeUuid + "_" + key] != undefined);
	}
	
	public static function putStoredValue (scopeUuid:String, key:Object, value:Object) : void {
		data[scopeUuid + "_" + key] = value;
	}
	
	public static function reset () : void {
		data = new Dictionary();
		changeCount = 0;
	}

	
}
}
