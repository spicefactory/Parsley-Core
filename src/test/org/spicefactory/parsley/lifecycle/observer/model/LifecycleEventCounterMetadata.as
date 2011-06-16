package org.spicefactory.parsley.lifecycle.observer.model {
import mx.containers.Box;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Text;

/**
 * @author Jens Halm
 */
public class LifecycleEventCounterMetadata extends LifecycleEventCounter {
	
	[Observe]
	public override function globalListener (instance:Box) : void {
		super.globalListener(instance);
	}
	[Observe]
	public override function globalVListener (instance:VBox) : void {
		super.globalVListener(instance);
	}
	[Observe]
	public override function globalHListener (instance:HBox) : void {
		super.globalHListener(instance);
	}
	[Observe(scope="local")]
	public override function localListener (instance:Box) : void {
		super.localListener(instance);
	}
	[Observe(scope="local")]
	public override function localVListener (instance:VBox) : void {
		super.localVListener(instance);
	}
	[Observe(scope="local")]
	public override function localHListener (instance:HBox) : void {
		super.localHListener(instance);
	}
	[Observe(scope="custom")]
	public override function customListener (instance:Box) : void {
		super.customListener(instance);
	}
	[Observe(scope="custom")]
	public override function customVListener (instance:VBox) : void {
		super.customVListener(instance);
	}
	[Observe(scope="custom")]
	public override function customHListener (instance:HBox) : void {
		super.customHListener(instance);
	}
	
	
	[Observe(objectId="text")]
	public override function globalIdListener (instance:Text) : void {
		super.globalIdListener(instance);
	}
	[Observe(phase="postDestroy")]
	public override function globalDestroyListener (instance:Text) : void {
		super.globalDestroyListener(instance);
	}
	
}
}
