package org.spicefactory.parsley.context.dynobjects {

	import org.spicefactory.parsley.context.dynobjects.model.DynamicTestDependency;
/**
 * @author Jens Halm
 */
public class DynamicConfig {
	
	
	public function get dependency () : DynamicTestDependency {
		return new DynamicTestDependency();
	}
	
	
}
}
