package org.spicefactory.parsley.coretag.inject.model {

/**
 * @author Jens Halm
 */
public class OptionalMethodInjection {
	
	
	private var _dependency:MissingDependency;
	
	
	[Inject]
	public function optionalMethodInjection (dep:MissingDependency = null) : void {
		_dependency = dep;
	}


	public function get dependency () : MissingDependency {
		return _dependency;
	}
	
	
}
}
