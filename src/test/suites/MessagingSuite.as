package suites {

import org.spicefactory.parsley.messaging.ErrorPolicyTest;
import org.spicefactory.parsley.messaging.LazyMessagingMetadataTagTest;
import org.spicefactory.parsley.messaging.MessageProcessorTest;
import org.spicefactory.parsley.messaging.MessagingMetadataTagTest;
import org.spicefactory.parsley.messaging.MessagingMxmlTagTest;
import org.spicefactory.parsley.messaging.MessagingXmlTagTest;
import org.spicefactory.parsley.messaging.MessageInterceptorTest;
import org.spicefactory.parsley.messaging.proxy.MessageProxyTest;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class MessagingSuite {

	public var meta:MessagingMetadataTagTest;
	public var lazy:LazyMessagingMetadataTagTest;
	public var mxml:MessagingMxmlTagTest;
	public var xml:MessagingXmlTagTest;
	
	public var proxy:MessageProxyTest;
	public var interceptor:MessageInterceptorTest;
	public var proc:MessageProcessorTest;
	public var policy:ErrorPolicyTest;
		
}
}
