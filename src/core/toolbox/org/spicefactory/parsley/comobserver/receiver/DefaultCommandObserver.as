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

package org.spicefactory.parsley.comobserver.receiver {

import org.spicefactory.lib.command.adapter.CommandAdapter;
import org.spicefactory.lib.command.data.CommandData;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.parsley.core.command.CommandObserverProcessor;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.impl.MessageReceiverKind;
import org.spicefactory.parsley.core.messaging.receiver.CommandObserver;
import org.spicefactory.parsley.messaging.receiver.AbstractMethodReceiver;
import org.spicefactory.parsley.messaging.receiver.MessageReceiverInfo;

/**
 * Default implementation of the CommandObserver interface.
 * 
 * @author Jens Halm
 */
public class DefaultCommandObserver extends AbstractMethodReceiver implements CommandObserver {
	
	
	private var _kind:MessageReceiverKind;
	private var maxParams:int;

	private var isInterceptor:Boolean;
	private var supportsResult:Boolean;	
	private var supportsNestedCommands:Boolean;
	
	/**
	 * Creates a new instance.
	 * 
	 * @param info the mapping information for the receiver
	 * @param status the command status this object is interested in
	 * @param supportsResult whether a result parameter is supported in the handler method
	 * @param supportsNestedCommands whether this observer should also react to nested command completion
	 */
	function DefaultCommandObserver (info:MessageReceiverInfo, kind:MessageReceiverKind, 
			supportsResult:Boolean = true, supportsNestedCommands:Boolean = false) {
		
		super(info);
		
		_kind = kind;
		this.supportsResult = supportsResult;
		this.supportsNestedCommands = supportsNestedCommands;
	}


	/**
	 * @private
	 */
	public override function init (provider: ObjectProvider, method: Method): void {
		
		super.init(provider, method);
		
		deduceMessageType();
		deduceSelector();
	
		var params: Array = targetMethod.parameters;
		isInterceptor = (params.length > 0) && Parameter(params[params.length - 1]).type.isType(MessageProcessor);
	}

	private function deduceMessageType () : void {

		maxParams = (supportsResult) ? 4 : 3;
		var params:Array = targetMethod.parameters;
		if (params.length > maxParams) {
			throw new ContextError("Target " + targetMethod  
				+ ": At most " + maxParams + " parameter(s) allowed for this type of Command Observer.");
		}
		var index:int = (supportsResult) ? 1 : 0;
		if (params.length >= index + 1) {
			deduceMessageTypeFromParameter(targetMethod, index);
		}
	}
	
	private function deduceSelector () : void {
		
		var index:int = (supportsResult) ? 2 : 1;
		var params:Array = targetMethod.parameters;
		if (params.length >= index + 1) {
			var param:Parameter = params[index];
			if (!param.type.isType(MessageProcessor)) {
				info.selector = param.type.getClass();
			}
		}	
	}
		
	/**
	 * @private
	 */
	public override function get order () : int {
		if (super.order != int.MAX_VALUE) {
			return super.order;
		}
		return (isInterceptor) ? (int.MIN_VALUE + 1) : int.MAX_VALUE;
	}
	
	/**
	 * @inheritDoc
	 */
	public function observeCommand (processor:CommandObserverProcessor) : void {
		if ((!processor.root && !supportsNestedCommands) 
			|| (processor.command is CommandAdapter) && supportsNestedCommands) return;
		
		var paramTypes:Array = targetMethod.parameters;
		var params:Array = new Array();
		if (paramTypes.length >= 1 && maxParams == 4) {
			if (!addResult(params, processor.result)) return;
		}
		if (paramTypes.length >= maxParams - 2) {
			params.push(processor.message.instance);
		}
		if (paramTypes.length >= maxParams - 1) {
			var param:Parameter = paramTypes[params.length];
			if (param.type.isType(MessageProcessor)) {
				params.push(processor);
			}
			else {
				if (processor.message.selector is Class) {
					params.push(null);
				}
				else {
					params.push(processor.message.selector);
				}
				if (paramTypes.length == maxParams) {
					params.push(processor);
				}
			}
		}
		targetMethod.invoke(provider.instance, params);
	}
	
	private function addResult (params: Array, result: Object): Boolean {
		if (result == null) {
			params.push(null);
			return true;
		}
		var param:Parameter = targetMethod.parameters[0];
		if (result is param.type.getClass()) {
			 params.push(result);
			 return true;
		}
		if (result is CommandData) {
			result = CommandData(result).getObject(param.type.getClass());
			if (result) {
				params.push(result);
				return true;
			}
		}
		return false;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get kind () : MessageReceiverKind {
		return _kind;
	}
	
	
}
}
