package org.spicefactory.parsley.coretag.inject.model {

/**
 * @author Jens Halm
 */
public class RequiredPropertyIdInjection {
	
	
	[Inject(id="injectedDependency")]
	public var dependency:InjectedDependency;
	
	
}
}
