package org.spicefactory.parsley.lifecycle.methods {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.util.XmlContextUtil;

/**
 * @author Jens Halm
 */
public class LifecycleXmlTagTest extends LifecycleMethodTestBase {

	
	
	public override function get lifecycleContext () : Context {
		return XmlContextUtil.newContext(config);
	}
	
	public static const config:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley">
		
		<object id="initModel" type="org.spicefactory.parsley.lifecycle.methods.model.InitModel">
			<init method="init"/>		
		</object>
		
		<object id="destroyModel" type="org.spicefactory.parsley.lifecycle.methods.model.DestroyModel">
			<destroy method="dispose"/>		
		</object>
	</objects>; 
	
	
}
}
