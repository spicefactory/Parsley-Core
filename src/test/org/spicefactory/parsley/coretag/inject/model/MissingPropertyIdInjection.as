package org.spicefactory.parsley.coretag.inject.model {

/**
 * @author Jens Halm
 */
public class MissingPropertyIdInjection {
	
	
	[Inject(id="missingId")]
	public var dependency:MissingDependency;
	
	
}
}
