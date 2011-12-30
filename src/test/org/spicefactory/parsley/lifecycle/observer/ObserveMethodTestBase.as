package org.spicefactory.parsley.lifecycle.observer {
import mx.containers.Box;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Text;
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.context.ContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.lifecycle.observer.model.LifecycleEventCounter;


/**
 * @author Jens Halm
 */
public class ObserveMethodTestBase {

	
	[Test]
	public function testObserveTags () : void {
		var context:Context = observeContext;
		var counter:LifecycleEventCounter = context.getObjectByType(LifecycleEventCounter) as LifecycleEventCounter;
		context.getAllObjectsByType(Box); // just trigger instantiation of lazy objects
		context.getAllObjectsByType(Text); // just trigger instantiation of lazy objects
		
		assertThat(counter.getCount(), equalTo(33));
		assertThat(counter.getCount(Text), equalTo(3));
		assertThat(counter.getCount(Box), equalTo(6));
		assertThat(counter.getCount(HBox), equalTo(12));
		assertThat(counter.getCount(VBox), equalTo(12));
		assertThat(counter.getCount(HBox, "local"), equalTo(2));
		assertThat(counter.getCount(HBox, "custom"), equalTo(4));
		assertThat(counter.getCount(HBox, "global"), equalTo(6));
		assertThat(counter.getCount(Box, "local"), equalTo(1));
		assertThat(counter.getCount(Box, "custom"), equalTo(2));
		assertThat(counter.getCount(Box, "global"), equalTo(3));

		assertThat(counter.getCount(Text, "globalDestroy"), equalTo(0));
  		var builder:ContextBuilder = ContextBuilder.newSetup().parent(context).newBuilder();
  		builder.objectDefinition().forClass(Text).asDynamicObject().id("dynamic").register();
  		var child:Context = builder.build();
  		var dynObject:DynamicObject = child.createDynamicObject("dynamic");
  		dynObject.remove();
		assertThat(counter.getCount(Text, "globalDestroy"), equalTo(1));
	}

	
	public function get observeContext () : Context {
		throw new AbstractMethodError();
	}
	
	
}
}
