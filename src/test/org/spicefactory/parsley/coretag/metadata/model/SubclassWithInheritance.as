package org.spicefactory.parsley.coretag.metadata.model {

[ProcessSuperclass]
/**
 * @author Jens Halm
 */
public class SubclassWithInheritance extends MetadataSuperclass {
	
	
	[Inject]
	public override function get prop2 () : String {
		return "";
	}
	
	
	public override function get prop3 () : String {
		return "";
	}
	
	
	[Inject]
	public override function method2 () : void {
		
	}
	
	
	public override function method3 () : void {
		
	}
	
	
}
}
