package org.spicefactory.parsley.lifecycle.asyncinit.config {
import org.spicefactory.parsley.lifecycle.asyncinit.model.AsyncInitModelMetadataOrder1;
import org.spicefactory.parsley.lifecycle.asyncinit.model.AsyncInitModelMetadataOrder2;
import org.spicefactory.parsley.lifecycle.asyncinit.model.SyncModel;

/**
 * @author Jens Halm
 */
public class AsyncInitOrderedConfig {

	
	[ObjectDefinition(order="1")]
	public function get asyncInitModel1 () : AsyncInitModelMetadataOrder1 {
		return new AsyncInitModelMetadataOrder1();
	}
	
	[ObjectDefinition(order="2")]
	public function get asyncInitModel2 () : AsyncInitModelMetadataOrder2 {
		return new AsyncInitModelMetadataOrder2();
	}
	
	public function get asyncInitModel3 () : AsyncInitModelMetadataOrder1 {
		return new AsyncInitModelMetadataOrder1();
	}
	
	public function get syncModel () : SyncModel {
		return new SyncModel();
	}
	
	
}
}
