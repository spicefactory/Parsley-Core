package org.spicefactory.parsley.command {

import org.spicefactory.lib.command.Command;
import org.spicefactory.lib.command.builder.CommandFlowBuilder;
import org.spicefactory.lib.command.builder.Commands;
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.command.config.CommandObserverConfig;
import org.spicefactory.parsley.command.target.AsyncCommand;
import org.spicefactory.parsley.context.ContextBuilder;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.flex.FlexConfig;

/**
 * @author Jens Halm
 */
public class CommandFactoryDslTest extends CommandFactoryTestBase {
	
	
	
	protected override function configureSingleCommand (): void {
		configure(ManagedCommands.create(AsyncCommand));
	}
	
	protected override function configureCommandSequence (): void {
		configure(ManagedCommands.wrap(createCommandSequence()));
	}
	
	private function createCommandSequence (): Command {
		return Commands
			.asSequence()
			.add(new AsyncCommand("1"))
			.add(new AsyncCommand("2"))
			.build();
	}
	
	protected override function configureParallelCommands (): void {
		configure(ManagedCommands.wrap(createParallelCommands()));
	}
	
	private function createParallelCommands (): Command {
		return Commands
			.inParallel()
			.add(new AsyncCommand("1"))
			.add(new AsyncCommand("2"))
			.build();
	}
	
	protected override function configureCommandFlow (): void {
		configure(ManagedCommands.wrap(createCommandFlow()));
	}
	
	private function createCommandFlow (): Command {
		var builder: CommandFlowBuilder = Commands.asFlow();
		
		builder
			.add(new AsyncCommand("1"))
			.linkResultValue("1")
			.toCommandInstance(new AsyncCommand("2"));
			
		return builder.build();
	}
	
	private function configure (builder: ManagedCommandBuilder): void {
		var context: Context = buildContext();
		setProxy(builder.build(context));
	}
	
	private function buildContext () : Context {
		var context: Context = ContextBuilder
			.newBuilder()
			.config(FlexConfig.forClass(CommandObserverConfig))
			.build();
		setContext(context);
		return context;
	}	
	
	
	public function get observerConfig () : ConfigurationProcessor {
		throw new AbstractMethodError();
	}
	
	
}
}
