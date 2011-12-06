package org.spicefactory.parsley.binding {

import org.spicefactory.parsley.binding.impl.PropertyPublisher;
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.flex.binding.FlexPropertyWatcher;
import org.spicefactory.parsley.util.XmlContextUtil;
import org.spicefactory.parsley.xml.XmlConfig;

/**
 * @author Jens Halm
 */
public class BindingXmlTagTest extends BindingTestBase {
	
	
	[BeforeClass]
	public static function setPropertyWatcherType (): void {
		PropertyPublisher.propertyWatcherType = FlexPropertyWatcher;
	}
	
	protected override function get bindingContext () : Context {
		return XmlContextUtil.newContext(config);
	}
	
	protected override function addConfig (conf:BootstrapConfig) : void {
		conf.addProcessor(XmlConfig.forInstance(config));
	}
	
	public static const config:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley">
		
		<dynamic-object id="publish" type="org.spicefactory.parsley.binding.model.CatHolder">
			<publish property="value"/>
		</dynamic-object> 
		
		<dynamic-object id="publishId" type="org.spicefactory.parsley.binding.model.CatHolder">
			<publish property="value" object-id="cat"/>
		</dynamic-object>
		
		<dynamic-object id="publishLocal" type="org.spicefactory.parsley.binding.model.CatHolder">
			<publish property="value" scope="local"/>
		</dynamic-object> 
		
		<dynamic-object id="publishManaged" type="org.spicefactory.parsley.binding.model.CatHolder">
			<publish property="value" managed="true" scope="local"/>
		</dynamic-object> 
		
		<dynamic-object id="publishPersistent" type="org.spicefactory.parsley.binding.model.StringHolder">
			<publish-subscribe persistent="true" property="value" scope="local" object-id="test"/>
		</dynamic-object> 
		
		<dynamic-object id="subscribe" type="org.spicefactory.parsley.binding.model.CatHolder">
			<subscribe property="value"/>
		</dynamic-object> 
		
		<dynamic-object id="subscribeId" type="org.spicefactory.parsley.binding.model.CatHolder">
			<subscribe property="value" object-id="cat"/>
		</dynamic-object> 
		
		<dynamic-object id="subscribeLocal" type="org.spicefactory.parsley.binding.model.CatHolder">
			<subscribe property="value" scope="local"/>
		</dynamic-object> 
		
		<dynamic-object id="animalSubscribe" type="org.spicefactory.parsley.binding.model.AnimalHolder">
			<subscribe property="value"/>
		</dynamic-object> 
		
		<dynamic-object id="pubsub" type="org.spicefactory.parsley.binding.model.CatHolder">
			<publish-subscribe property="value"/>
		</dynamic-object>
		
	</objects>;	
}
}
