package org.spicefactory.parsley.lifecycle.factory {
	import org.spicefactory.parsley.lifecycle.factory.config.FactoryMethodAsConfig;
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;

/**
 * @author Jens Halm
 */
public class FactoryMetadataTagTest extends FactoryMethodTestBase {

	
	public override function get context () : Context {
		return ActionScriptContextBuilder.build(FactoryMethodAsConfig);
	}
	
	
}
}
