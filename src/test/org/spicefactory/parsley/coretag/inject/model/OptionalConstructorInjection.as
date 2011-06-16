package org.spicefactory.parsley.coretag.inject.model {

[InjectConstructor]
/**
 * @author Jens Halm
 */
public class OptionalConstructorInjection {
	
	
	private var _dependency:MissingDependency;
	
	
	function OptionalConstructorInjection (dep:MissingDependency = null) {
		_dependency = dep;
	}


	public function get dependency () : MissingDependency {
		return _dependency;
	}
	
	
}
}
