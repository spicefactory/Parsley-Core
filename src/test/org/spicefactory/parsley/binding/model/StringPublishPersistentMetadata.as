package org.spicefactory.parsley.binding.model {

/**
 * @author Jens Halm
 */
public class StringPublishPersistentMetadata {


	[Bindable][PublishSubscribe(persistent="true", scope="local", objectId="test")]
	public var value:String;
	
	
}
}
