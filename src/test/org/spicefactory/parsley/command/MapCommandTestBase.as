package org.spicefactory.parsley.command {

import org.flexunit.assertThat;
import org.hamcrest.collection.arrayWithSize;
import org.hamcrest.number.greaterThanOrEqualTo;
import org.hamcrest.object.equalTo;
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.command.observer.CommandObservers;
import org.spicefactory.parsley.command.observer.CommandStatusFlags;
import org.spicefactory.parsley.command.target.AsyncCommand;
import org.spicefactory.parsley.command.trigger.Trigger;
import org.spicefactory.parsley.command.trigger.TriggerA;
import org.spicefactory.parsley.command.trigger.TriggerB;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.core.command.CommandManager;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.scope.ScopeName;
import org.spicefactory.parsley.dsl.context.ContextBuilder;

/**
 * @author Jens Halm
 */
public class MapCommandTestBase {
	
	
	private var context: Context;
	private var manager: CommandManager;
	
	private var status: CommandStatusFlags;
	private var observers: CommandObservers;
	
	private var lastCommand: AsyncCommand;
	
	
	private function configure (mapCommandConfig: ConfigurationProcessor) : void {
		context = ContextBuilder.newBuilder().config(mapCommandConfig).config(observerConfig).build();
		manager = context.scopeManager.getScope(ScopeName.GLOBAL).commandManager;
		status = context.getObjectByType(CommandStatusFlags) as CommandStatusFlags;
		observers = context.getObjectByType(CommandObservers) as CommandObservers;
	}
	
	[Test]
	public function noMatchingCommand () : void {

		configure(singleCommandConfig);		
		
		validateManager(0);
		
		dispatch("foo");
		validateManager(0);

	}
	
	[Test]
	public function singleCommand () : void {
		
		configure(singleCommandConfig);
		
		validateManager(0);
		
		dispatch(new TriggerA());
		validateManager(1);
		validateStatus(true);
		
		complete(0, true);
		validateManager(0);
		validateStatus(false, true);
		validateLifecycle();
		
	}
	
	
	private function dispatch (msg: Object): void {
		context.scopeManager.dispatchMessage(msg); 
	}
	
	private function complete (index: uint, result: Object = null): void {
		var commands:Array = manager.getActiveCommandsByTrigger(TriggerA);
		assertThat(commands.length, greaterThanOrEqualTo(index + 1));
		lastCommand = commands[index].command as AsyncCommand;
		lastCommand.invokeCallback(result);
	}
	
	private function validateManager (cnt: uint): void {
		var commands:Array = manager.getActiveCommandsByTrigger(Trigger);
		assertThat(commands, arrayWithSize(cnt));
		commands = manager.getActiveCommandsByTrigger(TriggerA);
		assertThat(commands, arrayWithSize(cnt));
		commands = manager.getActiveCommandsByTrigger(TriggerB);
		assertThat(commands, arrayWithSize(0));
	}
	
	private function validateStatus (active: Boolean, result: Object = null, error: Object = null): void {
		assertThat(status.trigger, equalTo(active));
		assertThat(status.triggerA, equalTo(active));
		assertThat(status.triggerB, equalTo(false));
		if (result) {
			assertThat(observers.results, arrayWithSize(1));
			assertThat(observers.resultsA, arrayWithSize(1));
			assertThat(observers.resultsB, arrayWithSize(0));
			assertThat(observers.results[0], equalTo(result));
			assertThat(observers.resultsA[0], equalTo(result));
		}
		else {
			assertThat(observers.results, arrayWithSize(0));
			assertThat(observers.resultsA, arrayWithSize(0));
			assertThat(observers.resultsB, arrayWithSize(0));
		}
		if (error) {
			assertThat(observers.errors, arrayWithSize(1));
			assertThat(observers.errors[0], equalTo(error));
		}
		else {
			assertThat(observers.errors, arrayWithSize(0));
		}
	}
	
	private function validateLifecycle (destroyCount:uint = 1) : void {
		assertThat(lastCommand.destroyCount, equalTo(1));
	}

	
	public function get singleCommandConfig () : ConfigurationProcessor {
		throw new AbstractMethodError();
	}
	
	public function get observerConfig () : ConfigurationProcessor {
		throw new AbstractMethodError();
	}
	
	
}
}
