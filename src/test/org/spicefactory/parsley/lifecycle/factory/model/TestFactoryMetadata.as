package org.spicefactory.parsley.lifecycle.factory.model {
import org.spicefactory.parsley.coretag.inject.model.RequiredMethodInjection;

/**
 * @author Jens Halm
 */
public class TestFactoryMetadata extends TestFactory {
	
	
	[Factory]
	public override function createInstance () : RequiredMethodInjection {
		return super.createInstance();
	}
	
	
}
}
