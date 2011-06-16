package org.spicefactory.parsley.messaging {
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.messaging.config.MessagingAsConfig;
import org.spicefactory.parsley.messaging.messages.TestEvent;
import org.spicefactory.parsley.messaging.model.MessageInterceptors;
import org.spicefactory.parsley.messaging.model.MessageInterceptorsMetadata;
import org.spicefactory.parsley.runtime.RuntimeContextBuilder;

/**
 * @author Jens Halm
 */
public class MessagingMetadataTagTest extends MessagingTestBase {
	

	function MessagingMetadataTagTest () {
		super(false);
	}
		
	public override function get messagingContext () : Context {
		return ActionScriptContextBuilder.build(MessagingAsConfig);
	}
	
	
	[Test]
	public function interceptorWithoutHandler () : void {
		var interceptors:MessageInterceptors = new MessageInterceptorsMetadata();
		var context:Context = RuntimeContextBuilder.build([interceptors]);
		context.scopeManager.dispatchMessage(new TestEvent(TestEvent.TEST1, "", 0));
		assertThat(interceptors.test1Count, equalTo(2));
	}
	
	
}
}
