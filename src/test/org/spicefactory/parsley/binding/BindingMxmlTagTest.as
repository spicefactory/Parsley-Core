package org.spicefactory.parsley.binding {

import org.spicefactory.parsley.binding.config.BindingMxmlConfig;
import org.spicefactory.parsley.binding.impl.PropertyPublisher;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.flex.FlexConfig;
import org.spicefactory.parsley.flex.FlexContextBuilder;
import org.spicefactory.parsley.flex.binding.FlexPropertyWatcher;

/**
 * @author Jens Halm
 */
public class BindingMxmlTagTest extends BindingTestBase {
	
	
	[BeforeClass]
	public static function setPropertyWatcherType (): void {
		PropertyPublisher.propertyWatcherType = FlexPropertyWatcher;
	}
	
	protected override function get bindingContext () : Context {
		return FlexContextBuilder.build(BindingMxmlConfig);
	}
	
	protected override function get bindingConfig () : ConfigurationProcessor {
		return FlexConfig.forClass(BindingMxmlConfig);
	}
	
	
}
}
