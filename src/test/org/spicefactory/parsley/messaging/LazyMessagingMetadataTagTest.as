package org.spicefactory.parsley.messaging {
	import org.spicefactory.parsley.messaging.config.LazyMessagingAsConfig;
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;

/**
 * @author Jens Halm
 */
public class LazyMessagingMetadataTagTest extends MessagingTestBase {
	
	
	function LazyMessagingMetadataTagTest () {
		super(true);
	}
	
	
	public override function get messagingContext () : Context {
		return ActionScriptContextBuilder.build(LazyMessagingAsConfig);
	}
	
	
}
}
