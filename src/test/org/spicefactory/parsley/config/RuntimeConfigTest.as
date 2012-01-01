package org.spicefactory.parsley.config {
import org.hamcrest.assertThat;
import org.hamcrest.core.isA;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.sameInstance;
import org.spicefactory.parsley.context.ContextBuilder;
import org.spicefactory.parsley.context.dynobjects.model.AnnotatedDynamicTestObject;
import org.spicefactory.parsley.context.dynobjects.model.DynamicTestDependency;
import org.spicefactory.parsley.core.bootstrap.BootstrapManager;
import org.spicefactory.parsley.core.bootstrap.impl.DefaultBootstrapManager;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.runtime.RuntimeContextBuilder;
import org.spicefactory.parsley.runtime.processor.RuntimeConfigurationProcessor;
import org.spicefactory.parsley.testmodel.ClassWithSimpleProperties;
import org.spicefactory.parsley.testmodel.SimpleClass;
import org.spicefactory.parsley.util.contextInState;

/**
 * @author Jens Halm
 */
public class RuntimeConfigTest {
	
	
	[Test]
	public function twoObjectsWithoutIds () : void {
		var dep:DynamicTestDependency = new DynamicTestDependency();
		var obj:AnnotatedDynamicTestObject = new AnnotatedDynamicTestObject();
		var context:Context = RuntimeContextBuilder.build([dep, obj]);
		assertThat(context, contextInState());
		assertThat(context.getObjectCount(), equalTo(2));		
		assertThat(context.getObjectCount(DynamicTestDependency), equalTo(1));		
		assertThat(context.getObjectCount(AnnotatedDynamicTestObject), equalTo(1));		
		var obj2:AnnotatedDynamicTestObject = AnnotatedDynamicTestObject(context.getObjectByType(AnnotatedDynamicTestObject));
		assertThat(obj2, sameInstance(obj));		
		assertThat(obj2.dependency, sameInstance(dep));		
	}
	
	[Test]
	public function twoObjectsWithoutIdsDsl () : void {
		var dep:DynamicTestDependency = new DynamicTestDependency();
		var obj:AnnotatedDynamicTestObject = new AnnotatedDynamicTestObject();
		var context:Context = ContextBuilder.newBuilder().object(dep).object(obj).build();
		assertThat(context, contextInState());
		assertThat(context.getObjectCount(), equalTo(2));		
		assertThat(context.getObjectCount(DynamicTestDependency), equalTo(1));		
		assertThat(context.getObjectCount(AnnotatedDynamicTestObject), equalTo(1));		
		var obj2:AnnotatedDynamicTestObject = AnnotatedDynamicTestObject(context.getObjectByType(AnnotatedDynamicTestObject));
		assertThat(obj2, sameInstance(obj));		
		assertThat(obj2.dependency, sameInstance(dep));	
	}
	
	[Test]
	public function objectWithId () : void {
		var obj:ClassWithSimpleProperties = new ClassWithSimpleProperties();
		var manager:BootstrapManager = new DefaultBootstrapManager();
		var processor:RuntimeConfigurationProcessor = new RuntimeConfigurationProcessor();
		processor.addInstance(obj, "THE ID");
		manager.config.addProcessor(processor);
		var context:Context = manager.createProcessor().process();
		assertThat(context, contextInState());
		assertThat(context.getObjectCount(), equalTo(1));		
		assertThat(context.getObjectCount(Object), equalTo(1));		
		assertThat(context.getObjectCount(ClassWithSimpleProperties), equalTo(1));		
		assertThat(context.containsObject("THE ID"), equalTo(true));		
		assertThat(context.getObject("THE ID"), isA(ClassWithSimpleProperties));		
	}
	
	[Test]
	public function objectWithIdDsl () : void {
		var obj:ClassWithSimpleProperties = new ClassWithSimpleProperties();
		var context:Context = ContextBuilder.newBuilder().object(obj, "THE ID").build();
		assertThat(context, contextInState());
		assertThat(context.getObjectCount(), equalTo(1));		
		assertThat(context.getObjectCount(Object), equalTo(1));		
		assertThat(context.getObjectCount(ClassWithSimpleProperties), equalTo(1));		
		assertThat(context.containsObject("THE ID"), equalTo(true));		
		assertThat(context.getObject("THE ID"), isA(ClassWithSimpleProperties));	
	}
	
	[Test]
	public function lazyClass () : void {
		SimpleClass.instanceCounter = 0;
		var processor:RuntimeConfigurationProcessor = new RuntimeConfigurationProcessor();
		processor.addClass(SimpleClass, null, true, true);
		var context:Context = ContextBuilder.newBuilder().config(processor).build();
		assertThat(context, contextInState());
		assertThat(context.getObjectCount(), equalTo(1));		
		assertThat(context.getObjectCount(SimpleClass), equalTo(1));		
		assertThat(SimpleClass.instanceCounter, equalTo(0));		
		var obj:SimpleClass = SimpleClass(context.getObjectByType(SimpleClass));
		assertThat(SimpleClass.instanceCounter, equalTo(1));		
		assertThat(obj.initCalled, equalTo(true));		
	}
	
	
}
}
