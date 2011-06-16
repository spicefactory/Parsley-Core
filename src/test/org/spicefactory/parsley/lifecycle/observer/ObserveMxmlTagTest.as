package org.spicefactory.parsley.lifecycle.observer {
import org.spicefactory.parsley.dsl.context.ContextBuilder;
import org.spicefactory.parsley.asconfig.ActionScriptConfig;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.flex.FlexContextBuilder;
import org.spicefactory.parsley.lifecycle.observer.config.ObserveCounterMxmlConfig;
import org.spicefactory.parsley.lifecycle.observer.config.ObserveMethodMxmlConfig;
import org.spicefactory.parsley.util.ContextTestUtil;

/**
 * @author Jens Halm
 */
public class ObserveMxmlTagTest extends ObserveMethodTestBase {

	
	public override function get observeContext () : Context {
		var contextA:Context = FlexContextBuilder.build(ObserveMethodMxmlConfig);
  		var contextB:Context = ContextTestUtil.newContext(ActionScriptConfig.forClass(ObserveMethodMxmlConfig), contextA, "custom");
  		return ContextBuilder
  			.newSetup()
  			.parent(contextB)
  				.newBuilder()
  				.config(ActionScriptConfig.forClasses(ObserveMethodMxmlConfig, ObserveCounterMxmlConfig))
  				.build();
	}
	
	
}
}
