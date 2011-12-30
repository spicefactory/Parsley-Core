package org.spicefactory.parsley.config.properties {
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.spicefactory.parsley.asconfig.ActionScriptConfig;
import org.spicefactory.parsley.context.ContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.flex.FlexConfig;
import org.spicefactory.parsley.properties.Properties;
import org.spicefactory.parsley.util.ContextTestUtil;
import org.spicefactory.parsley.util.contextInState;
import org.spicefactory.parsley.xml.XmlConfig;

/**
 * @author Jens Halm
 */
public class ConfigPropertiesTest {
	
	
	public const propString:String = "someValue = foo";
	
	public const propObject:Object = { someValue: "foo" };
	
	
	[Test]
	public function asConfigWithPropString () : void {
		var context:Context = ContextBuilder
			.newBuilder()
				.config(Properties.forString(propString))
				.config(ActionScriptConfig.forClass(PropertiesAsConfig))
				.build();
		validateContext(context);
	}
	
	[Test]
	public function asConfigWithPropObject () : void {
		var context:Context = ContextBuilder
			.newBuilder()
				.config(Properties.forObject(propObject))
				.config(ActionScriptConfig.forClass(PropertiesAsConfig))
				.build();
		validateContext(context);
	}
	
	[Test]
	public function xmlConfig () : void {
		var config:XML = <objects 
			xmlns="http://www.spicefactory.org/parsley">
			<object id="object" type="org.spicefactory.parsley.config.properties.StringHolder">
				<property name="stringProp" value="${someValue}"/>
			</object> 
		</objects>; 
		var context:Context = ContextBuilder
			.newBuilder()
				.config(Properties.forString(propString))
				.config(XmlConfig.forInstance(config))
				.build();
		validateContext(context);
	}
	
	[Test]
	public function mxmlConfig () : void {
		var context:Context = ContextBuilder
			.newBuilder()
				.config(Properties.forString(propString))
				.config(FlexConfig.forClass(PropertiesMxmlConfig))
				.build();
		validateContext(context);
	}
	
	[Test]
	public function inheritedProperties () : void {
		var parent:Context = ContextBuilder
			.newBuilder()
				.config(Properties.forString(propString))
				.build();
		var context:Context = ContextBuilder
			.newSetup()
				.parent(parent)
			.newBuilder()
				.config(FlexConfig.forClass(PropertiesMxmlConfig))
				.build();
		validateContext(context);
	}
	
	[Test]
	public function twoEqualChars () : void {
		var parent:Context = ContextBuilder
			.newBuilder()
			.config(Properties.forString("someValue = foo=bar"))
			.build();
		var context:Context = ContextBuilder
			.newSetup()
			.parent(parent)
			.newBuilder()
			.config(FlexConfig.forClass(PropertiesMxmlConfig))
			.build();
		validateContext(context, "foo=bar");
	}
	
	
	private function validateContext (context:Context, expected:String = "foo") : void {
		assertThat(context, contextInState());
		var obj:StringHolder 
				= ContextTestUtil.getAndCheckObject(context, "object", StringHolder) as StringHolder;
		assertThat(obj.stringProp, equalTo(expected));
	}
	
	
}
}
