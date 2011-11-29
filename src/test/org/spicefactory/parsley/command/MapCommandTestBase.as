package org.spicefactory.parsley.command {

import org.spicefactory.parsley.command.target.CommandBase;
import org.spicefactory.parsley.command.trigger.TriggerA;
import org.spicefactory.parsley.core.command.ObservableCommand;

/**
 * @author Jens Halm
 */
public class MapCommandTestBase extends CommandTestBase {
	
	
	[Test]
	public function noMatchingCommand () : void {

		configureSingleCommand();		
		
		validateManager(0);
		
		dispatchMessage("foo");
		validateManager(0);

	}
	
	protected override function getActiveCommands (type: Class): Array {
		var commands:Array = manager.getActiveCommandsByTrigger(type);
		var result:Array = new Array();
		for each (var com:ObservableCommand in commands) {
			if (com.command is CommandBase) result.push(com);
		}
		return result;
	}
	
	protected override function execute (): void {
		dispatchMessage(new TriggerA());
	}
	
	
}
}
