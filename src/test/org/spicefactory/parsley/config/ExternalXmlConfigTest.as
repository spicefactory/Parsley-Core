package org.spicefactory.parsley.config {
import org.flexunit.async.Async;
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.notNullValue;
import org.spicefactory.parsley.context.ContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.coretag.inject.model.InjectedDependency;
import org.spicefactory.parsley.properties.Properties;
import org.spicefactory.parsley.testmodel.CoreModel;
import org.spicefactory.parsley.util.ContextTestUtil;
import org.spicefactory.parsley.util.contextInState;
import org.spicefactory.parsley.util.contextWithIds;
import org.spicefactory.parsley.xml.XmlConfig;

/**
 * @author Jens Halm
 */
public class ExternalXmlConfigTest {
	
	
	[Test(async)]
	public function externalConfig () : void {
		var context:Context = ContextBuilder.newBuilder().config(XmlConfig.forFile("test.xml")).build();
		assertThat(context, contextInState(false, false));
		var func:Function = Async.asyncHandler(this, onContextComplete, 5000);
		context.addEventListener(ContextEvent.INITIALIZED, func);
	}	
	
	[Test(async)]
	public function externalConfigWithProperties () : void {
		var context:Context = ContextBuilder
			.newBuilder()
				.config(Properties.forFile("test2.properties"))
				.config(XmlConfig.forFile("test2.xml"))
				.build();
		assertThat(context, contextInState(false, false));
		var func:Function = Async.asyncHandler(this, onContextComplete, 5000);
		context.addEventListener(ContextEvent.INITIALIZED, func);
	}	
	
	private function onContextComplete (event:ContextEvent, data:Object = null) : void {
		var context:Context = event.target as Context;
		assertThat(context, contextInState());
		assertThat(context, contextWithIds(InjectedDependency, "dependency"));
		assertThat(context, contextWithIds(CoreModel, "object"));
		var obj:CoreModel 
				= ContextTestUtil.getAndCheckObject(context, "object", CoreModel) as CoreModel;
		assertThat(obj.stringProp, equalTo("foo"));
		assertThat(obj.intProp, equalTo(7));
		assertThat(obj.refProp, notNullValue());
	}
		
		
}
}
