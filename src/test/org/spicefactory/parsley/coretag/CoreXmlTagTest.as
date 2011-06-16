package org.spicefactory.parsley.coretag {
import org.flexunit.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.core.isA;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.notNullValue;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.coretag.inject.model.InjectedDependency;
import org.spicefactory.parsley.testmodel.CoreModel;
import org.spicefactory.parsley.util.ContextTestUtil;
import org.spicefactory.parsley.util.XmlContextUtil;
import org.spicefactory.parsley.util.contextInState;
import org.spicefactory.parsley.util.contextWithIds;
import org.spicefactory.parsley.testmodel.XmlModel;

import flash.events.Event;
import flash.utils.Dictionary;

/**
 * @author Jens Halm
 */
public class CoreXmlTagTest {
	
	
	public static const config:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley">
		
		<object id="dependency" type="org.spicefactory.parsley.coretag.inject.model.InjectedDependency"/>
		
		<object id="object" type="org.spicefactory.parsley.testmodel.CoreModel">
			<constructor-args>
				<string>foo</string>
				<int>7</int>
			</constructor-args>
			<property name="booleanProp" value="true"/>
			<property name="refProp" id-ref="dependency"/>
			<property name="arrayProp">
				<array>
					<string>AA</string>
					<int>7</int>
					<boolean>true</boolean>
					<class>flash.events.Event</class>
					<object type="org.spicefactory.parsley.testmodel.XmlModel">
						<property name="prop" value="nested"/>
					</object>
					<static-property type="org.spicefactory.parsley.testmodel.XmlModel" property="STATIC_PROP"/>
					<object-ref id-ref="dependency"/>
					<object-ref type-ref="org.spicefactory.parsley.coretag.inject.model.InjectedDependency"/>
					<null/>
				</array>
			</property>
		</object> 
	</objects>; 
	
	public static const dynamicConfig:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley">
		
		<object id="dependency" type="org.spicefactory.parsley.coretag.inject.model.InjectedDependency"/>
		
		<object id="object" type="flash.utils.Dictionary">
			<dynamic-property name="stringProp" value="foo"/>
			<dynamic-property name="intProp"><int>7</int></dynamic-property>
			<dynamic-property name="booleanProp"><boolean>true</boolean></dynamic-property>
			<dynamic-property name="refProp" id-ref="dependency"/>
			<dynamic-property name="arrayProp">
				<array>
					<string>AA</string>
					<int>7</int>
					<boolean>true</boolean>
					<class>flash.events.Event</class>
					<object type="org.spicefactory.parsley.testmodel.XmlModel">
						<property name="prop" value="nested"/>
					</object>
					<static-property type="org.spicefactory.parsley.testmodel.XmlModel" property="STATIC_PROP"/>
					<object-ref id-ref="dependency"/>
					<object-ref type-ref="org.spicefactory.parsley.coretag.inject.model.InjectedDependency"/>
					<null/>
				</array>
			</dynamic-property>
		</object> 
	</objects>; 
	
	
	
	[Test]
	public function coreTags () : void {
		var context:Context = XmlContextUtil.newContext(config);
		assertThat(context, contextInState());
		assertThat(context, contextWithIds(InjectedDependency, "dependency"));
		assertThat(context, contextWithIds(CoreModel, "object"));
		var obj:CoreModel 
				= ContextTestUtil.getAndCheckObject(context, "object", CoreModel) as CoreModel;
		validateObject(obj);
	}		
	
	[Test]
	public function coreTagsWithDynamicProperties () : void {
		var context:Context = XmlContextUtil.newContext(dynamicConfig);
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
		assertThat(obj.arrayProp, array("AA", 7, true, Event, isA(XmlModel), "static-foo", obj.refProp, obj.refProp, null));
		assertThat(obj.arrayProp[4].prop, equalTo("nested"));
		
		/*
		var arr:Array = obj.arrayProp;
		assertNotNull("Expected Array instance", arr);
		assertEquals("Unexpected Array length", 9, arr.length);
		assertEquals("Unexpected Array element 0", "AA", arr[0]);
		assertEquals("Unexpected Array element 1", 7, arr[1]);
		assertEquals("Unexpected Array element 2", true, arr[2]);
		assertEquals("Unexpected Array element 3", Event, arr[3]);
		assertTrue("Expected Array element 4 to be of type XmlModel", (arr[4] is XmlModel));
		var model:XmlModel = arr[4] as XmlModel;
		assertEquals("Unexpected string property for XmlModel", "nested", model.prop);
		assertEquals("Unexpected Array element 5", "static-foo", arr[5]);
		assertEquals("Unexpected Array element 6", obj.refProp, arr[6]);
		assertEquals("Unexpected Array element 7", obj.refProp, arr[7]);
		assertEquals("Unexpected Array element 8", null, arr[8]);
		 */
	}
	
	
}
}
