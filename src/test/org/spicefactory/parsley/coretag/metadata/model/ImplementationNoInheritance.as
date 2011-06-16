package org.spicefactory.parsley.coretag.metadata.model {

/**
 * @author Jens Halm
 */
public class ImplementationNoInheritance implements MetadataInterface {
	
	
	[Inject]
	public function get prop2 () : String {
		return "";
	}
	
	
	public function get prop3 () : String {
		return "";
	}
	
	
	[Inject]
	public function method2 () : void {
		
	}
	
	public function method3 () : void {
		
	}
	
	
}
}
