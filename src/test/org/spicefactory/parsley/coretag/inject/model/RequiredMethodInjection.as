package org.spicefactory.parsley.coretag.inject.model {

/**
 * @author Jens Halm
 */
public class RequiredMethodInjection {
	
	
	private var _dependency:InjectedDependency;
	
	
	[Inject]
	public function requiredMethodInjection (dep:InjectedDependency) : void {
		_dependency = dep;
	}


	public function get dependency () : InjectedDependency {
		return _dependency;
	}
	
	
}
}
