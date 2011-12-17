package org.spicefactory.parsley.command {

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.xml.XmlConfig;

/**
 * @author Jens Halm
 */
public class MapCommandXmlTagTest extends MapCommandTagTestBase {
	
	
	[BeforeClass]
	public static function prepareFactory () : void {
		ClassInfo.cache.purgeAll();
	}
	
	
	public override function get commandSequenceConfig () : ConfigurationProcessor {
		var config: XML = <objects 
			xmlns="http://www.spicefactory.org/parsley">
			
			<map-command message-type="org.spicefactory.parsley.command.trigger.TriggerA">
				<command-sequence>
					<command type="org.spicefactory.parsley.command.target.AsyncCommandWithTrigger">
						<property name="result" value="1"/>
					</command>
					<command type="org.spicefactory.parsley.command.target.AsyncCommandWithTrigger">
						<property name="result" value="2"/>
					</command>
				</command-sequence>
			</map-command>
			
		</objects>;	
		return XmlConfig.forInstance(config);
	}
	
	public override function get parallelCommandsConfig () : ConfigurationProcessor {
		var config: XML = <objects 
			xmlns="http://www.spicefactory.org/parsley">
			
			<command-factory id="ref">
				<command type="org.spicefactory.parsley.command.target.AsyncCommandWithTrigger">
					<property name="result" value="1"/>
				</command>
			</command-factory>
			
			<map-command message-type="org.spicefactory.parsley.command.trigger.TriggerA">
				<parallel-commands>
					<command-ref id-ref="ref"/>
					<command type="org.spicefactory.parsley.command.target.AsyncCommandWithTrigger">
						<property name="result" value="2"/>
					</command>
				</parallel-commands>
			</map-command>
			
		</objects>;	
		return XmlConfig.forInstance(config);
	}
	
	public override function get commandFlowConfig () : ConfigurationProcessor {
		var config: XML = <objects 
			xmlns="http://www.spicefactory.org/parsley">
			
			<map-command message-type="org.spicefactory.parsley.command.trigger.TriggerA">
				<command-flow>
					<command type="org.spicefactory.parsley.command.target.AsyncCommandWithTrigger">
						<property name="result" value="1"/>
						<link-result-value value="1" to="second"/>
					</command>
					<command id="second" type="org.spicefactory.parsley.command.target.AsyncCommandWithTrigger">
						<property name="result" value="2"/>
					</command>
				</command-flow>
			</map-command>
			
		</objects>;	
		return XmlConfig.forInstance(config);
	}
	
	public override function get singleCommandConfig () : ConfigurationProcessor {
		var config: XML = <objects 
			xmlns="http://www.spicefactory.org/parsley">
			
			<map-command 
				type="org.spicefactory.parsley.command.target.AsyncCommandWithTrigger" 
			/>
			
		</objects>;	
		return XmlConfig.forInstance(config);
	}
	
	public override function get selectorConfig () : ConfigurationProcessor {
		var config: XML = <objects 
			xmlns="http://www.spicefactory.org/parsley">
			
			<map-command 
				type="org.spicefactory.parsley.command.target.AsyncCommandWithTrigger" selector="selector"
			/>
			
		</objects>;	
		return XmlConfig.forInstance(config);
	}
	
	public override function get localScopeConfig () : ConfigurationProcessor {
		var config: XML = <objects 
			xmlns="http://www.spicefactory.org/parsley">
			
			<map-command 
				type="org.spicefactory.parsley.command.target.AsyncCommandWithTrigger" scope="local"
			/>
			
		</objects>;	
		return XmlConfig.forInstance(config);
	}
	
	public override function get orderConfig () : ConfigurationProcessor {
		var config: XML = <objects 
			xmlns="http://www.spicefactory.org/parsley">
			
			<map-command message-type="org.spicefactory.parsley.command.trigger.TriggerA" order="2">
				<command type="org.spicefactory.parsley.command.target.SyncCommand">
					<property name="result" value="2"/>
				</command>
			</map-command>
			
			<map-command message-type="org.spicefactory.parsley.command.trigger.TriggerA" order="1">
				<command type="org.spicefactory.parsley.command.target.SyncCommand">
					<property name="result" value="1"/>
				</command>
			</map-command>
			
		</objects>;	
		return XmlConfig.forInstance(config);
	}
			
	public override function get observerConfig () : ConfigurationProcessor {
		var config: XML = <objects 
			xmlns="http://www.spicefactory.org/parsley">
			
			<object id="commandObservers" type="org.spicefactory.parsley.command.observer.CommandObservers">
				<command-complete method="completeA"/>
				<command-complete method="completeB"/>
				<command-complete method="complete"/>
				<command-result method="resultA"/>
				<command-result method="resultB"/>
				<command-result method="result"/>
				<command-error method="error"/>
			</object> 
			
			<object id="commandStatusFlags" type="org.spicefactory.parsley.command.observer.CommandStatusFlags">
				<command-status property="trigger" type="org.spicefactory.parsley.command.trigger.Trigger"/>
				<command-status property="triggerA" type="org.spicefactory.parsley.command.trigger.TriggerA"/>
				<command-status property="triggerB" type="org.spicefactory.parsley.command.trigger.TriggerB"/>
			</object> 
			
		</objects>;	
		return XmlConfig.forInstance(config);
	}
	
	
}
}
