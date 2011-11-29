package org.spicefactory.parsley.command {

import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.command.config.CommandFactoryHolder;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.dsl.context.ContextBuilder;

/**
 * @author Jens Halm
 */
public class CommandFactoryTagTestBase extends CommandFactoryTestBase {
	
	
	private var factoryHolder:CommandFactoryHolder = new CommandFactoryHolder();
	
	
	protected override function configureSingleCommand (): void {
		buildContext(singleCommandConfig);
	}
	
	protected override function configureCommandSequence (): void {
		buildContext(commandSequenceConfig);
	}
	
	protected override function configureParallelCommands (): void {
		buildContext(parallelCommandsConfig);
	}
	
	protected override function configureCommandFlow (): void {
		buildContext(commandFlowConfig);
	}
	
	private function buildContext (mapCommandConfig: ConfigurationProcessor) : void {
		try {
		var context: Context = ContextBuilder
			.newBuilder()
			.config(mapCommandConfig)
			.config(observerConfig)
			.object(factoryHolder)
			.build();
		} catch (e: Error) {
			trace(e.getStackTrace());
			throw e;
		}
		setContext(context);
		setProxy(factoryHolder.factory.newInstance());
	}	
	
	public function get singleCommandConfig () : ConfigurationProcessor {
		throw new AbstractMethodError();
	}
	
	public function get commandSequenceConfig () : ConfigurationProcessor {
		throw new AbstractMethodError();
	}
	
	public function get parallelCommandsConfig () : ConfigurationProcessor {
		throw new AbstractMethodError();
	}
	
	public function get commandFlowConfig () : ConfigurationProcessor {
		throw new AbstractMethodError();
	}
	
	public function get observerConfig () : ConfigurationProcessor {
		throw new AbstractMethodError();
	}
	
	
}
}
