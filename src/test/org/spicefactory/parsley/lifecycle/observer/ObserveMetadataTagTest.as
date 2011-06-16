package org.spicefactory.parsley.lifecycle.observer {
import org.spicefactory.parsley.dsl.context.ContextBuilder;
import org.spicefactory.parsley.asconfig.ActionScriptConfig;
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.lifecycle.observer.config.ObserveCounterAsConfig;
import org.spicefactory.parsley.lifecycle.observer.config.ObserveMethodAsConfig;
import org.spicefactory.parsley.util.ContextTestUtil;

/**
 * @author Jens Halm
 */
public class ObserveMetadataTagTest extends ObserveMethodTestBase {

	
	public override function get observeContext () : Context {
		var contextA:Context = ActionScriptContextBuilder.build(ObserveMethodAsConfig);
  		var contextB:Context = ContextTestUtil.newContext(ActionScriptConfig.forClass(ObserveMethodAsConfig), contextA, "custom");
  		return ContextBuilder
  			.newSetup()
  			.parent(contextB)
	  			.newBuilder()
	  			.config(ActionScriptConfig.forClasses(ObserveMethodAsConfig, ObserveCounterAsConfig))
	  			.build();
	}
	
	
}
}
