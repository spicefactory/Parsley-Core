package org.spicefactory.parsley.command {

import org.flexunit.assertThat;
import org.hamcrest.number.greaterThanOrEqualTo;
import org.hamcrest.object.equalTo;
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.command.target.CommandBase;
import org.spicefactory.parsley.command.target.SyncCommand;
import org.spicefactory.parsley.command.trigger.TriggerA;
import org.spicefactory.parsley.core.command.ObservableCommand;
import org.spicefactory.parsley.core.scope.ScopeName;

/**
 * @author Jens Halm
 */
public class MapCommandTestBase extends CommandTestBase {
	
	
	[Test]
	public function noMatchingTrigger () : void {

		configureSingleCommand();		
		
		validateManager(0);
		
		dispatchMessage("foo");
		
		validateManager(0);

	}
	
	[Test]
	public function noMatchingScope () : void {

		configureLocalScope();		
		
		validateManager(0);
		
		dispatchMessage(new TriggerA(), ScopeName.GLOBAL);
		
		validateManager(0);
				
	}
	
	[Test]
	public function noMatchingSelector () : void {

		configureSelector();		
		
		validateManager(0);
		
		dispatchMessage(new TriggerA(), null, "no-match");
		
		validateManager(0);
				
	}
	
	[Test]
	public function localScope (): void {

		configureLocalScope();		
		
		validateManager(0);
		
		dispatchMessage(new TriggerA(), ScopeName.LOCAL);
		
		validateExecution();
				
	}
	
	[Test]
	public function order (): void {
		
		SyncCommand.instances = new Array();
		
		configureOrder();
		
		validateManager(0);
		
		execute();
		
		validateManager(0);
		validateStatus(false);
		validateResults("1", "2");
		
		validateSyncLifecycle(0);
		validateSyncLifecycle(1);
		
	}
	
	private function validateSyncLifecycle (index: int): void {
		assertThat(SyncCommand.instances.length, greaterThanOrEqualTo(index + 1));
		assertThat(SyncCommand(SyncCommand.instances[index]).destroyCount, equalTo(1));
	}
	
	[Test]
	public function selector (): void {
		
		configureSelector();		
		
		validateManager(0);
		
		dispatchMessage(new TriggerA(), null, "selector");
		
		validateExecution();
		
	}
	
	protected function configureLocalScope (): void {
		throw new AbstractMethodError();
	}
	
	protected function configureOrder (): void {
		throw new AbstractMethodError();
	}
	
	protected function configureSelector (): void {
		throw new AbstractMethodError();
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
	
	private function validateExecution (): void {
		validateManager(1);
		validateStatus(true);
		validateResults();
		
		complete(0, true);
		
		validateManager(0);
		validateStatus(false);
		validateResults(true);
		validateLifecycle();		
	}
	
	
}
}
