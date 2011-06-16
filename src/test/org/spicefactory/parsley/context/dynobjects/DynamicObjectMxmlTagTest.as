package org.spicefactory.parsley.context.dynobjects {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.flex.FlexContextBuilder;

/**
 * @author Jens Halm
 */
public class DynamicObjectMxmlTagTest extends DynamicObjectTagTestBase {

	
	public override function get dynamicContext () : Context {
		return FlexContextBuilder.build(DynamicObjectMxmlTagConfig);
	}
	
	
}
}
