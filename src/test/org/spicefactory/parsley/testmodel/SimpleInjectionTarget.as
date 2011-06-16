package org.spicefactory.parsley.testmodel {
import org.spicefactory.parsley.coretag.inject.model.InjectedDependency;

/**
 * @author Jens Halm
 */
public class SimpleInjectionTarget {
	
	
	public var fromConstructor:InjectedDependency;
	
	public var fromMethod:InjectedDependency;
	
	public var fromProperty:InjectedDependency;
	
	
	function SimpleInjectionTarget (fromConstructor:InjectedDependency) {
		this.fromConstructor = fromConstructor;
	}
	
	public function init (fromMethod:InjectedDependency) : void {
		this.fromMethod = fromMethod;
	}
	
	
}
}
