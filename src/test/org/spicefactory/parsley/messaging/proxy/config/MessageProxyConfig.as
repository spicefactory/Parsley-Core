package org.spicefactory.parsley.messaging.proxy.config {

	import org.spicefactory.parsley.messaging.proxy.model.Sender;
	import org.spicefactory.parsley.messaging.proxy.model.CommandReceiver;
	import org.spicefactory.parsley.messaging.proxy.model.MessageHandlerReceiver;
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
	
	[ObjectDefinition(order="2")]
	public function get commandReceiver () : CommandReceiver {
		return new CommandReceiver();
	}
	
	
}
}
