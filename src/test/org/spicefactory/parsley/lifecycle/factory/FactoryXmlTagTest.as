package org.spicefactory.parsley.lifecycle.factory {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.util.XmlContextUtil;

/**
 * @author Jens Halm
 */
public class FactoryXmlTagTest extends FactoryMethodTestBase {

	
	public static const config:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley">
		
		<object id="dependency" type="org.spicefactory.parsley.coretag.inject.model.InjectedDependency"/>
		
		<object id="factoryWithDependency" type="org.spicefactory.parsley.lifecycle.factory.model.TestFactory">
			<factory method="createInstance"/>
		</object> 
	</objects>; 

	public override function get context () : Context {
		return XmlContextUtil.newContext(config);
	}
	
	
}
}
