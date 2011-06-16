package org.spicefactory.parsley.context.scope.model {
import org.spicefactory.parsley.util.MessageCounter;

/**
 * @author Jens Halm
 */
public class CustomScopeReceiver extends MessageCounter {
	
	[MessageHandler(scope="custom")]
	public function handleMessage (message:Object) : void {
		addMessage(message, "custom");
	}
	
	[MessageHandler(scope="local")]
	public function handleLocalMessage (message:Object) : void {
		addMessage(message, "local");
	}
	
	[MessageHandler]
	public function handleGlobalMessage (message:Object) : void {
		addMessage(message, "global");
	}
	
}
}
