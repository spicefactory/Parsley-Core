package org.spicefactory.parsley.command.observer {

/**
 * @author Jens Halm
 */
public class CommandStatusFlags {
	
	
	private var _trigger:Boolean;

	private var _triggerA:Boolean;

	private var _triggerB:Boolean;
	
	// Using getter/setter here so that we can override them in subclasses
	
	public function get trigger (): Boolean {
		return _trigger;
	}
	
	public function set trigger (value: Boolean):void {
		_trigger = value;
	}
	
	public function get triggerA ():Boolean {
		return _triggerA;
	}
	
	public function set triggerA (value: Boolean):void {
		_triggerA = value;
	}
	
	public function get triggerB ():Boolean {
		return _triggerB;
	}
	
	public function set triggerB (value: Boolean):void {
		_triggerB = value;
	}
	
	
}
}
