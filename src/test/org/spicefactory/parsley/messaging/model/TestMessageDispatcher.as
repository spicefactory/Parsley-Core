package org.spicefactory.parsley.messaging.model {

/**
 * @author Jens Halm
 */
public class TestMessageDispatcher {
	
	
	private var _dispatcher:Function;
	
	
	public function set dispatcher (disp:Function) : void {
		_dispatcher = disp;
	}
	
	
	public function dispatchMessage (message:Object, selector:* = null) : void {
		_dispatcher(message, selector);
	}
	
	
}
}
