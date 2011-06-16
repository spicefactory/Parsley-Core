package org.spicefactory.parsley.lifecycle.factory {
import org.spicefactory.parsley.lifecycle.factory.config.FactoryMethodMxmlConfig;
import org.spicefactory.parsley.core.context.Context;

import org.spicefactory.parsley.flex.FlexContextBuilder;

/**
 * @author Jens Halm
 */
public class FactoryMxmlTagTest extends FactoryMethodTestBase {


	public override function get context () : Context {
		return FlexContextBuilder.build(FactoryMethodMxmlConfig);
	}
		
	
}
}
