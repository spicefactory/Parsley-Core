package org.spicefactory.parsley.messaging.model {

/**
 * @author Jens Halm
 */
public class MessageBindingsMetadata extends MessageBindings {

	
	[MessageBinding(type="org.spicefactory.parsley.messaging.messages.TestEvent", messageProperty="stringProp")]
	public override function set stringProp (value:String) : void {
		super.stringProp = value;
	}
	
	[MessageBinding(type="org.spicefactory.parsley.messaging.messages.TestEvent", messageProperty="intProp", selector="test1")]
	public var intProp1:int;
	
	[MessageBinding(type="org.spicefactory.parsley.messaging.messages.TestEvent", messageProperty="intProp", selector="test2")]
	public var intProp2:int;

	
}
}
