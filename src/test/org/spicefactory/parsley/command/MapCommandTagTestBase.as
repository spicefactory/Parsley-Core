package org.spicefactory.parsley.command {

import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.dsl.context.ContextBuilder;

/**
 * @author Jens Halm
 */
public class MapCommandTagTestBase extends MapCommandTestBase {
	
	
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
	
	protected override function configureLocalScope (): void {
		buildContext(localScopeConfig);
	}
	
	protected override function configureOrder (): void {
		buildContext(orderConfig);
	}
	
	protected override function configureSelector (): void {
		buildContext(selectorConfig);
	}
	
	private function buildContext (mapCommandConfig: ConfigurationProcessor) : void {
		var context: Context = ContextBuilder.newBuilder().config(mapCommandConfig).config(observerConfig).build();
		setContext(context);
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
	
	public function get localScopeConfig () : ConfigurationProcessor {
		throw new AbstractMethodError();
	}
	
	public function get orderConfig () : ConfigurationProcessor {
		throw new AbstractMethodError();
	}
	
	public function get selectorConfig () : ConfigurationProcessor {
		throw new AbstractMethodError();
	}
	
	public function get observerConfig () : ConfigurationProcessor {
		throw new AbstractMethodError();
	}
	
	
}
}
