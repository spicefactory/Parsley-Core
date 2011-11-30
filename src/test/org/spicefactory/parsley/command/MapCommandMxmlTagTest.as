package org.spicefactory.parsley.command {

import org.spicefactory.parsley.command.config.CommandObserverConfig;
import org.spicefactory.parsley.command.config.LocalScope;
import org.spicefactory.parsley.command.config.MapCommandFlow;
import org.spicefactory.parsley.command.config.MapCommandSequence;
import org.spicefactory.parsley.command.config.MapParallelCommands;
import org.spicefactory.parsley.command.config.MapSingleCommand;
import org.spicefactory.parsley.command.config.OrderConfig;
import org.spicefactory.parsley.command.config.SelectorConfig;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.flex.FlexConfig;

/**
 * @author Jens Halm
 */
public class MapCommandMxmlTagTest extends MapCommandTagTestBase {
	
	
	public override function get commandSequenceConfig () : ConfigurationProcessor {
		return FlexConfig.forClass(MapCommandSequence);
	}
	
	public override function get parallelCommandsConfig () : ConfigurationProcessor {
		return FlexConfig.forClass(MapParallelCommands);
	}
	
	public override function get commandFlowConfig () : ConfigurationProcessor {
		return FlexConfig.forClass(MapCommandFlow);
	}
	
	public override function get singleCommandConfig () : ConfigurationProcessor {
		return FlexConfig.forClass(MapSingleCommand);
	}
	
	public override function get localScopeConfig () : ConfigurationProcessor {
		return FlexConfig.forClass(LocalScope);
	}
	
	public override function get orderConfig () : ConfigurationProcessor {
		return FlexConfig.forClass(OrderConfig);
	}
	
	public override function get selectorConfig () : ConfigurationProcessor {
		return FlexConfig.forClass(SelectorConfig);
	}
	
	public override function get observerConfig () : ConfigurationProcessor {
		return FlexConfig.forClass(CommandObserverConfig);
	}
		
	
}
}
