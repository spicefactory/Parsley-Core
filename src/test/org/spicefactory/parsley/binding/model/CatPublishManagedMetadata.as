package org.spicefactory.parsley.binding.model {

/**
 * @author Jens Halm
 */
public class CatPublishManagedMetadata {


	[Bindable][Publish(managed="true", scope="local")]
	public var value:Cat;
	
	
}
}
