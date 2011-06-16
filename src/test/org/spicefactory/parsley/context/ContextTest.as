package org.spicefactory.parsley.context {
import org.flexunit.assertThat;
import org.hamcrest.collection.arrayWithSize;
import org.hamcrest.object.equalTo;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.runtime.RuntimeContextBuilder;
import org.spicefactory.parsley.testmodel.InterfaceFactory;

import flash.events.IEventDispatcher;

/**
 * @author Jens Halm
 */
public class ContextTest {
	
	
	[Test]
	public function getAllObjectsByTypeWithInterface () : void {
		var context:Context = RuntimeContextBuilder.build([new InterfaceFactory(), new Object(), new Date()]);
		assertThat(context.getAllObjectsByType(IEventDispatcher), arrayWithSize(1));
		assertThat(context.getAllObjectsByType(Object), arrayWithSize(4));
	}
	
	[Test]
	public function findAllDefinitionsByInterfaceType () : void {
		var context:Context = RuntimeContextBuilder.build([new InterfaceFactory(), new Object(), new Date()]);
		assertThat(context.findAllDefinitionsByType(IEventDispatcher), arrayWithSize(1));
		assertThat(context.findAllDefinitionsByType(Object), arrayWithSize(4));
	}
	
	[Test]
	public function getObjectCountForInterface () : void {
		var context:Context = RuntimeContextBuilder.build([new InterfaceFactory(), new Object(), new Date()]);
		assertThat(context.getObjectCount(IEventDispatcher), equalTo(1));
		assertThat(context.getObjectCount(Object), equalTo(4));
	}
	
	
}
}
