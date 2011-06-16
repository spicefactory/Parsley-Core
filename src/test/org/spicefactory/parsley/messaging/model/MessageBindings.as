package org.spicefactory.parsley.messaging.model {

/**
 * @author Jens Halm
 */
public class MessageBindings {

	
	private var _stringProp:String = "";
	
	
	public function get stringProp ():String {
		return _stringProp;
	}
	
	public function set stringProp (value:String) : void {
		_stringProp += value;
	}
	
	
}
}
