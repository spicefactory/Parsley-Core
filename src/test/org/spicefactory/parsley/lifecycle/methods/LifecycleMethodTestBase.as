package org.spicefactory.parsley.lifecycle.methods {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.lifecycle.methods.model.DestroyModel;
import org.spicefactory.parsley.lifecycle.methods.model.InitModel;
import org.spicefactory.parsley.util.contextInState;

/**
 * @author Jens Halm
 */
public class LifecycleMethodTestBase {

	
	[Test]
	public function initMethod () : void {
		var context:Context = lifecycleContext;
		assertThat(context, contextInState());
		var obj:InitModel = context.getObject("initModel") as InitModel; 
		assertThat(obj.methodCalled, equalTo(true));
	}
	
	[Test]
	public function destroyMethod () : void {
		var context:Context = lifecycleContext;
		assertThat(context, contextInState());
		var obj:DestroyModel = context.getObject("destroyModel") as DestroyModel; 
		context.destroy();
		assertThat(obj.methodCalled, equalTo(true));
	}
	
	public function get lifecycleContext () : Context {
		throw new AbstractMethodError();
	}
	
	
}
}
