package org.spicefactory.parsley.messaging.proxy {

import org.flexunit.asserts.fail;
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.spicefactory.parsley.asconfig.ActionScriptConfig;
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.dsl.context.ContextBuilder;
import org.spicefactory.parsley.messaging.proxy.config.MessageProxyConfig;
import org.spicefactory.parsley.messaging.proxy.model.CommandReceiver;
import org.spicefactory.parsley.messaging.proxy.model.ErrorHandler;
import org.spicefactory.parsley.messaging.proxy.model.FaultyObjectConfig;
import org.spicefactory.parsley.messaging.proxy.model.MessageHandlerReceiver;

/**
 * @author Jens Halm
 */
public class MessageProxyTest {
	
	
	[Test]
	public function messageHandlerProxy () : void {
		MessageHandlerReceiver.instanceCount = 0;
		var context:Context = ActionScriptContextBuilder.build(MessageProxyConfig);
		var receiver:MessageHandlerReceiver = context.getObjectByType(MessageHandlerReceiver) as MessageHandlerReceiver;
		assertThat(receiver.getCount(), equalTo(1));
	}
	
	[Test]
	public function commandProxy () : void {
		MessageHandlerReceiver.instanceCount = 0;
		var context:Context = ActionScriptContextBuilder.build(MessageProxyConfig);
		var receiver:CommandReceiver = context.getObjectByType(CommandReceiver) as CommandReceiver;
		assertThat(receiver.getCount(), equalTo(1));
	}
	
	[Test]
	public function removeProxyOnContextError () : void {
		var parent:Context = ContextBuilder.newBuilder().build();
		try {
			ContextBuilder
				.newSetup()
				.parent(parent)
					.newBuilder()
					.config(ActionScriptConfig.forClass(FaultyObjectConfig))
					.build();
		}
		catch (e:Error) {
			/* expected error */
			var errorHandler:ErrorHandler = new ErrorHandler();
			var context:Context = ContextBuilder
				.newSetup()
				.parent(parent)
					.newBuilder()
					.object(errorHandler)
					.build();
			context.scopeManager.dispatchMessage(new Object());
			assertThat(errorHandler.getCount(), equalTo(0));
			return;
		}
		fail("Expected error in ContextBuilder");
	}
	
	
}
}
