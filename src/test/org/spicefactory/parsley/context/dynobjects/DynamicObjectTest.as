package org.spicefactory.parsley.context.dynobjects {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.notNullValue;
import org.hamcrest.object.nullValue;
import org.hamcrest.object.sameInstance;
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.context.dynobjects.model.AnnotatedDynamicTestObject;
import org.spicefactory.parsley.context.dynobjects.model.DynamicTestDependency;
import org.spicefactory.parsley.context.dynobjects.model.DynamicTestObject;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.context.impl.DefaultContext;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.state.GlobalState;
import org.spicefactory.parsley.inject.Inject;
import org.spicefactory.parsley.inject.model.NestedObject;
import org.spicefactory.parsley.messaging.MessageHandler;
import org.spicefactory.parsley.runtime.RuntimeContextBuilder;
import org.spicefactory.parsley.util.contextInState;

/**
 * @author Jens Halm
 */
public class DynamicObjectTest {

	
	[Test]
	public function addObject () : void {
		var context:Context = ActionScriptContextBuilder.build(DynamicConfig);
		assertThat(context, contextInState());
		var obj:AnnotatedDynamicTestObject = new AnnotatedDynamicTestObject();
		var dynObject:DynamicObject = context.addDynamicObject(obj);
		validateDynamicObject(dynObject, context);
	}
	
	[Test]
	public function addObjectAndDefinition () : void {
		var context:Context = ActionScriptContextBuilder.build(DynamicConfig);
		assertThat(context, contextInState());
		var obj:DynamicTestObject = new DynamicTestObject();
		var definition:DynamicObjectDefinition = createDefinition(context);
		var dynObject:DynamicObject = context.addDynamicObject(obj, definition);
		validateDynamicObject(dynObject, context);		
	}	
	
	[Test]
	public function addDefinition () : void {
		var context:Context = ActionScriptContextBuilder.build(DynamicConfig);
		assertThat(context, contextInState());
		var definition:DynamicObjectDefinition = createDefinition(context);
		var dynObject:DynamicObject = context.addDynamicDefinition(definition);
		validateDynamicObject(dynObject, context);
	}
	
	[Test]
	public function nestedDefinitionLifecycle () : void {
		var context:Context = RuntimeContextBuilder.build([]);
		assertThat(context, contextInState());
		var definition:DynamicObjectDefinition = createDefinition(context, false);
		var dynObject:DynamicObject = context.addDynamicDefinition(definition);
		var instance:DynamicTestObject = dynObject.instance as DynamicTestObject;
		assertThat(instance.dependency.destroyMethodCalled, equalTo(false));
		validateDynamicObject(dynObject, context);
		assertThat(instance.dependency.destroyMethodCalled, equalTo(true));
	}
	
	[Test]
	public function contextUtil () : void {
		var context:Context = ActionScriptContextBuilder.build(DynamicConfig);
		assertThat(context, contextInState());
		var obj:AnnotatedDynamicTestObject = new AnnotatedDynamicTestObject();
		assertThat(GlobalState.objects.isManaged(obj), equalTo(false));
		assertThat(GlobalState.objects.getContext(obj), nullValue());
		var dynObject:DynamicObject = context.addDynamicObject(obj);
		assertThat(GlobalState.objects.isManaged(obj), equalTo(true));
		assertThat(GlobalState.objects.getContext(obj), sameInstance(context));
		dynObject.remove();
		assertThat(GlobalState.objects.isManaged(obj), equalTo(false));
		assertThat(GlobalState.objects.getContext(obj), nullValue());
	}

	private function validateDynamicObject (dynObject:DynamicObject, context:Context) : void {
		assertThat(dynObject.instance.dependency, notNullValue());
		context.scopeManager.dispatchMessage(new Object());
		dynObject.remove();
		context.scopeManager.dispatchMessage(new Object());
		assertThat(dynObject.instance.getMessageCount(), equalTo(1));
	}
	
	private function createDefinition (context:Context, dependencyAsRef:Boolean = true) : DynamicObjectDefinition {
		var registry:ObjectDefinitionRegistry = DefaultContext(context).registry;
		var builder:ObjectDefinitionBuilder 
				= registry.builders.forClass(DynamicTestObject);
		MessageHandler.forMethod("handleMessage").apply(builder);
		if (dependencyAsRef) {
			builder.property("dependency").value(Inject.byType());
		}
		else {
			var childDef:DynamicObjectDefinition = registry.builders
					.forClass(DynamicTestDependency).asDynamicObject().build();
			builder.property("dependency").value(new NestedObject(childDef));
		}
		return builder.asDynamicObject().build();
	}

	
}
}
