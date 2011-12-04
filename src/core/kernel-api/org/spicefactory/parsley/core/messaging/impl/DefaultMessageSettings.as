/*
 * Copyright 2010 the original author or authors.
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

package org.spicefactory.parsley.core.messaging.impl {

import org.spicefactory.parsley.core.context.LookupStatus;
import org.spicefactory.parsley.core.context.impl.DefaultLookupStatus;
import org.spicefactory.parsley.core.messaging.ErrorPolicy;
import org.spicefactory.parsley.core.messaging.MessageSettings;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;
import org.spicefactory.parsley.core.scope.ScopeName;

/**
 * Default implementation of the MessageSettings interface.
 * 
 * @author Jens Halm
 */
public class DefaultMessageSettings implements MessageSettings {


	private var _parents:Array = new Array();
	
	private var _defaultReceiverScope:String;
	private var _unhandledError:ErrorPolicy;
	private var _errorHandlers:Array = new Array();


	/**
	 * Adds a parent for looking up values not set in this instance.
	 * 
	 * @param a parent settings instance
	 */
	public function addParent (parent:MessageSettings) : void {
		_parents.push(parent);
	}
	
	/**
	 * @inheritDoc
	 */
	public function addErrorHandler (target:MessageErrorHandler) : void {
		_errorHandlers.push(target);
	}
	
	/**
	 * @inheritDoc
	 */
	public function getErrorHandlers (status:LookupStatus = null) : Array {
		var handlers:Array = _errorHandlers;
		var parentHandlers:Array;
		for each (var parent:MessageSettings in _parents) {
			if (!status) {
				status = new DefaultLookupStatus(this);
			}
			if (status.addInstance(parent)) {
				parentHandlers = parent.getErrorHandlers(status);
				if (parentHandlers.length) {
					handlers = handlers.concat(parentHandlers);
				}
			}
			
		}
		return handlers;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get unhandledError () : ErrorPolicy {
		return (_unhandledError) 
				? _unhandledError 
				: ((_parents.length) ? _parents[0].unhandledError : ErrorPolicy.IGNORE);
	}
	
	/**
	 * @inheritDoc
	 */
	public function set unhandledError (policy:ErrorPolicy) : void {
		_unhandledError = policy;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get defaultReceiverScope () : String {
		return (_defaultReceiverScope) 
				? _defaultReceiverScope 
				: ((_parents.length) ? _parents[0].defaultReceiverScope : ScopeName.GLOBAL);
	}

	/**
	 * @inheritDoc
	 */
	public function set defaultReceiverScope (value:String) : void {
		_defaultReceiverScope = value;
	}
}
}



