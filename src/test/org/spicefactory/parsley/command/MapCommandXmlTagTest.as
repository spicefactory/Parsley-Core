package org.spicefactory.parsley.command {

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.xml.XmlConfig;

/**
 * @author Jens Halm
 */
public class MapCommandXmlTagTest extends MapCommandTestBase {
	
	
	[BeforeClass]
	public static function prepareFactory () : void {
		ClassInfo.cache.purgeAll();
	}
	
	public override function get singleCommandConfig () : ConfigurationProcessor {
		return XmlConfig.forInstance(config);
	}
	
	public override function get observerConfig () : ConfigurationProcessor {
		return XmlConfig.forInstance(config);
	}
	
	public static const config:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley">
		
		<map-command 
			type="org.spicefactory.parsley.command.model.DynamicCommand" 
			message-type="org.spicefactory.parsley.messaging.messages.TestEvent" 
			selector="command1"
		/>

		<map-command 
			type="org.spicefactory.parsley.command.model.DynamicCommand" 
			message-type="org.spicefactory.parsley.messaging.messages.TestEvent" 
			selector="command2" 
			stateful="true" 
			error="errorHandler"
		/>
			
		<map-command 
			type="org.spicefactory.parsley.command.model.DynamicCommand" 
			message-type="org.spicefactory.parsley.messaging.messages.TestEvent" 
			selector="command3"
			>
			<property name="prop" value="9"/>
			<destroy method="destroy"/>
		</dynamic-command>
		
	</objects>;	
}
}
