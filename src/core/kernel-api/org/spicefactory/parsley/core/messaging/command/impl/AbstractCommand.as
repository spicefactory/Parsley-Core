/*
 * Copyright 2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.spicefactory.parsley.core.messaging.command.impl {
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.util.Delegate;
import org.spicefactory.lib.util.DelegateChain;
import org.spicefactory.parsley.core.messaging.Message;
import org.spicefactory.parsley.core.messaging.command.Command;
import org.spicefactory.parsley.core.messaging.command.CommandStatus;
import org.spicefactory.parsley.core.messaging.receiver.CommandObserver;

import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;

/**
 * Abstract base class for Commands. In most cases custom Command implementations
 * can simply extend this class and invoke one of the protected methods when
 * the Command completed its execution.
 * 
 * @author Jens Halm
 */
public class AbstractCommand implements Command {


	private var _message:Message;
	private var _returnValue:*;
	private var _result:*;

	private var _status:CommandStatus;
	private var synchronous:Boolean;
	
	private var statusHandlers:DelegateChain = new DelegateChain();
	private var _observers:Array = new Array();


	/**
	 * Creates a new instance.
	 * 
	 * @param returnValue the value returned by the method executing the command
	 * @param message the message that triggered the command execution
	 */
	function AbstractCommand (returnValue:*, message:Message) {
		synchronous = true;
		_returnValue = returnValue;
		_message = message;
		_status = CommandStatus.EXECUTE;
	}

	/**
	 * @inheritDoc
	 */
	public function get message () : Message {
		return _message;
	}
	
	public function get selector () : * {
		return _message.selector;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get returnValue () : * {
		return _returnValue;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get status () : CommandStatus {
		return _status;
	}

	/**
	 * Signals that the command is now active.
	 * Any invocation of the <code>complete</code>, <code>cancel</code>
	 * or <code>error</code> method before this method was invoked will lead to a delayed execution
	 * as they are treated as stemming from a command that synchronously finished
	 * its execution.
	 * 
	 * <p>This method should usually be called at the very end of the constructor of the command.</p>
	 */
	protected function start () : void {
		synchronous = false;
	}
	
	/**
	 * Signals that the Command has successfully completed and specifies the result
	 * to be passed to result handlers.
	 * 
	 * @param result the result to be passed to result handlers
	 */
	protected function complete (result:* = null) : void {
		handleResult(CommandStatus.COMPLETE, result);
	}
	
	/**
	 * Signals that the Command finished with an error and specifies the value
	 * to be passed to error handlers.
	 * 
	 * @param result the error to be passed to error handlers
	 */
	protected function error (result:* = null) : void {
		handleResult(CommandStatus.ERROR, result);
	}
	
	private function handleResult (newStatus:CommandStatus, result:*) : void {
		checkState();
		_status = newStatus;
		_result = result;
		invokeStatusHandlers();
	}
	
	/**
	 * Signals that the Command execution has been cancelled. 
	 */
	protected function cancel () : void {
		checkState();
		_status = CommandStatus.CANCEL;
		invokeStatusHandlers();
	}
	
	private function checkState () : void {
		if (status != CommandStatus.EXECUTE) {
			throw new IllegalStateError("Command already finished executing: " + this);
		}
	}

	/**
	 * @inheritDoc
	 */
	public function setResult (result:Object, status:CommandStatus = null) : void {
		if (status == CommandStatus.EXECUTE) {
			throw new IllegalStateError("Cannot set the result while Command is still executing");
		}
		if (status) {
			_status = status;
		}
		_result = result;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getResult (targetType:ClassInfo) : * {
		if (status == CommandStatus.COMPLETE) {
			return selectResultValue(_result, targetType);
		}
		else if (status == CommandStatus.ERROR) {
			return selectErrorValue(_result, targetType);
		}
		else {
			throw new IllegalStateError("No result available in Command with status " + status);
		}
	}
	
	/**
	 * Selects the value to be passed to a result handler based on the specified target type.
	 * 
	 * <p>The type is only passed to the method to allow to select
	 * amongst multiple values (like choosing between <code>ResultEvent.result</code>
	 * and the event instance itself). Implementations should not throw an Error if
	 * the type does not match, as there might be a Converter registered for the target type.</p>
	 * 
	 * @param result the result that was passed to the complete method
	 * @param targetType The expected type on the target (parameter or property)
	 * @return the best match for the specified target type
	 */
	protected function selectResultValue (result:*, targetType:ClassInfo) : * {
		return result;
	}

	/**
	 * Selects the value to be passed to an error handler based on the specified target type.
	 * 
	 * <p>The type is only passed to the method to allow to select
	 * amongst multiple values (like choosing between <code>FaultEvent.fault</code>
	 * and the event instance itself). Implementations should not throw an Error if
	 * the type does not match, as there might be a Converter registered for the target type.</p>
	 * 
	 * @param result the result that was passed to the error method
	 * @param targetType The expected type on the target (parameter or property)
	 * @return the best match for the specified target type
	 */
	protected function selectErrorValue (result:*, targetType:ClassInfo) : * {
		return result;
	}
	
	/**
	 * @inheritDoc
	 */
	public function addStatusHandler (handler:Function, ...params) : void {
		params.unshift(this);
		statusHandlers.addDelegate(new Delegate(handler, params));
	}
	
	private function invokeStatusHandlers () : void {
		if (synchronous) {
			var timer:Timer = new Timer(1, 1);
			timer.addEventListener(TimerEvent.TIMER, invokeStatusHandlersDelayed);
			timer.start();
		}
		else {
			statusHandlers.invoke();
		}
	}
	
	private function invokeStatusHandlersDelayed (event:Event) : void {
		IEventDispatcher(event.target).removeEventListener(TimerEvent.TIMER, invokeStatusHandlersDelayed);
		if (synchronous) throw IllegalStateError("Command was not started in Constructor");
		invokeStatusHandlers();
	}
	
	/**
	 * @inheritDoc
	 */
	public function addObserver (observer:CommandObserver) : void {
		_observers.push(observer);
	}

	/**
	 * @inheritDoc
	 */
	public function hasObserver (status:CommandStatus) : Boolean {
		for each (var observer:CommandObserver in _observers) {
			if (observer.status == status) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getObservers (status:CommandStatus) : Array {
		var result:Array = new Array();
		for each (var observer:CommandObserver in _observers) {
			if (observer.status == status) {
				result.push(observer);
			}
		}
		return result;
	}
	
	
}
}
