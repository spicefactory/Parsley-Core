package org.spicefactory.parsley.context.dynobjects.model {
	
import org.spicefactory.parsley.util.MessageReceiverBase;

/**
 * @author Jens Halm
 */
public class AnnotatedDynamicTestObject extends MessageReceiverBase {
	
	
	private var _dependency:DynamicTestDependency;
	
	public function get dependency () : DynamicTestDependency {
		return _dependency;
	}
	
	[Inject]
	public function set dependency (dependency:DynamicTestDependency) : void {
		_dependency = dependency;
	}
	
	[MessageHandler]
	public function handleMessage (message:Object) : void {
		addMessage(message);
	}
	
	
}
}
