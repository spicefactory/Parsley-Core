package org.spicefactory.parsley.messaging.model {
import flash.events.EventDispatcher;

[Event(name="test1",type="org.spicefactory.parsley.messaging.messages.TestEvent")]
[Event(name="test2",type="org.spicefactory.parsley.messaging.messages.TestEvent")]
[Event(name="foo",type="flash.events.Event")]
/**
 * @author Jens Halm
 */
public class EventSource extends EventDispatcher {
}
}
