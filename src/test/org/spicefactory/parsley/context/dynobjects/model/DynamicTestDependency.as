package org.spicefactory.parsley.context.dynobjects.model {
import org.spicefactory.parsley.util.MessageReceiverBase;

/**
 * @author Jens Halm
 */
public class DynamicTestDependency extends MessageReceiverBase {
	
	public var destroyMethodCalled:Boolean = false;
	
	[Destroy]	
	public function destroy () : void {
		destroyMethodCalled = true;
	}
	
}
}
