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

package org.spicefactory.parsley.context {
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.core.messaging.ErrorPolicy;

/**
 * Builder for messaging settings.
 * 
 * @author Jens Halm
 */
public class MessageSettingsBuilder implements SetupPart {
	
	
	private var setup:ContextBuilderSetup;
	
	private var _defaultReceiverScope:String;
	private var errorPolicy:ErrorPolicy;
	private var errorHandler:Function;
	
	
	/**
	 * @private
	 */
	function MessageSettingsBuilder (setup:ContextBuilderSetup) {
		this.setup = setup;
	}

	
	/**
	 * Sets the policy to apply for unhandled errors. An unhandled error
	 * is an error thrown by a message handler where no matching error handler
	 * was registered for. The default is <code>ErrorPolicy.IGNORE</code>.
	 * 
	 * @param policy the policy to apply for unhandled errors
	 * @return the original setup instance for method chaining
	 */	
	public function unhandledError (policy:ErrorPolicy) : ContextBuilderSetup {
		errorPolicy = policy;		
		return setup;
	}
	
	/**
	 * Sets the default scope to use for message receivers and observers.
	 * If not specified the global scope will be used.
	 * In a modular application it is not uncommon that most message receivers
	 * are only interested in local messages. Switching the default allows to
	 * avoid specifying the local scope explicitly on all metadata tags.
	 * 
	 * @param name the name of the default receiver scope
	 * @return the original setup instance for method chaining
	 */
	public function defaultReceiverScope (name:String) : ContextBuilderSetup {
		_defaultReceiverScope = name;
		return setup;
	}
	
	/**
	 * Sets a handler that gets invoked for each Error thrown in any message receiver
	 * in any Context in any scope. The signature of the function must be:
	 * <code>function (processor:MessageProcessor, error:Error) : void</code>
	 * 
	 * @param policy the policy to apply for unhandled errors
	 * @return the original setup instance for method chaining
	 */	
	public function globalErrorHandler (handler:Function) : ContextBuilderSetup {
		errorHandler = handler;	
		return setup;
	}
	
	/**
	 * @private
	 */
	public function apply (config:BootstrapConfig) : void {
		if (errorPolicy != null) {
			config.messageSettings.unhandledError = errorPolicy;
		}
		if (errorHandler != null) {
			config.messageSettings.addErrorHandler(new GlobalMessageErrorHandler(errorHandler));
		}
		if (_defaultReceiverScope != null) {
			config.messageSettings.defaultReceiverScope = _defaultReceiverScope;
		}
	}
}
}

import org.spicefactory.parsley.messaging.receiver.MessageReceiverInfo;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;
import org.spicefactory.parsley.messaging.receiver.AbstractMessageReceiver;

class GlobalMessageErrorHandler extends AbstractMessageReceiver implements MessageErrorHandler {


	private var handler:Function;


	function GlobalMessageErrorHandler (handler:Function) {
		super(new MessageReceiverInfo());
		this.handler = handler;
	}

	public function handleError (processor:MessageProcessor, error:Error) : void {
		handler(processor, error);
	}
	
	public function get errorType () : Class {
		return Error;
	}
	
	
}


