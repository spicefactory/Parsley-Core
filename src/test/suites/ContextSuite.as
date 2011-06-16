package suites {

import org.spicefactory.parsley.context.ContextTest;
import org.spicefactory.parsley.context.dynobjects.DynamicObjectMxmlTagTest;
import org.spicefactory.parsley.context.dynobjects.DynamicObjectTest;
import org.spicefactory.parsley.context.dynobjects.DynamicObjectXmlTagTest;
import org.spicefactory.parsley.context.inheritance.MultipleInheritanceTest;
import org.spicefactory.parsley.context.scope.ScopeTest;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class ContextSuite {

	public var context:ContextTest;
	public var scope:ScopeTest;
	public var inheritance:MultipleInheritanceTest;
	public var dynObj:DynamicObjectTest;
	public var dynObjMxml:DynamicObjectMxmlTagTest;
	public var dynObjXml:DynamicObjectXmlTagTest;

}
}
