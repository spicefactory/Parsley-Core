package suites {

import org.spicefactory.parsley.command.CommandFactoryDslTest;
import org.spicefactory.parsley.command.CommandFactoryMxmlTagTest;
import org.spicefactory.parsley.command.CommandFactoryXmlTagTest;
import org.spicefactory.parsley.command.MapCommandDslTest;
import org.spicefactory.parsley.command.MapCommandMxmlTagTest;
import org.spicefactory.parsley.command.MapCommandXmlTagTest;
[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class CommandSuite {

	public var mapCommandMxml:MapCommandMxmlTagTest;
	public var mapCommandDsl:MapCommandDslTest;
	public var mapCommandXml:MapCommandXmlTagTest;

	public var commandFactoryMxml:CommandFactoryMxmlTagTest;
	public var commandFactoryDsl:CommandFactoryDslTest;
	public var commandFactoryXml:CommandFactoryXmlTagTest;
	
	/*
	public var order:MapCommandScopeAndOrderTest;
	public var commandSync:SynchronousCommandTest;
	 */
	 
}
}
