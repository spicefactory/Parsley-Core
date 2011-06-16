package org.spicefactory.parsley.binding.model {

/**
 * @author Jens Halm
 */
public class AnimalHolder {
	
	private var _value:Animal;
	
	[Bindable]
	public function get value () : Animal {
		return _value;
	}
	
	public function set value (value:Animal) : void {
		_value = value;
	}
	
}
}
