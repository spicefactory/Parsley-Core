package org.spicefactory.parsley.binding.model {

/**
 * @author Jens Halm
 */
public class CatPublishIdMetadata {

	[Bindable][Publish(objectId="cat")]
	public var value:Cat;
	
	
}
}
