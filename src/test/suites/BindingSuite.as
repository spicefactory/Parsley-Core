package suites {
import org.spicefactory.parsley.binding.BindingMetadataTagTest;
import org.spicefactory.parsley.binding.BindingMxmlTagTest;
import org.spicefactory.parsley.binding.BindingXmlTagTest;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class BindingSuite {

	public var bindingMeta:BindingMetadataTagTest;
	public var bindingMxml:BindingMxmlTagTest;
	public var bindingXml:BindingXmlTagTest;
	
}
}
