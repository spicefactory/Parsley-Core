package org.spicefactory.parsley.command.observer {

import org.spicefactory.parsley.command.trigger.Trigger;
import org.spicefactory.parsley.command.trigger.TriggerA;
import org.spicefactory.parsley.command.trigger.TriggerB;

/**
 * @author Jens Halm
 */
public class CommandObservers {
	
	
	public var completeInvoked:uint;
	public var completeAInvoked:uint;
	public var completeBInvoked:uint;

	public var resultsA:Array = new Array();
	public var resultsB:Array = new Array();
	public var results:Array = new Array();

	public var errors:Array = new Array();

	
	public function completeA (trigger: TriggerA) : void {
		completeAInvoked++;
	}
	
	public function completeB (trigger: TriggerB) : void {
		completeBInvoked++;
	}
	
	public function complete (trigger: Trigger) : void {
		completeInvoked++;
	}
	
	public function resultA (result: Object, trigger: TriggerA) : void {
		resultsA.push(result);
	}
	
	public function resultB (result: Object, trigger: TriggerB) : void {
		resultsB.push(result);
	}
	
	public function result (result: Object, trigger: Trigger) : void {
		results.push(result);
	}
	
	public function error (result: Object, trigger: Trigger) : void {
		errors.push(result);
	}

	
}
}
