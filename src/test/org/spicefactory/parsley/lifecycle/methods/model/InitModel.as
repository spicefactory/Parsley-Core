package org.spicefactory.parsley.lifecycle.methods.model {

/**
 * @author Jens Halm
 */
public class InitModel {
	
	
	private var _methodCalled:Boolean = false;
	
	
	public function init () : void {
		_methodCalled = true;
	}
	
	
	public function get methodCalled () : Boolean {
		return _methodCalled;
	}
	
	
}
}
