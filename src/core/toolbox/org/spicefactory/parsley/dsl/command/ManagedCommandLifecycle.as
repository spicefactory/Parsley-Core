/*
 * Copyright 2011 the original author or authors.
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

package org.spicefactory.parsley.dsl.command {

import org.spicefactory.lib.command.CommandResult;
import org.spicefactory.lib.command.adapter.CommandAdapter;
import org.spicefactory.lib.command.data.CommandData;
import org.spicefactory.lib.command.lifecycle.DefaultCommandLifecycle;
import org.spicefactory.lib.command.proxy.CommandProxy;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.command.ManagedCommandProxy;
import org.spicefactory.parsley.core.command.ObservableCommand;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.messaging.Message;
import org.spicefactory.parsley.core.state.GlobalState;

import flash.utils.Dictionary;
	
/**
 * @author Jens Halm
 */
public class ManagedCommandLifecycle extends DefaultCommandLifecycle {
	
	
	private var context:Context;
	
	private var nextTrigger:Message;
	private var nextId:String;
	
	private var observables:Dictionary = new Dictionary();
	
	
	function ManagedCommandLifecycle (context:Context, root:ManagedCommandProxy, trigger:Message = null) {
		this.context = context;
		this.nextId = root.id;
		this.nextTrigger = trigger;
	}
	
	
	public override function beforeExecution (command:Object, data:CommandData) : void {
		if (isManagedTarget(command)) {
			var dynamicObject:DynamicObject;
			if (!GlobalState.objects.isManaged(command)) {
				dynamicObject = context.addDynamicObject(command);
			}
			context.scopeManager.observeCommand(createObservableCommand(command, dynamicObject));
		}
		else if (command is ManagedCommandProxy) {
			nextId = ManagedCommandProxy(command).id;
		}
	}

	public override function afterCompletion (command:Object, result:CommandResult) : void {
		if (observables[command]) {
			var observable:ObservableCommandImpl = observables[command];
			observable.setResult(result);
		}
	}
	
	private function isManagedTarget (command:Object) : Boolean {
		return (!(command is CommandAdapter) && !(command is CommandProxy));
	}
	
	private function createObservableCommand (command:Object, dynamicObject:DynamicObject) : ObservableCommand {
		var type:ClassInfo = ClassInfo.forInstance(command, context.domain);
		var observable:ObservableCommand = new ObservableCommandImpl(command, type, dynamicObject, nextId, nextTrigger);
		nextId = null;
		nextTrigger = null;
		observables[command] = observable;
		return observable;
	}
	
	
}
}

import org.spicefactory.lib.command.CommandResult;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.command.CommandStatus;
import org.spicefactory.parsley.core.command.ObservableCommand;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.messaging.Message;

class ObservableCommandImpl implements ObservableCommand {

	private var dynamicObject:DynamicObject;

	private var _command:Object;
	private var _type:ClassInfo;
	private var _trigger:Message;
	private var _id:String;
	private var _status:CommandStatus;
	private var _result:Object;
	
	private var callbacks:Array = [];
	

	function ObservableCommandImpl (command:Object, type:ClassInfo, dynamicObject:DynamicObject = null, 
			id:String = null, trigger:Message = null) {
		this.dynamicObject = dynamicObject;
		_command = command;
		_type = type;
		_id = id;
		_trigger = trigger;
		_status = CommandStatus.EXECUTE;
	}


	public function get trigger () : Message {
		return _trigger;
	}

	public function get id () : String {
		return _id;
	}

	public function get command () : Object {
		return _command;
	}
	
	public function get type () : ClassInfo {
		return _type;
	}

	public function get result () : Object {
		return _result;
	}

	public function get status () : CommandStatus {
		return _status;
	}

	public function observe (callback:Function) : void {
		callbacks.push(callback);		
	}
	
	public function setResult (result:CommandResult) : void {
		_status = 
		    (result.complete) ? CommandStatus.COMPLETE 
		    : (result.value) ? CommandStatus.ERROR : CommandStatus.CANCEL;
		_result = result.value;
		for each (var callback:Function in callbacks) {
			callback(this);
		}
		callbacks = [];
		if (dynamicObject) {
			dynamicObject.remove();
			dynamicObject = null;
		}
	}
	
	
}




