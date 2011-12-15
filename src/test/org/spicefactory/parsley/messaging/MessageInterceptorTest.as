package org.spicefactory.parsley.messaging {
import org.hamcrest.object.equalTo;
import org.hamcrest.assertThat;
import org.spicefactory.parsley.messaging.messages.TestEvent;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.dsl.context.ContextBuilder;
import org.spicefactory.parsley.messaging.model.MessageInterceptor;

/**
 * @author jenshalm
 */
public class MessageInterceptorTest {
	
	
	[Test]
	public function interceptorWithParams () : void {
		var interceptor:MessageInterceptor = new MessageInterceptor();
		var context:Context = ContextBuilder.newBuilder().object(interceptor).build();
		context.scopeManager.dispatchMessage(new TestEvent(TestEvent.TEST2, "foo", 7));
		
		assertThat(interceptor.test2Count, equalTo(1));
		assertThat(interceptor.intProp, equalTo(7));
		assertThat(interceptor.stringProp, equalTo("foohandler"));
	}
	
	[Test]
	public function interceptorWithoutMessageParam () : void {
		var interceptor:MessageInterceptor = new MessageInterceptor();
		var context:Context = ContextBuilder.newBuilder().object(interceptor).build();
		context.scopeManager.dispatchMessage(new TestEvent(TestEvent.TEST1, "foo", 7));
		
		assertThat(interceptor.test1Count, equalTo(1));
	}
	
	
}
}
