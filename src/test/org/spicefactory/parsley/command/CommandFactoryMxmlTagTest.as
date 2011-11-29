package org.spicefactory.parsley.command {

import org.spicefactory.parsley.command.config.CommandFlowFactory;
import org.spicefactory.parsley.command.config.CommandObserverConfig;
import org.spicefactory.parsley.command.config.CommandSequenceFactory;
import org.spicefactory.parsley.command.config.ParallelCommandsFactory;
import org.spicefactory.parsley.command.config.SingleCommandFactory;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.flex.FlexConfig;

/**
 * @author Jens Halm
 */
public class CommandFactoryMxmlTagTest extends CommandFactoryTagTestBase {
	
	
	public override function get commandSequenceConfig () : ConfigurationProcessor {
		return FlexConfig.forClass(CommandSequenceFactory);
	}
	
	public override function get parallelCommandsConfig () : ConfigurationProcessor {
		return FlexConfig.forClass(ParallelCommandsFactory);
	}
	
	public override function get commandFlowConfig () : ConfigurationProcessor {
		return FlexConfig.forClass(CommandFlowFactory);
	}
	
	public override function get singleCommandConfig () : ConfigurationProcessor {
		return FlexConfig.forClass(SingleCommandFactory);
	}
	
	public override function get observerConfig () : ConfigurationProcessor {
		return FlexConfig.forClass(CommandObserverConfig);
	}
		
	
}
}
