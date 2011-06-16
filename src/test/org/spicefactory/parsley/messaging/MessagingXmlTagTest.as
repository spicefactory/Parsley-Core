package org.spicefactory.parsley.messaging {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.util.XmlContextUtil;

/**
 * @author Jens Halm
 */
public class MessagingXmlTagTest extends MessagingTestBase {
	
	
	function MessagingXmlTagTest () {
		super(true);
	}
	
	[BeforeClass]
	public static function clearReflectionCache () : void {
		ClassInfo.cache.purgeAll();
	}
	
	public override function get messagingContext () : Context {
		return XmlContextUtil.newContext(config);
	}
	
	public static const config:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley">
		
		<object id="eventSource" type="org.spicefactory.parsley.messaging.model.EventSource" lazy="true">
			<managed-events names="test1, test2, foo"/>
		</object> 
		
		<dynamic-object id="eventSource2" type="org.spicefactory.parsley.messaging.model.EventSource">
			<managed-events names="test1, test2, foo"/>
		</object> 
		
		<dynamic-object id="testDispatcher" type="org.spicefactory.parsley.messaging.model.TestMessageDispatcher">
			<message-dispatcher property="dispatcher"/>
		</dynamic-object> 
	
		<dynamic-object id="testMessageHandlers" type="org.spicefactory.parsley.messaging.model.TestMessageHandlers">
			<message-handler method="allTestMessages" type="org.spicefactory.parsley.messaging.messages.TestMessage"/>
			<message-handler method="event1" selector="test1" type="org.spicefactory.parsley.messaging.messages.TestMessage"/>
			<message-handler method="event2" selector="test2" type="org.spicefactory.parsley.messaging.messages.TestMessage"/>
		</dynamic-object> 
		
		<dynamic-object id="selectorMessageHandlers" type="org.spicefactory.parsley.messaging.model.SelectorMessageHandlers">
			<message-handler method="allTestMessages" type="org.spicefactory.parsley.messaging.messages.TestMessage"/>
			<message-handler method="event1" type="org.spicefactory.parsley.messaging.messages.TestMessage"/>
			<message-handler method="event2" type="org.spicefactory.parsley.messaging.messages.TestMessage"/>
		</dynamic-object> 
		
		<dynamic-object id="messageHandlers" type="org.spicefactory.parsley.messaging.model.MessageHandlers">
			<message-handler method="allTestEvents" type="org.spicefactory.parsley.messaging.messages.TestEvent" order="3"/>
			<message-handler method="allEvents" type="flash.events.Event" order="2"/>
			<message-handler method="event1" selector="test1" type="org.spicefactory.parsley.messaging.messages.TestEvent" order="1"/>
			<message-handler method="event2" selector="test2" type="org.spicefactory.parsley.messaging.messages.TestEvent" order="1"/>
			<message-handler method="mappedProperties" message-properties="stringProp,intProp" type="org.spicefactory.parsley.messaging.messages.TestEvent"/>
		</dynamic-object>
		
		<dynamic-object id="faultyHandlers" type="org.spicefactory.parsley.messaging.model.FaultyMessageHandlers">
			<message-handler method="allTestEvents" type="org.spicefactory.parsley.messaging.messages.TestEvent"/>
			<message-handler method="allEvents" type="flash.events.Event"/>
			<message-handler method="event1" selector="test1" type="org.spicefactory.parsley.messaging.messages.TestEvent"/>
			<message-handler method="event2" selector="test2" type="org.spicefactory.parsley.messaging.messages.TestEvent"/>
		</dynamic-object>
		
		<object id="errorHandlers" type="org.spicefactory.parsley.messaging.model.ErrorHandlers">
			<message-error method="allTestEvents" type="org.spicefactory.parsley.messaging.messages.TestEvent"/>
			<message-error method="allEvents" type="flash.events.Event"/>
			<message-error method="event1" selector="test1" type="org.spicefactory.parsley.messaging.messages.TestEvent"/>
			<message-error method="event2" selector="test2" type="org.spicefactory.parsley.messaging.messages.TestEvent"/>
		</object>
	
		<dynamic-object id="messageBindings" type="org.spicefactory.parsley.messaging.model.MessageBindingsBlank">
			<message-binding target-property="stringProp" message-property="stringProp" type="org.spicefactory.parsley.messaging.messages.TestEvent"/>
			<message-binding target-property="intProp1" message-property="intProp" selector="test1" type="org.spicefactory.parsley.messaging.messages.TestEvent"/>
			<message-binding target-property="intProp2" message-property="intProp" selector="test2" type="org.spicefactory.parsley.messaging.messages.TestEvent"/>
		</dynamic-object> 
	
		<dynamic-object id="messageInterceptors" type="org.spicefactory.parsley.messaging.model.MessageInterceptors">
			<message-handler method="interceptAllMessages" type="org.spicefactory.parsley.messaging.messages.TestEvent"/>
			<message-handler method="allEvents"/>
			<message-handler method="event1" selector="test1" type="org.spicefactory.parsley.messaging.messages.TestEvent" order="-1"/>
			<message-handler method="event2" selector="test2" type="org.spicefactory.parsley.messaging.messages.TestEvent" order="-1"/>
		</dynamic-object> 	
	</objects>;

	
}
}
