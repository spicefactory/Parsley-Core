package org.spicefactory.parsley.coretag.inject.model {

/**
 * @author Jens Halm
 */
public class OptionalPropertyInjection {
	
	
	[Inject(required="false")]
	public var dependency:MissingDependency;
	
	
}
}
