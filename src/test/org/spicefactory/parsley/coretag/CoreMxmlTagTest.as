package org.spicefactory.parsley.coretag {
import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.core.isA;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.notNullValue;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.coretag.inject.model.InjectedDependency;
import org.spicefactory.parsley.flex.FlexContextBuilder;
import org.spicefactory.parsley.testmodel.ArrayElement;
import org.spicefactory.parsley.testmodel.CoreModel;
import org.spicefactory.parsley.util.ContextTestUtil;
import org.spicefactory.parsley.util.contextInState;
import org.spicefactory.parsley.util.contextWithIds;

import flash.utils.Dictionary;

/**
 * @author Jens Halm
 */
public class CoreMxmlTagTest {
	
	
	[Test]
	public function coreTags () : void {
		ArrayElement.instanceCount = 0;
		var context:Context = FlexContextBuilder.build(CoreMxmlTagConfig);
		assertThat(context, contextInState());
		assertThat(context, contextWithIds(InjectedDependency, "dependency"));
		assertThat(context, contextWithIds(CoreModel, "object"));
		var obj:CoreModel 
				= ContextTestUtil.getAndCheckObject(context, "object", CoreModel) as CoreModel;
		validateObject(obj);
	}
	
	[Test]
	public function coreTagsWithDynamicProperties () : void {
		ArrayElement.instanceCount = 0;
		var context:Context = FlexContextBuilder.build(DynamicPropertyConfig);
		assertThat(context, contextInState());
		assertThat(context, contextWithIds(InjectedDependency, "dependency"));
		assertThat(context, contextWithIds(Dictionary, "object"));
		var obj:Dictionary 
				= ContextTestUtil.getAndCheckObject(context, "object", Dictionary) as Dictionary;
		validateObject(obj);
	}
	
	private function validateObject (obj:Object) : void {
		assertThat(obj.stringProp, equalTo("foo"));
		assertThat(obj.intProp, equalTo(7));
		assertThat(obj.booleanProp, equalTo(true));
		assertThat(obj.refProp, notNullValue());
		assertThat(obj.arrayProp, array("AA", "BB", obj.refProp, obj.refProp, isA(ArrayElement)));
		/*
		assertNotNull("Expected Array instance", arr);
		assertEquals("Unexpected Array length", 5, arr.length);
		assertEquals("Unexpected Array element 0", "AA", arr[0]);
		assertEquals("Unexpected Array element 1", "BB", arr[1]);
		assertEquals("Unexpected Array element 2", obj.refProp, arr[2]);
		assertEquals("Unexpected Array element 3", obj.refProp, arr[3]);
		assertTrue("Unexpected Array element 4", arr[4] is ArrayElement);
		 */
		assertThat(ArrayElement.instanceCount, equalTo(1));
	}
	
	
}
}
