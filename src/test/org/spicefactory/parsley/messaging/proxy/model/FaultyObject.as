package org.spicefactory.parsley.messaging.proxy.model {

/**
 * @author Jens Halm
 */
public class FaultyObject {
	
	
	[Init]
	public function init () : void {
		throw new Error("This init method is broken on purpose");
	}
	
	
}
}
