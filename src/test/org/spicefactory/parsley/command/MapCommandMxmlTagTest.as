package org.spicefactory.parsley.command {

import org.flexunit.assertThat;
import org.hamcrest.collection.arrayWithSize;
import org.spicefactory.lib.command.adapter.CommandAdapter;
import org.spicefactory.lib.command.light.LightCommandAdapter;
import org.spicefactory.lib.command.result.ResultProcessors;
import org.spicefactory.parsley.command.config.CommandObserverConfig;
import org.spicefactory.parsley.command.config.LocalScope;
import org.spicefactory.parsley.command.config.MapAsyncTokenCommand;
import org.spicefactory.parsley.command.config.MapCommandFlow;
import org.spicefactory.parsley.command.config.MapCommandSequence;
import org.spicefactory.parsley.command.config.MapParallelCommands;
import org.spicefactory.parsley.command.config.MapSingleCommand;
import org.spicefactory.parsley.command.config.OrderConfig;
import org.spicefactory.parsley.command.config.SelectorConfig;
import org.spicefactory.parsley.command.target.AsyncTokenCommand;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.core.command.ObservableCommand;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.dsl.context.ContextBuilder;
import org.spicefactory.parsley.flex.FlexConfig;
import org.spicefactory.parsley.flex.command.AsyncTokenResultProcessor;

import mx.core.mx_internal;
import mx.rpc.AsyncToken;
import mx.rpc.Fault;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

/**
 * @author Jens Halm
 */
public class MapCommandMxmlTagTest extends MapCommandTagTestBase {
	
	
	[BeforeClass]
	public static function prepareAsyncTokenCommandSupport (): void {
		ResultProcessors.forResultType(AsyncToken).processorType(AsyncTokenResultProcessor);
		LightCommandAdapter.addErrorType(Fault);
	}
	
	[Test]
	public function asyncTokenResult (): void {
		
		executeAsyncTokenCommand();
		
		setLastCommand(0);
		AsyncTokenCommand.lastToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, false, "foo"));
		
		validateManager(0);
		validateStatus(false);
		validateResults("foo");
		validateLifecycle();	
	}
	
	[Test]
	public function asyncTokenFault (): void {
		
		executeAsyncTokenCommand();
		
		setLastCommand(0);
		var fault:Fault = new Fault("001", "fault");
		AsyncTokenCommand.lastToken.mx_internal::applyFault(new FaultEvent(FaultEvent.FAULT, false, false, fault));
		
		validateManager(0);
		validateStatus(false);
		validateError(fault);
		validateLifecycle();	
	}
	
	[Test]
	public function asyncTokenCancellation (): void {
		
		executeAsyncTokenCommand();
		
		setLastCommand(0);
		cancelAdapter();
		AsyncTokenCommand.lastToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, false, "foo"));
		
		validateManager(0);
		validateStatus(false);
		validateResults();
		validateError();
		validateLifecycle();	
	}
	
	private function cancelAdapter (): void {
		var commands:Array = manager.getActiveCommandsByType(CommandAdapter);
		assertThat(commands, arrayWithSize(1));
		CommandAdapter(ObservableCommand(commands[0]).command).cancel();
	}
	
	private function executeAsyncTokenCommand (): void {
		buildContext();
		
		validateManager(0);
		
		execute();
		
		validateManager(1);
		validateStatus(true);
		validateResults();
	}
	
	private function buildContext () : void {
		var context: Context = ContextBuilder
			.newBuilder()
			.config(FlexConfig.forClass(MapAsyncTokenCommand))
			.config(observerConfig)
			.build();
		setContext(context);
	}
	
	
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
