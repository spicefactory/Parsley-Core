package org.spicefactory.parsley.coretag.metadata.model {

[InjectConstructor]
/**
 * @author Jens Halm
 */
public class MetadataSuperclass {
	
	
	[Inject]
	public var prop1:String;
	
	[Inject]
	public function get prop2 () : String {
		return "";
	}
	
	[Inject]
	public function get prop3 () : String {
		return "";
	}
	
	
	[Inject]
	public function method1 () : void {
		
	}
	
	[Inject]
	public function method2 () : void {
		
	}
	
	[Inject]
	public function method3 () : void {
		
	}
	
	
}
}
