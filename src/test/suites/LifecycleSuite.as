package suites {

import org.spicefactory.parsley.lifecycle.asyncinit.AsyncInitMetadataTagTest;
import org.spicefactory.parsley.lifecycle.asyncinit.AsyncInitMxmlTagTest;
import org.spicefactory.parsley.lifecycle.asyncinit.AsyncInitOrderTest;
import org.spicefactory.parsley.lifecycle.asyncinit.AsyncInitXmlTagTest;
import org.spicefactory.parsley.lifecycle.factory.FactoryMetadataTagTest;
import org.spicefactory.parsley.lifecycle.factory.FactoryMxmlTagTest;
import org.spicefactory.parsley.lifecycle.factory.FactoryXmlTagTest;
import org.spicefactory.parsley.lifecycle.methods.LifecycleMetadataTagTest;
import org.spicefactory.parsley.lifecycle.methods.LifecycleMxmlTagTest;
import org.spicefactory.parsley.lifecycle.methods.LifecycleXmlTagTest;
import org.spicefactory.parsley.lifecycle.observer.ObserveMetadataTagTest;
import org.spicefactory.parsley.lifecycle.observer.ObserveMxmlTagTest;
import org.spicefactory.parsley.lifecycle.observer.ObserveXmlTagTest;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class LifecycleSuite {

	public var asyncMeta:AsyncInitMetadataTagTest;
	public var asyncMxml:AsyncInitMxmlTagTest;
	public var asyncXml:AsyncInitXmlTagTest;
	public var asyncOrder:AsyncInitOrderTest;
	
	public var factoryMeta:FactoryMetadataTagTest;
	public var factoryMxml:FactoryMxmlTagTest;
	public var factoryXml:FactoryXmlTagTest;
	
	public var lifecycleMeta:LifecycleMetadataTagTest;
	public var lifecycleMxml:LifecycleMxmlTagTest;
	public var lifecycleXml:LifecycleXmlTagTest;
	
	public var observeMeta:ObserveMetadataTagTest;
	public var observeMxml:ObserveMxmlTagTest;
	public var observeXml:ObserveXmlTagTest;
		
}
}
