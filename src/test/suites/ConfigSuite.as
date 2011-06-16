package suites {
import org.spicefactory.parsley.config.DslConfigTest;
import org.spicefactory.parsley.config.ExternalXmlConfigTest;
import org.spicefactory.parsley.config.RuntimeConfigTest;
import org.spicefactory.parsley.config.asconfig.AsConfigTest;
import org.spicefactory.parsley.config.properties.ConfigPropertiesTest;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class ConfigSuite {

	public var asConfig:AsConfigTest;
	public var runtime:RuntimeConfigTest;
	public var dsl:DslConfigTest;
	public var props:ConfigPropertiesTest;
	public var extXml:ExternalXmlConfigTest;
	
}
}
