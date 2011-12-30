package org.spicefactory.parsley.messaging {
import org.flexunit.asserts.fail;
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.spicefactory.parsley.context.ContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.messaging.ErrorPolicy;
import org.spicefactory.parsley.messaging.messages.TestMessage;
import org.spicefactory.parsley.messaging.model.ErrorPolicyHandlers;

/**
 * @author Jens Halm
 */
public class ErrorPolicyTest {
	
	
	[Test]
	public function errorPolicyRethrow () : void {
		var handlers:ErrorPolicyHandlers = new ErrorPolicyHandlers();
		var context:Context = ContextBuilder
			.newSetup()
				.messageSettings()
					.unhandledError(ErrorPolicy.RETHROW)
			.newBuilder()
				.object(handlers)
				.build();
		try {
			context.scopeManager.dispatchMessage(new TestMessage());
		}
		catch (e:Error) {
			assertThat(handlers.messageCount, equalTo(1));
			return;
		}
		fail("Expected message error to be rethrown");
	}
	
	[Test]
	public function errorPolicyIgnore () : void {
		var handlers:ErrorPolicyHandlers = new ErrorPolicyHandlers();
		var context:Context = ContextBuilder
			.newSetup()
				.messageSettings()
					.unhandledError(ErrorPolicy.IGNORE)
			.newBuilder()
				.object(handlers)
				.build();
		context.scopeManager.dispatchMessage(new TestMessage());
		assertThat(handlers.messageCount, equalTo(2));
	}
	
	[Test]
	public function errorPolicyAbort () : void {
		var handlers:ErrorPolicyHandlers = new ErrorPolicyHandlers();
		var context:Context = ContextBuilder
			.newSetup()
				.messageSettings()
					.unhandledError(ErrorPolicy.ABORT)
			.newBuilder()
				.object(handlers)
				.build();
		context.scopeManager.dispatchMessage(new TestMessage());
		assertThat(handlers.messageCount, equalTo(1));
	}
	
	[Test]
	public function errorPolicyDefault () : void {
		/* default currently is ErrorPolicy.IGNORE */
		var handlers:ErrorPolicyHandlers = new ErrorPolicyHandlers();
		var context:Context = ContextBuilder
			.newBuilder()
				.object(handlers)
				.build();
		context.scopeManager.dispatchMessage(new TestMessage());
		assertThat(handlers.messageCount, equalTo(2));
	}
	
	
}
}
