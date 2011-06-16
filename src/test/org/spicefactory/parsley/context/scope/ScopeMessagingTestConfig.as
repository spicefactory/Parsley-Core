package org.spicefactory.parsley.context.scope {

	import org.spicefactory.parsley.context.scope.model.LocalReceiver;
	import org.spicefactory.parsley.context.scope.model.LocalSender;
	import org.spicefactory.parsley.context.scope.model.GlobalSender;
/**
 * @author Jens Halm
 */
public class ScopeMessagingTestConfig {
	
	
	public function get globalSender () : GlobalSender {
		return new GlobalSender();
	}
	
	public function get localSender () : LocalSender {
		return new LocalSender();
	}
	
	public function get localReceiver () : LocalReceiver {
		return new LocalReceiver();
	}
	
	
}
}
