package org.spicefactory.parsley.command.observer {

/**
 * @author Jens Halm
 */
public class CommandStatusFlagsMetadata extends CommandStatusFlags {
	

	[CommandStatus(type="org.spicefactory.parsley.command.trigger.Trigger")]
	public override function get trigger ():Boolean {
		return super.trigger;
	}
	
	public override function set trigger (value: Boolean):void {
		super.trigger = value;
	}
	
	[CommandStatus(type="org.spicefactory.parsley.command.trigger.TriggerA")]
	public override function get triggerA ():Boolean {
		return super.triggerA;
	}
	
	public override function set triggerA (value: Boolean):void {
		super.triggerA = value;
	}
	
	[CommandStatus(type="org.spicefactory.parsley.command.trigger.TriggerB")]
	public override function get triggerB ():Boolean {
		return super.triggerB;
	}
	
	public override function set triggerB (value: Boolean):void {
		super.triggerB = value;
	}
	
	
}
}
