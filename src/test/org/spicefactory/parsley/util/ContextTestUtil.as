package org.spicefactory.parsley.util {

import org.flexunit.assertThat;
import org.hamcrest.core.isA;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.dsl.context.ContextBuilder;
import org.spicefactory.parsley.dsl.context.ContextBuilderSetup;

/**
 * @author Jens Halm
 */
public class ContextTestUtil {
	
	
	public static function newContext (processor:ConfigurationProcessor, parent:Context = null, 
			customScope:String = null, inherited:Boolean = true) : Context {
		var setup:ContextBuilderSetup = ContextBuilder.newSetup().parent(parent);
		if (customScope) {
			setup.scope(customScope, inherited);
		}
		return setup.newBuilder().config(processor).build();
	}
	
	
	public static function getAndCheckObject (context:Context, id:String, expectedType:Class) : Object {
		var obj1:Object = context.getObject(id);
		assertThat(obj1, isA(expectedType));
		return obj1;
	}
	
	
}
}
