package org.spicefactory.parsley.context.dynobjects {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.util.XmlContextUtil;

/**
 * @author Jens Halm
 */
public class DynamicObjectXmlTagTest extends DynamicObjectTagTestBase {
	
	
	public override function get dynamicContext () : Context {
		return XmlContextUtil.newContext(config);
	}
	
	public static const config:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley">
		
		<dynamic-object id="testObject" type="org.spicefactory.parsley.context.dynobjects.model.AnnotatedDynamicTestObject">
			<property name="dependency">
				<object type="org.spicefactory.parsley.context.dynobjects.model.DynamicTestDependency"/>
			</property>
		</dynamic-object> 
		
		<dynamic-object id="testObjectWithRootRef" type="org.spicefactory.parsley.context.dynobjects.model.SimpleDynamicTestObject"/>
		
		<dynamic-object id="ref" type="org.spicefactory.parsley.context.dynobjects.model.DynamicTestDependency"/>
	
	</objects>;	
	
	
}
}
