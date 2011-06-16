package org.spicefactory.parsley.lifecycle.asyncinit.config {
import org.spicefactory.parsley.lifecycle.asyncinit.model.AsyncInitModelMetadata;

/**
 * @author Jens Halm
 */
public class AsyncInitConfig {
	
	
	public function get asyncInitModel () : AsyncInitModelMetadata {
		return new AsyncInitModelMetadata();
	}
	
	
}
}
