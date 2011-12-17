package org.spicefactory.parsley.command {

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.xml.XmlConfig;

/**
 * @author Jens Halm
 */
public class CommandFactoryXmlTagTest extends CommandFactoryTagTestBase {
	
	
	[BeforeClass]
	public static function prepareFactory () : void {
		ClassInfo.cache.purgeAll();
	}
	
	
	public override function get commandSequenceConfig () : ConfigurationProcessor {
		var config: XML = <objects 
			xmlns="http://www.spicefactory.org/parsley">
			
			<command-factory>
				<command-sequence>
					<command type="org.spicefactory.parsley.command.target.AsyncCommand">
						<property name="result" value="1"/>
					</command>
					<command type="org.spicefactory.parsley.command.target.AsyncCommand">
						<property name="result" value="2"/>
					</command>
				</command-sequence>
			</command-factory>
			
		</objects>;	
		return XmlConfig.forInstance(config);
	}
	
	public override function get parallelCommandsConfig () : ConfigurationProcessor {
		var config: XML = <objects 
			xmlns="http://www.spicefactory.org/parsley">
			
			<command-factory>
				<parallel-commands>
					<command type="org.spicefactory.parsley.command.target.AsyncCommand">
						<property name="result" value="1"/>
					</command>
					<command type="org.spicefactory.parsley.command.target.AsyncCommand">
						<property name="result" value="2"/>
					</command>
				</parallel-commands>
			</command-factory>
			
		</objects>;	
		return XmlConfig.forInstance(config);
	}
	
	public override function get commandFlowConfig () : ConfigurationProcessor {
		var config: XML = <objects 
			xmlns="http://www.spicefactory.org/parsley">
			
			<command-factory>
				<command-flow>
					<command type="org.spicefactory.parsley.command.target.AsyncCommand">
						<property name="result" value="1"/>
						<link-result-value value="1" to="second"/>
					</command>
					<command id="second" type="org.spicefactory.parsley.command.target.AsyncCommand">
						<property name="result" value="2"/>
					</command>
				</command-flow>
			</command-factory>
			
		</objects>;	
		return XmlConfig.forInstance(config);
	}
	
	protected override function get linkResultTypeConfig () : ConfigurationProcessor {
		var config: XML = <objects 
			xmlns="http://www.spicefactory.org/parsley">
			
			<command-factory>
				<command-flow>
					<command type="org.spicefactory.parsley.command.target.AsyncCommand">
						<property name="result" value="foo"/>
						<link-result-type type="String" to="second"/>
					</command>
					<command id="second" type="org.spicefactory.parsley.command.target.AsyncCommand">
						<property name="result" value="2"/>
					</command>
				</command-flow>
			</command-factory>
			
		</objects>;	
		return XmlConfig.forInstance(config);
	}
	
	protected override function get linkResultPropertyConfig () : ConfigurationProcessor {
		var config: XML = <objects 
			xmlns="http://www.spicefactory.org/parsley">
			
			<command-factory>
				<command-flow>
					<command type="org.spicefactory.parsley.command.target.AsyncCommandWithWrappedResult">
						<property name="result" value="1"/>
						<link-result-property name="property" value="1" to="second"/>
					</command>
					<command id="second" type="org.spicefactory.parsley.command.target.AsyncCommand">
						<property name="result" value="2"/>
					</command>
				</command-flow>
			</command-factory>
			
		</objects>;	
		return XmlConfig.forInstance(config);
	}
	
	protected override function get linkAllResultsConfig () : ConfigurationProcessor {
		var config: XML = <objects 
			xmlns="http://www.spicefactory.org/parsley">
			
			<command-factory>
				<command-flow>
					<command type="org.spicefactory.parsley.command.target.AsyncCommand">
						<property name="result" value="irrelevant"/>
						<link-all-results to="second"/>
					</command>
					<command id="second" type="org.spicefactory.parsley.command.target.AsyncCommand">
						<property name="result" value="2"/>
					</command>
				</command-flow>
			</command-factory>
			
		</objects>;	
		return XmlConfig.forInstance(config);
	}
	
	public override function get singleCommandConfig () : ConfigurationProcessor {
		var config: XML = <objects 
			xmlns="http://www.spicefactory.org/parsley">
			
			<command-factory> 
				<command type="org.spicefactory.parsley.command.target.AsyncCommand" /> 
			</command-factory>
			
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
