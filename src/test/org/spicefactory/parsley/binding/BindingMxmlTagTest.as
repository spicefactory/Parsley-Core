package org.spicefactory.parsley.binding {
import org.spicefactory.parsley.binding.config.BindingMxmlConfig;
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.flex.FlexConfig;
import org.spicefactory.parsley.flex.FlexContextBuilder;

/**
 * @author Jens Halm
 */
public class BindingMxmlTagTest extends BindingTestBase {
	
	
	protected override function get bindingContext () : Context {
		return FlexContextBuilder.build(BindingMxmlConfig);
	}
	
	protected override function addConfig (conf:BootstrapConfig) : void {
		conf.addProcessor(FlexConfig.forClass(BindingMxmlConfig));
	}

	
}
}
