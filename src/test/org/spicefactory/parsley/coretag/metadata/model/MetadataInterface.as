package org.spicefactory.parsley.coretag.metadata.model {

[InjectConstructor]
/**
 * @author Jens Halm
 */
public interface MetadataInterface {
	
	[Inject]
	function get prop2 () : String;
	
	[Inject]
	function get prop3 () : String;
	
	
	[Inject]
	function method2 () : void;
	
	[Inject]
	function method3 () : void;
	
}
}
