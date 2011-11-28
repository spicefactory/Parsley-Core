package org.spicefactory.parsley.command {

import org.spicefactory.parsley.command.trigger.TriggerA;

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
	
	
	protected override function execute (): void {
		dispatchMessage(new TriggerA());
	}
	
	
}
}
