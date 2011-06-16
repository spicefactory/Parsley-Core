package org.spicefactory.parsley.messaging.messages {
import flash.events.Event;

/**
 * @author Jens Halm
 */
public class TestEvent extends Event {
	
	
	public static const TEST1:String = "test1";
	public static const TEST2:String = "test2";
	
	
	private var _stringProp:String;
	private var _intProp:int;
	
	
	function TestEvent (type:String, stringProp:String, intProp:int) {
		super(type);
		this._stringProp = stringProp;
		this._intProp = intProp;
	}
	
	
	public function get stringProp () : String {
		return _stringProp;
	}
	
	public function get intProp () : int {
		return _intProp;
	}
	
	
	public override function toString () : String {
		return "[TestEvent(" + type + ")]";
	}
	
	
}
}
