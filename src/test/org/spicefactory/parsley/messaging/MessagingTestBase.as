package org.spicefactory.parsley.messaging {
import org.hamcrest.object.notNullValue;
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.nullValue;
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.messaging.messages.TestEvent;
import org.spicefactory.parsley.messaging.messages.TestMessage;
import org.spicefactory.parsley.messaging.model.ErrorHandlers;
import org.spicefactory.parsley.messaging.model.EventSource;
import org.spicefactory.parsley.messaging.model.FaultyMessageHandlers;
import org.spicefactory.parsley.messaging.model.MessageBindings;
import org.spicefactory.parsley.messaging.model.MessageHandlers;
import org.spicefactory.parsley.messaging.model.MessageInterceptors;
import org.spicefactory.parsley.messaging.model.SelectorMessageHandlers;
import org.spicefactory.parsley.messaging.model.TestMessageDispatcher;
import org.spicefactory.parsley.messaging.model.TestMessageHandlers;
import org.spicefactory.parsley.util.contextInState;

import flash.events.Event;
import flash.geom.Rectangle;

/**
 * @author Jens Halm
 */
public class MessagingTestBase {
	
	
	private var context:Context;
	private var lazy:Boolean;
	
	
	function MessagingTestBase (lazy:Boolean) {
		this.lazy = lazy;
	}


	[Before]
	public function createContext () : void {
		context = messagingContext;
	}

	[Test]
	public function contextState () : void {
		assertThat(context, contextInState());
	}
	
	[Test]
	public function messageHandlers () : void {
		var source:EventSource = context.getObject("eventSource") as EventSource;
		var handlers:MessageHandlers;
		if (lazy) handlers = context.getObject("messageHandlers") as MessageHandlers;
		source.dispatchEvent(new TestEvent(TestEvent.TEST1, "foo1", 7));
		source.dispatchEvent(new TestEvent(TestEvent.TEST2, "foo2", 9));
		source.dispatchEvent(new Event("foo"));
		if (!lazy) handlers = context.getObject("messageHandlers") as MessageHandlers;
		assertThat(handlers.test1Count, equalTo(2));
		assertThat(handlers.test2Count, equalTo(2));
		assertThat(handlers.genericEventCount, equalTo(3));
		assertThat(handlers.stringProp, equalTo("foo2"));
		assertThat(handlers.intProp, equalTo(9));
	}
	
	[Test]
	public function messageHandlerOrder () : void {
		var source:EventSource = context.getObject("eventSource") as EventSource;
		var handlers:MessageHandlers;
		if (lazy) handlers = context.getObject("messageHandlers") as MessageHandlers;
		source.dispatchEvent(new TestEvent(TestEvent.TEST1, "foo1", 7));
		source.dispatchEvent(new TestEvent(TestEvent.TEST2, "foo2", 9));
		source.dispatchEvent(new Event("foo"));
		if (!lazy) handlers = context.getObject("messageHandlers") as MessageHandlers;
		assertThat(handlers.order, equalTo("1AT2ATA"));
	}

	[Test]
	public function messageBindings () : void {
		var source:EventSource = context.getObject("eventSource") as EventSource;
		var bindings:MessageBindings;
		if (lazy) bindings = context.getObject("messageBindings") as MessageBindings;
		source.dispatchEvent(new TestEvent(TestEvent.TEST1, "foo1", 7));
		source.dispatchEvent(new TestEvent(TestEvent.TEST2, "foo2", 9));
		if (!lazy) bindings = context.getObject("messageBindings") as MessageBindings;
		assertThat(bindings.stringProp, equalTo("foo1foo2"));
		assertThat(bindings["intProp1"], equalTo(7));
		assertThat(bindings["intProp2"], equalTo(9));
	}
	
	[Test]
	public function messageInterceptors () : void {
		var source:EventSource = context.getObject("eventSource") as EventSource;
		var handlers:MessageHandlers = context.getObject("messageHandlers") as MessageHandlers;
		var interceptors:MessageInterceptors = context.getObject("messageInterceptors") as MessageInterceptors;
				
		source.dispatchEvent(new TestEvent(TestEvent.TEST1, "foo1", 7));
		source.dispatchEvent(new TestEvent(TestEvent.TEST2, "foo2", 9));
		source.dispatchEvent(new Event("foo"));
		
		assertThat(handlers.test1Count, equalTo(2));
		assertThat(handlers.test2Count, equalTo(0));
		assertThat(handlers.genericEventCount, equalTo(2));
		assertThat(handlers.stringProp, equalTo("foo1"));
		assertThat(handlers.intProp, equalTo(7));
		
		assertThat(interceptors.test1Count, equalTo(2));
		assertThat(interceptors.test2Count, equalTo(1));
		
		interceptors.proceedEvent2();
		
		assertThat(handlers.test1Count, equalTo(2));
		assertThat(handlers.test2Count, equalTo(2));
		assertThat(handlers.genericEventCount, equalTo(3));
		assertThat(handlers.stringProp, equalTo("foo2"));
		assertThat(handlers.intProp, equalTo(9));
		
		assertThat(interceptors.test1Count, equalTo(2));
		assertThat(interceptors.test2Count, equalTo(2));
	}
	
	[Test]
	public function errorHandlers () : void {
		var source:EventSource = context.getObject("eventSource") as EventSource;
		context.getObjectByType(FaultyMessageHandlers); // must fetch explicitly - it's lazy
		var handlers:ErrorHandlers = context.getObjectByType(ErrorHandlers) as ErrorHandlers;
		source.dispatchEvent(new TestEvent(TestEvent.TEST1, "foo1", 7));
		source.dispatchEvent(new TestEvent(TestEvent.TEST2, "foo2", 9));
		source.dispatchEvent(new Event("foo"));
		
		assertThat(handlers.getCount(), equalTo(15));
		assertThat(handlers.getCount(TestEvent), equalTo(14));
		assertThat(handlers.getCount(TestEvent, TestEvent.TEST1), equalTo(1));
		assertThat(handlers.getCount(TestEvent, TestEvent.TEST2), equalTo(1));
	}
	
	[Test]
	public function messageDispatcher () : void {
		var dispatcher:TestMessageDispatcher = context.getObject("testDispatcher") as TestMessageDispatcher;
		var handlers:TestMessageHandlers;
		if (lazy) handlers = context.getObject("testMessageHandlers") as TestMessageHandlers; 
		var m1:TestMessage = new TestMessage();
		m1.name = TestEvent.TEST1;
		m1.value = 3;
		dispatcher.dispatchMessage(m1);
		var m2:TestMessage = new TestMessage();
		m2.name = TestEvent.TEST2;
		m2.value = 5;
		dispatcher.dispatchMessage(m2);
		if (!lazy) handlers = context.getObject("testMessageHandlers") as TestMessageHandlers; 
		
		assertThat(handlers.test1Count, equalTo(2));
		assertThat(handlers.test2Count, equalTo(2));
		assertThat(handlers.sum, equalTo(16));
	}
	
	[Test]
	public function selectorAsClassParamByValue () : void {
		var dispatcher:TestMessageDispatcher = context.getObject("testDispatcher") as TestMessageDispatcher;
		var handlers:SelectorMessageHandlers;
		if (lazy) handlers = context.getObject("selectorMessageHandlers") as SelectorMessageHandlers; 
		var m1:TestMessage = new TestMessage();
		m1.name = TestEvent.TEST1;
		m1.value = 3;
		dispatcher.dispatchMessage(m1, Date);
		var m2:TestMessage = new TestMessage();
		m2.name = TestEvent.TEST2;
		m2.value = 5;
		dispatcher.dispatchMessage(m2, Rectangle);
		if (!lazy) handlers = context.getObject("selectorMessageHandlers") as SelectorMessageHandlers; 
		
		assertThat(handlers.test1Count, equalTo(2));
		assertThat(handlers.test2Count, equalTo(2));
		assertThat(handlers.sum, equalTo(16));
		assertThat(handlers.dateSelector, nullValue());
		assertThat(handlers.rectSelector, nullValue());
	}
	
	[Test]
	public function selectorAsClassParamByInstance () : void {
		var dispatcher:TestMessageDispatcher = context.getObject("testDispatcher") as TestMessageDispatcher;
		var handlers:SelectorMessageHandlers;
		if (lazy) handlers = context.getObject("selectorMessageHandlers") as SelectorMessageHandlers; 
		var m2:TestMessage = new TestMessage();
		m2.name = TestEvent.TEST2;
		m2.value = 5;
		dispatcher.dispatchMessage(m2, new Rectangle());
		var m1:TestMessage = new TestMessage();
		m1.name = TestEvent.TEST1;
		m1.value = 3;
		dispatcher.dispatchMessage(m1, new Date());
		if (!lazy) handlers = context.getObject("selectorMessageHandlers") as SelectorMessageHandlers; 
		
		assertThat(handlers.test1Count, equalTo(2));
		assertThat(handlers.test2Count, equalTo(2));
		assertThat(handlers.sum, equalTo(16));
		assertThat(handlers.dateSelector, notNullValue());
		assertThat(handlers.rectSelector, notNullValue());
	}
	
	[Test]
	public function dispatcherInDynamicObject () : void {
		var handlers:TestMessageHandlers = context.getObject("testMessageHandlers") as TestMessageHandlers; 
		dispatchMessage(context);
		dispatchMessage(context);
		assertThat(handlers.test1Count, equalTo(4));
	}
	
	private function dispatchMessage (context:Context) : void {
		var dynObject:DynamicObject = context.createDynamicObject("testDispatcher");
		var dispatcher1:TestMessageDispatcher = dynObject.instance as TestMessageDispatcher;
		var msg:TestMessage = new TestMessage();
		msg.name = TestEvent.TEST1;
		dispatcher1.dispatchMessage(msg);
		dynObject.remove();
	}
	
	
	[Test]
	public function unregisterManagedEvents () : void {
		var source1:EventSource = context.getObject("eventSource2") as EventSource;
		var source2:EventSource = context.getObject("eventSource2") as EventSource;
		var handlers:MessageHandlers;
		if (lazy) handlers = context.getObject("messageHandlers") as MessageHandlers;
		source1.dispatchEvent(new TestEvent(TestEvent.TEST1, "foo1", 7));
		source1.dispatchEvent(new TestEvent(TestEvent.TEST2, "foo2", 9));
		source2.dispatchEvent(new Event("foo"));
		if (!lazy) handlers = context.getObject("messageHandlers") as MessageHandlers;
		context.destroy();
		source2.dispatchEvent(new TestEvent(TestEvent.TEST1, "foo1", 7));
		source1.dispatchEvent(new TestEvent(TestEvent.TEST2, "foo2", 9));
		source1.dispatchEvent(new Event("foo"));
		
		assertThat(handlers.test1Count, equalTo(2));
		assertThat(handlers.test2Count, equalTo(2));
		assertThat(handlers.genericEventCount, equalTo(3));
		assertThat(handlers.stringProp, equalTo("foo2"));
		assertThat(handlers.intProp, equalTo(9));
	}
	
	public function get messagingContext () : Context {
		throw new AbstractMethodError();
	}
	
	
}
}
