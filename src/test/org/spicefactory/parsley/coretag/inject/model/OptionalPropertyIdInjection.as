package org.spicefactory.parsley.coretag.inject.model {

/**
 * @author Jens Halm
 */
public class OptionalPropertyIdInjection {
	
	
	[Inject(id="missingId", required="false")]
	public var dependency:MissingDependency;
	
	[Inject(id="missingId2", required="false")]
	public var valueWithDefault:String = "foo";
	
	
}
}
