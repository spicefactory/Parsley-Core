package org.spicefactory.parsley.lifecycle.factory.config {
import org.spicefactory.parsley.coretag.inject.model.InjectedDependency;
import org.spicefactory.parsley.lifecycle.factory.model.TestFactoryMetadata;

/**
 * @author Jens Halm
 */
public class FactoryMethodAsConfig {
	

	public function get injectedDependency () : InjectedDependency {
		return new InjectedDependency();
	}
	
	[ObjectDefinition(lazy="true")] 
	public function get factoryWithDependency () : TestFactoryMetadata {
		return new TestFactoryMetadata();
	}

	
}
}
