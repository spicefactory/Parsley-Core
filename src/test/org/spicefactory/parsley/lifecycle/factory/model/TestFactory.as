package org.spicefactory.parsley.lifecycle.factory.model {
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.parsley.coretag.inject.model.InjectedDependency;
import org.spicefactory.parsley.coretag.inject.model.RequiredMethodInjection;

/**
 * @author Jens Halm
 */
public class TestFactory {
	
	
	[Inject]
	public var dependency:InjectedDependency;
	
	
	public function createInstance () : RequiredMethodInjection {
		if (dependency == null) {
			throw new IllegalStateError("Dependency not injected");
		}
		return new RequiredMethodInjection();
	}
	
	
}
}
