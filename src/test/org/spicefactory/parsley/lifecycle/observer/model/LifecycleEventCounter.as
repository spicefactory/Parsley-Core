package org.spicefactory.parsley.lifecycle.observer.model {
import org.spicefactory.parsley.util.MessageCounter;

import mx.containers.Box;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Text;

/**
 * @author Jens Halm
 */
public class LifecycleEventCounter extends MessageCounter {
	
	public function globalListener (instance:Box) : void {
		addMessage(instance, "global");
	}
	public function globalVListener (instance:VBox) : void {
		addMessage(instance, "global");
	}
	public function globalHListener (instance:HBox) : void {
		addMessage(instance, "global");
	}
	public function localListener (instance:Box) : void {
		addMessage(instance, "local");
	}
	public function localVListener (instance:VBox) : void {
		addMessage(instance, "local");
	}
	public function localHListener (instance:HBox) : void {
		addMessage(instance, "local");
	}
	public function customListener (instance:Box) : void {
		addMessage(instance, "custom");
	}
	public function customVListener (instance:VBox) : void {
		addMessage(instance, "custom");
	}
	public function customHListener (instance:HBox) : void {
		addMessage(instance, "custom");
	}
	
	
	public function globalIdListener (instance:Text) : void {
		addMessage(instance, "globalId");
	}
	public function globalDestroyListener (instance:Text) : void {
		addMessage(instance, "globalDestroy");
	}
	
}
}
