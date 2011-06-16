package org.spicefactory.parsley.context.inheritance.model {

/**
 * @author Jens Halm
 */
public class StringHolder {
	
	function StringHolder (value:String) {
		_value = value;
	}
	
	private var _value:String;
	
	public function get value () : String {
		return _value;
	}
	
}
}
