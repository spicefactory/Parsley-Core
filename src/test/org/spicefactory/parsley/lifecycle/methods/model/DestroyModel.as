package org.spicefactory.parsley.lifecycle.methods.model {

/**
 * @author Jens Halm
 */
public class DestroyModel {
	
	
	private var _methodCalled:Boolean = false;
	
	
	public function dispose () : void {
		_methodCalled = true;
	}
	
	public function get methodCalled () : Boolean {
		return _methodCalled;
	}
	
	
}
}
