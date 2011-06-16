package org.spicefactory.parsley.lifecycle.methods {
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.lifecycle.methods.config.LifecycleMethodAsConfig;

/**
 * @author Jens Halm
 */
public class LifecycleMetadataTagTest extends LifecycleMethodTestBase {

	
	public override function get lifecycleContext () : Context {
		return ActionScriptContextBuilder.build(LifecycleMethodAsConfig);
	}
	
	
}
}
