package org.spicefactory.parsley.context.dynobjects {
import org.spicefactory.lib.reflect.ClassInfo;
import org.hamcrest.object.notNullValue;
import org.hamcrest.object.equalTo;
import org.hamcrest.assertThat;
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.context.dynobjects.model.AnnotatedDynamicTestObject;
import org.spicefactory.parsley.context.dynobjects.model.SimpleDynamicTestObject;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.util.contextInState;

/**
 * @author Jens Halm
 */
public class DynamicObjectTagTestBase {

	
	private var context:Context;
	
	[Before]
	public function setUp () : void {
		ClassInfo.cache.purgeAll();
		context = dynamicContext;
		assertThat(context, contextInState());
	}
	
	[Test]
	public function createObjectById () : void {
		var dynObject:DynamicObject = context.createDynamicObject("testObject");
		validateDynamicObject(dynObject, context);
	}
	
	[Test]
	public function createObjectByType () : void {
		var dynObject:DynamicObject = context.createDynamicObjectByType(AnnotatedDynamicTestObject);
		validateDynamicObject(dynObject, context);		
	}	
	
	[Test]
	public function addDefinition () : void {
		var definition:DynamicObjectDefinition = context.findDefinition("testObject") as DynamicObjectDefinition;
		var dynObject:DynamicObject = context.addDynamicDefinition(definition);
		validateDynamicObject(dynObject, context);
	}
	
	[Test]
	public function nestedDefinitionLifecycle () : void {
		var dynObject:DynamicObject = context.createDynamicObject("testObject");
		var instance:AnnotatedDynamicTestObject = dynObject.instance as AnnotatedDynamicTestObject;
		assertThat(instance.dependency.destroyMethodCalled, equalTo(false));
		validateDynamicObject(dynObject, context);
		assertThat(instance.dependency.destroyMethodCalled, equalTo(true));
	}
	
	[Test]
	public function synchronizedRootDynamicObjectLifecycle () : void {
		var dynObject:DynamicObject = context.createDynamicObject("testObjectWithRootRef");
		var instance:SimpleDynamicTestObject = dynObject.instance as SimpleDynamicTestObject;
		assertThat(instance.dependency.destroyMethodCalled, equalTo(false));
		dynObject.remove();
		assertThat(instance.dependency.destroyMethodCalled, equalTo(true));
	}

	private function validateDynamicObject (dynObject:DynamicObject, context:Context) : void {
		assertThat(dynObject.instance.dependency, notNullValue());
		context.scopeManager.dispatchMessage(new Object());
		dynObject.remove();
		context.scopeManager.dispatchMessage(new Object());
		assertThat(dynObject.instance.getMessageCount(), equalTo(1));		
	}
	
	public function get dynamicContext () : Context {
		throw new AbstractMethodError();
	}


	
}
}
