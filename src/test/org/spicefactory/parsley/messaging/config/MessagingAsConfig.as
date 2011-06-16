package org.spicefactory.parsley.messaging.config {

import org.spicefactory.parsley.messaging.model.ErrorHandlersMetadata;
import org.spicefactory.parsley.messaging.model.EventSourceMetadata;
import org.spicefactory.parsley.messaging.model.FaultyMessageHandlersMetadata;
import org.spicefactory.parsley.messaging.model.MessageBindingsMetadata;
import org.spicefactory.parsley.messaging.model.MessageHandlersMetadata;
import org.spicefactory.parsley.messaging.model.MessageInterceptorsMetadata;
import org.spicefactory.parsley.messaging.model.SelectorMessageHandlersMetadata;
import org.spicefactory.parsley.messaging.model.TestMessageDispatcherMetadata;
import org.spicefactory.parsley.messaging.model.TestMessageHandlersMetadata;

/**
 * @author Jens Halm
 */
public class MessagingAsConfig {
	

	public function get eventSource () : EventSourceMetadata {
		return new EventSourceMetadata();
	}
	
	[DynamicObject]
	public function get eventSource2 () : EventSourceMetadata {
		return new EventSourceMetadata();
	}
	
	[DynamicObject]
	public function get testDispatcher () : TestMessageDispatcherMetadata {
		return new TestMessageDispatcherMetadata();
	}
	
	public function get testMessageHandlers () : TestMessageHandlersMetadata {
		return new TestMessageHandlersMetadata();
	}
	
	public function get selectorMessageHandlers () : SelectorMessageHandlersMetadata {
		return new SelectorMessageHandlersMetadata();
	}
	
	public function get messageHandlers () : MessageHandlersMetadata {
		return new MessageHandlersMetadata();
	}
	
	[DynamicObject]
	public function get faultyHandlers () : FaultyMessageHandlersMetadata {
		return new FaultyMessageHandlersMetadata();
	}
	
	public function get errorHandlers () : ErrorHandlersMetadata {
		return new ErrorHandlersMetadata();
	}
	
	public function get messageBindings () : MessageBindingsMetadata {
		return new MessageBindingsMetadata();
	}
	
	[DynamicObject]
	public function get messageInterceptors () : MessageInterceptorsMetadata {
		return new MessageInterceptorsMetadata();
	}
	
	
}
}
