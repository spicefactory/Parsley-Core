package org.spicefactory.parsley.context.inheritance.model {

/**
 * @author Jens Halm
 */
public class InjectionTarget {
	
	
	[Inject]
	public var byType:StringHolder;
	
	[Inject(id="id1")]
	public var byId1:StringHolder;
	
	[Inject(id="id2")]
	public var byId2:StringHolder;
	
	
}
}
