package org.spicefactory.parsley.command {

import org.spicefactory.lib.command.proxy.CommandProxy;
import org.spicefactory.parsley.command.target.CommandBase;
import org.spicefactory.parsley.command.trigger.TriggerB;

/**
 * @author Jens Halm
 */
public class CommandFactoryTestBase extends CommandTestBase {
	
	
	private var proxy: CommandProxy;
	
	
	protected function setProxy (proxy: CommandProxy): void {
		this.proxy = proxy;
	}
	
	
	protected override function getActiveCommands (type: Class): Array {
		if (type == TriggerB) return []; // we don't test this scenario with factories
		return manager.getActiveCommandsByType(CommandBase);
	}
	
	protected override function execute (): void {
		proxy.execute();
	}
	
	
	protected override function validateStatus (active: Boolean, result: Object = null, error: Object = null): void {
		/* TODO - 3.0.M2 - observers must get enhanced to match by command type or id first */
	}
	
	protected override function validateResults (...results): void {
		/* TODO - 3.0.M2 - observers must get enhanced to match by command type or id first */
	}
	
	protected override function validateError (error: Object = null): void {	
		/* TODO - 3.0.M2 - observers must get enhanced to match by command type or id first */
	}
	
	
}
}
