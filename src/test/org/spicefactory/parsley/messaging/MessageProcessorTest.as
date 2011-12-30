package org.spicefactory.parsley.messaging {
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.notNullValue;
import org.spicefactory.parsley.context.ContextBuilder;
import org.spicefactory.parsley.context.scope.model.OrderedMixedScopeReceivers;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.MessageState;
import org.spicefactory.parsley.messaging.model.OrderedMixedScopeInterceptors;
import org.spicefactory.parsley.messaging.model.ResponseSender;

/**
 * @author Jens Halm
 */
public class MessageProcessorTest {

	[Test]
	public function suspendMessageProcessor () : void {
		var receiver:OrderedMixedScopeInterceptors = new OrderedMixedScopeInterceptors();
		var context:Context = ContextBuilder.newBuilder().object(receiver).build();
		context.scopeManager.dispatchMessage("foo");
		var processor:MessageProcessor = receiver.processor;
		assertThat(processor, notNullValue());
		assertThat(processor.state, equalTo(MessageState.SUSPENDED));
		assertThat(receiver.order, equalTo("A"));
		processor.resume();
		assertThat(processor.state, equalTo(MessageState.SUSPENDED));
		assertThat(receiver.order, equalTo("ABCD"));
		processor.resume();
		assertThat(processor.state, equalTo(MessageState.COMPLETE));
		assertThat(receiver.order, equalTo("ABCDEF"));
	}
	
	[Test]
	public function cancelMessageProcessor () : void {
		var receiver:OrderedMixedScopeInterceptors = new OrderedMixedScopeInterceptors();
		var context:Context = ContextBuilder.newBuilder().object(receiver).build();
		context.scopeManager.dispatchMessage("foo");
		var processor:MessageProcessor = receiver.processor;
		assertThat(processor, notNullValue());
		assertThat(processor.state, equalTo(MessageState.SUSPENDED));
		assertThat(receiver.order, equalTo("A"));
		processor.cancel();
		assertThat(processor.state, equalTo(MessageState.CANCELLED));
		assertThat(receiver.order, equalTo("A"));
	}
	
	[Test]
	public function sendResponse () : void {
		var receiverParent:OrderedMixedScopeReceivers = new OrderedMixedScopeReceivers();
		var receiverChild:OrderedMixedScopeReceivers = new OrderedMixedScopeReceivers();
		var parent:Context = ContextBuilder.newBuilder().object(receiverParent).object(new ResponseSender()).build();
		var child:Context = ContextBuilder.newSetup().parent(parent).newBuilder().object(receiverChild).build();
		child.scopeManager.dispatchMessage("foo");
		assertThat(receiverParent.order, equalTo("B24D"));
		assertThat(receiverChild.order, equalTo("ABC1234D"));
	}
	
}
}
