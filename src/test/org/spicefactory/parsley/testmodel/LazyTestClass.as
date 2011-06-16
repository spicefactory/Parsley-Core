package org.spicefactory.parsley.testmodel {

/**
 * @author Jens Halm
 */
public class LazyTestClass {
	
	
	public static var instanceCount:int = 0;
	
	
	function LazyTestClass () {
		instanceCount++;
	}
	
	
}
}
