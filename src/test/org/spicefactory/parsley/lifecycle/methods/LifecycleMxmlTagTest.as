package org.spicefactory.parsley.lifecycle.methods {
import org.spicefactory.parsley.lifecycle.methods.config.LifecycleMethodMxmlConfig;
import org.spicefactory.parsley.core.context.Context;

import org.spicefactory.parsley.flex.FlexContextBuilder;

/**
 * @author Jens Halm
 */
public class LifecycleMxmlTagTest extends LifecycleMethodTestBase {

	
	public override function get lifecycleContext () : Context {
		return FlexContextBuilder.build(LifecycleMethodMxmlConfig);
	}
	
	
}
}
