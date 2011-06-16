package org.spicefactory.parsley.messaging.proxy.config {

import org.spicefactory.parsley.messaging.proxy.model.MessageHandlerReceiver;
import org.spicefactory.parsley.messaging.proxy.model.Sender;
/**
 * @author Jens Halm
 */
public class MessageProxyConfig {
	
	
	[ObjectDefinition(order="1")]
	public function get sender () : Sender {
		return new Sender();
	}
	
	[ObjectDefinition(order="2")]
	public function get receiver () : MessageHandlerReceiver {
		return new MessageHandlerReceiver();
	}
	
	
}
}
