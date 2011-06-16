package suites {
import org.spicefactory.parsley.coretag.CoreMxmlTagTest;
import org.spicefactory.parsley.coretag.CoreXmlTagTest;
import org.spicefactory.parsley.coretag.inject.InjectMetadataTagTest;
import org.spicefactory.parsley.coretag.metadata.MetadataInheritanceTest;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class CoreTagSuite {

	public var metadata:MetadataInheritanceTest;
	public var coreMxml:CoreMxmlTagTest;
	public var coreXml:CoreXmlTagTest;
	public var inject:InjectMetadataTagTest;
		
}
}
