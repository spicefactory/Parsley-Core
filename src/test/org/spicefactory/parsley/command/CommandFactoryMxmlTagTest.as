package org.spicefactory.parsley.command {

import org.spicefactory.parsley.command.config.CommandFlowFactory;
import org.spicefactory.parsley.command.config.CommandObserverConfig;
import org.spicefactory.parsley.command.config.CommandSequenceFactory;
import org.spicefactory.parsley.command.config.LinkAllResultsConfig;
import org.spicefactory.parsley.command.config.LinkResultPropertyConfig;
import org.spicefactory.parsley.command.config.LinkResultTypeConfig;
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
	
	protected override function get linkResultTypeConfig (): ConfigurationProcessor {
		return FlexConfig.forClass(LinkResultTypeConfig);
	}
	
	protected override function get linkResultPropertyConfig (): ConfigurationProcessor {
		return FlexConfig.forClass(LinkResultPropertyConfig);
	}
	
	protected override function get linkAllResultsConfig (): ConfigurationProcessor {
		return FlexConfig.forClass(LinkAllResultsConfig);
	}
	
	public override function get singleCommandConfig () : ConfigurationProcessor {
		return FlexConfig.forClass(SingleCommandFactory);
	}
	
	public override function get observerConfig () : ConfigurationProcessor {
		return FlexConfig.forClass(CommandObserverConfig);
	}
		
	
}
}
