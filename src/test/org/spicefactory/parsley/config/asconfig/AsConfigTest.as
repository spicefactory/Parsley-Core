package org.spicefactory.parsley.config.asconfig {
import org.spicefactory.parsley.asconfig.ActionScriptConfig;
import org.spicefactory.parsley.dsl.context.ContextBuilder;
import org.flexunit.assertThat;
import org.hamcrest.collection.arrayWithSize;
import org.hamcrest.collection.everyItem;
import org.hamcrest.core.isA;
import org.hamcrest.core.not;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.sameInstance;
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.testmodel.ClassWithSimpleProperties;
import org.spicefactory.parsley.testmodel.LazyTestClass;
import org.spicefactory.parsley.util.ContextTestUtil;
import org.spicefactory.parsley.util.contextInState;
import org.spicefactory.parsley.util.contextWithIds;

/**
 * @author Jens Halm
 */
public class AsConfigTest {

	
	[Test]
	public function emptyContext () : void {
		var context:Context = ActionScriptContextBuilder.build(EmptyAsConfig);
		assertThat(context, contextInState());
		assertThat(context, contextWithIds(Object));
	}
	
	[Test]
	public function objectWithSimpleProperties () : void {
		var context:Context = ActionScriptContextBuilder.build(AsConfig1);
		assertThat(context, contextInState());
		assertThat(context, contextWithIds(ClassWithSimpleProperties, "simpleObject"));
		assertThat(context, contextWithIds(AsConfig1));
		var obj:ClassWithSimpleProperties 
				= ContextTestUtil.getAndCheckObject(context, "simpleObject", ClassWithSimpleProperties) as ClassWithSimpleProperties;
		assertThat(obj.booleanProp, equalTo(true));
		assertThat(obj.intProp, equalTo(7));
		assertThat(obj.stringProp, equalTo("foo"));
	}

	[Test]
	public function overwrittenId () : void {
		var context:Context = ActionScriptContextBuilder.build(AsConfig2);
		assertThat(context, contextInState());
		assertThat(context, contextWithIds(ClassWithSimpleProperties, "foo", "prototypeInstance"));
		assertThat(context, contextWithIds(Object, "foo", "prototypeInstance", "lazyInstance", "eagerInstance"));
		ContextTestUtil.getAndCheckObject(context, "foo", ClassWithSimpleProperties);		
	}
	
	[Test]
	public function dynamicObject () : void {
		var context:Context = ActionScriptContextBuilder.build(AsConfig2);
		assertThat(context, contextInState());
		assertThat(context, contextWithIds(ClassWithSimpleProperties, "foo", "prototypeInstance"));
		assertThat(context, contextWithIds(Object, "foo", "prototypeInstance", "lazyInstance", "eagerInstance"));
		var o1:Object = ContextTestUtil.getAndCheckObject(context, "prototypeInstance", ClassWithSimpleProperties);
		var o2:Object = ContextTestUtil.getAndCheckObject(context, "prototypeInstance", ClassWithSimpleProperties);
		assertThat(o2, not(sameInstance(o1)));
	}
	
	[Test]
	public function lazyness () : void {
		LazyTestClass.instanceCount = 0;
		var context:Context = ActionScriptContextBuilder.build(AsConfig2);
		assertThat(context, contextInState());
		assertThat(context, contextWithIds(LazyTestClass, "lazyInstance", "eagerInstance"));
		assertThat(context, contextWithIds(Object, "foo", "prototypeInstance", "lazyInstance", "eagerInstance"));
		assertThat(LazyTestClass.instanceCount, equalTo(1));
		ContextTestUtil.getAndCheckObject(context, "lazyInstance", LazyTestClass);		
		assertThat(LazyTestClass.instanceCount, equalTo(2));
		ContextTestUtil.getAndCheckObject(context, "eagerInstance", LazyTestClass);		
		assertThat(LazyTestClass.instanceCount, equalTo(2));
	}
	
	[Test]
	public function mergeTwoConfigs () : void {
		var context:Context = ContextBuilder.newBuilder()
				.config(ActionScriptConfig.forClasses(AsConfig1, AsConfig2)).build();
		assertThat(context, contextInState());
		assertThat(context, contextWithIds(ClassWithSimpleProperties, "simpleObject", "foo", "prototypeInstance"));
		assertThat(context, contextWithIds(Object, "simpleObject", "foo", "prototypeInstance", "lazyInstance", "eagerInstance"));
	}
	
	[Test]
	public function getAllObjectsByType () : void {
		var context:Context = ContextBuilder.newBuilder()
				.config(ActionScriptConfig.forClasses(AsConfig1, AsConfig2)).build();
		assertThat(context, contextInState());
		assertThat(context.getObjectCount(ClassWithSimpleProperties), equalTo(3));	
		var objects:Array = context.getAllObjectsByType(ClassWithSimpleProperties);
		assertThat(objects, arrayWithSize(3));
		assertThat(objects, everyItem(isA(ClassWithSimpleProperties)));
	}
	
	
}
}
