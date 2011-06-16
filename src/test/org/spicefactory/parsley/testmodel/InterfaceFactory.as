package org.spicefactory.parsley.testmodel {
import flash.display.Sprite;
import flash.events.IEventDispatcher;

/**
 * @author Jens Halm
 */
public class InterfaceFactory {
	
	[Factory]
	public function createInstance () : IEventDispatcher {
		return new Sprite();
	}
	
}
}
