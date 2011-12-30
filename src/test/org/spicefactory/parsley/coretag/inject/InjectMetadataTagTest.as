package org.spicefactory.parsley.coretag.inject {

import org.hamcrest.assertThat;
import org.hamcrest.collection.arrayWithSize;
import org.hamcrest.collection.everyItem;
import org.hamcrest.core.isA;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.notNullValue;
import org.hamcrest.object.nullValue;
import org.hamcrest.object.sameInstance;
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.context.ContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.coretag.inject.model.ArrayPropertyInjection;
import org.spicefactory.parsley.coretag.inject.model.InjectedDependency;
import org.spicefactory.parsley.coretag.inject.model.OptionalMethodInjection;
import org.spicefactory.parsley.coretag.inject.model.OptionalPropertyIdInjection;
import org.spicefactory.parsley.coretag.inject.model.OptionalPropertyInjection;
import org.spicefactory.parsley.coretag.inject.model.RequiredConstructorInjection;
import org.spicefactory.parsley.coretag.inject.model.RequiredMethodInjection;
import org.spicefactory.parsley.coretag.inject.model.RequiredPropertyIdInjection;
import org.spicefactory.parsley.coretag.inject.model.RequiredPropertyInjection;
import org.spicefactory.parsley.util.ContextTestUtil;
import org.spicefactory.parsley.util.contextInState;

/**
 * @author Jens Halm
 */
public class InjectMetadataTagTest {
	
	
	[Test]
	public function constructorInjection () : void {
		var context:Context = ActionScriptContextBuilder.build(InjectTestConfig);
		assertThat(context, contextInState());
		var obj:RequiredConstructorInjection = ContextTestUtil.getAndCheckObject(context, 
				"requiredConstructorInjection", RequiredConstructorInjection) as RequiredConstructorInjection;
		checkDependency(context, obj.dependency);
	}
	
	[Test(expects="org.spicefactory.parsley.core.errors.ContextError")]
	public function constructorInjectionWithMissingReqDep () : void {
		var context:Context = ActionScriptContextBuilder.build(InjectTestConfig);
		assertThat(context, contextInState());
		context.getObject("missingConstructorInjection");		
	}
	
	[Test]
	public function constructorInjectionWithMissingOptDep () : void {
		var context:Context = ActionScriptContextBuilder.build(InjectTestConfig);
		assertThat(context, contextInState());
		var obj:OptionalMethodInjection = ContextTestUtil.getAndCheckObject(context, 
				"optionalMethodInjection", OptionalMethodInjection) as OptionalMethodInjection;
		assertThat(obj.dependency, nullValue());
	}

	[Test]
	public function propertyTypeInjection () : void {
		var context:Context = ActionScriptContextBuilder.build(InjectTestConfig);
		assertThat(context, contextInState());
		var obj:RequiredPropertyInjection = ContextTestUtil.getAndCheckObject(context, 
				"requiredPropertyInjection", RequiredPropertyInjection) as RequiredPropertyInjection;
		checkDependency(context, obj.dependency);
	}	

	[Test(expects="org.spicefactory.parsley.core.errors.ContextError")]
	public function propertyTypeInjectionWithMissingReqDep () : void {
		var context:Context = ActionScriptContextBuilder.build(InjectTestConfig);
		assertThat(context, contextInState());
		context.getObject("missingPropertyInjection");		
	}
	
	[Test]
	public function propertyTypeInjectionWithMissingOptDep () : void {
		var context:Context = ActionScriptContextBuilder.build(InjectTestConfig);
		assertThat(context, contextInState());
		var obj:OptionalPropertyInjection = ContextTestUtil.getAndCheckObject(context, 
				"optionalPropertyInjection", OptionalPropertyInjection) as OptionalPropertyInjection;
		assertThat(obj.dependency, nullValue());		
	}

	[Test]
	public function propertyIdInjection () : void {
		var context:Context = ActionScriptContextBuilder.build(InjectTestConfig);
		assertThat(context, contextInState());
		var obj:RequiredPropertyIdInjection = ContextTestUtil.getAndCheckObject(context, 
				"requiredPropertyIdInjection", RequiredPropertyIdInjection) as RequiredPropertyIdInjection;
		checkDependency(context, obj.dependency);		
	}
	
	[Test(expects="org.spicefactory.parsley.core.errors.ContextError")]
	public function propertyIdInjectionWithMissingReqDep () : void {
		var context:Context = ActionScriptContextBuilder.build(InjectTestConfig);
		assertThat(context, contextInState());
		context.getObject("missingPropertyIdInjection");		
	}	
	
	[Test]
	public function propertyIdInjectionWithMissingOptDep () : void {
		var context:Context = ActionScriptContextBuilder.build(InjectTestConfig);
		assertThat(context, contextInState());
		var obj:OptionalPropertyIdInjection = ContextTestUtil.getAndCheckObject(context, 
				"optionalPropertyIdInjection", OptionalPropertyIdInjection) as OptionalPropertyIdInjection;
		assertThat(obj.dependency, nullValue());	
		assertThat(obj.valueWithDefault, equalTo("foo"));	
	}	
	
	[Test]
	public function methodInjection () : void {
		var context:Context = ActionScriptContextBuilder.build(InjectTestConfig);
		assertThat(context, contextInState());
		var obj:RequiredMethodInjection = ContextTestUtil.getAndCheckObject(context, 
				"requiredMethodInjection", RequiredMethodInjection) as RequiredMethodInjection;
		checkDependency(context, obj.dependency);		
	}	
	
	[Test(expects="org.spicefactory.parsley.core.errors.ContextError")]
	public function methodInjectionWithMissingReqDep () : void {
		var context:Context = ActionScriptContextBuilder.build(InjectTestConfig);
		assertThat(context, contextInState());
		context.getObject("missingMethodInjection");		
	}
	
	[Test]
	public function methodInjectionWithMissingOptDep () : void {
		var context:Context = ActionScriptContextBuilder.build(InjectTestConfig);
		assertThat(context, contextInState());
		var obj:OptionalMethodInjection = ContextTestUtil.getAndCheckObject(context, 
				"optionalMethodInjection", OptionalMethodInjection) as OptionalMethodInjection;
		assertThat(obj.dependency, nullValue());
	}	
	
	[Test]
	public function arrayInjection () : void {
		var context:Context = ActionScriptContextBuilder.build(InjectTestConfig);
		assertThat(context, contextInState());
		var obj:ArrayPropertyInjection = ContextTestUtil.getAndCheckObject(context, 
				"arrayPropertyInjection", ArrayPropertyInjection) as ArrayPropertyInjection;
		var deps:Array = obj.dependencies;
		assertThat(deps, arrayWithSize(3));
		assertThat(deps, everyItem(isA(Date)));
	}
	
	[Test]
	public function sameIdDifferentType () : void {
		var propInjection:RequiredPropertyInjection = new RequiredPropertyInjection();
		var parent:Context = ContextBuilder.newBuilder().object(new InjectedDependency(), "duplicateId").build();
		ContextBuilder.newSetup().parent(parent).newBuilder().object(new Date(), "duplicateId").object(propInjection).build();
		assertThat(propInjection.dependency, notNullValue());
	}

	
	private function checkDependency (context:Context, dep:InjectedDependency) : void {
		assertThat(dep, notNullValue());
		var depFromContainer:InjectedDependency	= ContextTestUtil.getAndCheckObject(context, 
				"injectedDependency", InjectedDependency) as InjectedDependency;
		assertThat(dep, sameInstance(depFromContainer));
	}
	
	
}
}
