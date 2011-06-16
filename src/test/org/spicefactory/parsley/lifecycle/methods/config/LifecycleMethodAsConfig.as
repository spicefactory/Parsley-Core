package org.spicefactory.parsley.lifecycle.methods.config {
import org.spicefactory.parsley.lifecycle.methods.model.DestroyMetadata;
import org.spicefactory.parsley.lifecycle.methods.model.InitMetadata;

/**
 * @author Jens Halm
 */
public class LifecycleMethodAsConfig {
	
	

	[ObjectDefinition(lazy="true")]
	public function get destroyModel () : DestroyMetadata {
		return new DestroyMetadata();
	}

	[ObjectDefinition(lazy="true")]
	public function get initModel () : InitMetadata {
		return new InitMetadata();
	}
	
	
}
}
