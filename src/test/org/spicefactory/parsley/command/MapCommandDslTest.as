package org.spicefactory.parsley.command {

import org.spicefactory.lib.command.Command;
import org.spicefactory.lib.command.builder.CommandFlowBuilder;
import org.spicefactory.lib.command.builder.Commands;
import org.spicefactory.lib.command.flow.CommandFlow;
import org.spicefactory.lib.command.group.CommandSequence;
import org.spicefactory.lib.command.group.ParallelCommands;
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.command.config.CommandObserverConfig;
import org.spicefactory.parsley.command.target.AsyncCommandWithTrigger;
import org.spicefactory.parsley.command.trigger.TriggerA;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.dsl.command.MappedCommands;
import org.spicefactory.parsley.dsl.context.ContextBuilder;
import org.spicefactory.parsley.flex.FlexConfig;

/**
 * @author Jens Halm
 */
public class MapCommandDslTest extends MapCommandTestBase {
	
	
	
	protected override function configureSingleCommand (): void {
		var context: Context = buildContext();
		MappedCommands.create(AsyncCommandWithTrigger).register(context);
	}
	
	protected override function configureCommandSequence (): void {
		var context: Context = buildContext();
		MappedCommands
			.factoryFunction(createCommandSequence, CommandSequence)
			.messageType(TriggerA)
			.register(context);
	}
	
	private function createCommandSequence (): Command {
		return Commands
			.asSequence()
			.add(new AsyncCommandWithTrigger("1"))
			.add(new AsyncCommandWithTrigger("2"))
			.build();
	}
	
	protected override function configureParallelCommands (): void {
		var context: Context = buildContext();
		MappedCommands
			.factoryFunction(createParallelCommands, ParallelCommands)
			.messageType(TriggerA)
			.register(context);
	}
	
	private function createParallelCommands (): Command {
		return Commands
			.inParallel()
			.add(new AsyncCommandWithTrigger("1"))
			.add(new AsyncCommandWithTrigger("2"))
			.build();
	}
	
	protected override function configureCommandFlow (): void {
		var context: Context = buildContext();
		MappedCommands
			.factoryFunction(createCommandFlow, CommandFlow)
			.messageType(TriggerA)
			.register(context);
	}
	
	private function createCommandFlow (): Command {
		var builder: CommandFlowBuilder = Commands.asFlow();
		
		builder
			.add(new AsyncCommandWithTrigger("1"))
			.linkResultValue("1")
			.toCommandInstance(new AsyncCommandWithTrigger("2"));
			
		return builder.build();
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
