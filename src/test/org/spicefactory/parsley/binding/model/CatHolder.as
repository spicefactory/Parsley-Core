package org.spicefactory.parsley.binding.model {


/**
 * @author Jens Halm
 */
public class CatHolder {
	
	private var _value:Cat;
	
	[Bindable]
	public function get value () : Cat {
		return _value;
	}
	
	public function set value (value:Cat) : void {
		_value = value;
	}
	
}
}
