/*
 * Copyright 2008-2011 the original author or authors.
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

import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.LogUtil;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.messaging.ErrorPolicy;
import org.spicefactory.parsley.core.messaging.Message;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.MessageReceiverCache;
import org.spicefactory.parsley.core.messaging.MessageReceiverKind;
import org.spicefactory.parsley.core.messaging.MessageSettings;
import org.spicefactory.parsley.core.messaging.MessageState;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;

/**
 * Default implementation of the MessageProcessor interface.
 * 
 * @author Jens Halm
 */
public class DefaultMessageProcessor implements MessageProcessor {
	
	
	private static const log:Logger = LogContext.getLogger(DefaultMessageProcessor);

	
	private var _cache:MessageReceiverCache;
	
	private var remainingProcessors:Array;
	private var currentProcessor:Processor;
	private var currentError:Error;
	private var receiverHandler:Function;

	private var _message:Message;
	private var _state:MessageState;
	private var settings:MessageSettings;
	

	/**
	 * Creates a new instance.
	 * 
	 * @param message the message and its settings
	 * @param cache the receiver selection cache corresponding to the messageType
	 * @param settings the settings for this processor
	 * @param receiverHandler the function to invoke for each processed receiver
	 */
	function DefaultMessageProcessor (message:Message, cache:MessageReceiverCache, 
			settings:MessageSettings, receiverHandler:Function = null) {
		this._message = message;
		this._cache = cache;
		this.settings = settings;
		this.receiverHandler = (receiverHandler != null) ? receiverHandler : invokeTarget;
	}

	/**
	 * Return a string that can be used to describe the message handled by this processor.
	 * 
	 * @param action a string describing the action that will be logged, like 'Dispatch', 'Resume' or 'Cancel'
	 * @param receiverCount the number of remaining receivers this processor will handle
	 * @return a string that can be used to describe the message handled by this processor
	 */
	protected function getLogString (action:String, receiverCount:int) : String {
		return LogUtil.buildLogMessage("{0} message '{1}' with {2} receiver(s)", [action, message.instance, receiverCount]);
	}
	
	private function illegalState (methodName:String) : void {
		throw new IllegalStateError("Attempt to call " + methodName 
				+ " on MessageProcessor in illegal state: " + state); 
	}
	
	private function logStatus (action:String) : void {
		if (log.isInfoEnabled()) {
			var cnt:int = currentProcessor.receiverCount;
			if (remainingProcessors.length) cnt += Processor(remainingProcessors[0]).receiverCount;
			log.info(getLogString(action, cnt));
		}
	}
	
	public function proceed () : void {
		if (!state) {
			start();
		}
		else {
			resume();
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function resume () : void {
		if (state != MessageState.SUSPENDED) {
			illegalState("resume");
		}
		logStatus("Resume");
		_state = MessageState.ACTIVE;
		processReceivers();
	}
	
	private function processReceivers () : void {
		do {
			while (!currentProcessor.hasNext()) {
				if (complete()) {
					return;
				}
				currentProcessor = remainingProcessors.shift() as Processor;
			}
			try {
				currentProcessor.proceed();
			}
			catch (e:Error) {
				log.error("Message receiver {0} threw Error: {1}", currentProcessor.currentReceiver, e);
				if (!currentProcessor.handleErrors || (e is MessageProcessorError)) {
					// avoid the risk of endless loops
					throw e;
				}
				if (!handleError(e)) return;
			}
		} while (state == MessageState.ACTIVE);
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function get state () : MessageState {
		return _state;
	}
	
	private function complete () : Boolean {
		if (remainingProcessors.length == 0) {
			currentProcessor = null;
			_state = MessageState.COMPLETE;
			return true;
		}
		return false;
	}
	
	/**
	 * @private
	 */
	internal function start () : void {
		createProcessors();
		logStatus("Dispatch");
		_state = MessageState.ACTIVE;
		processReceivers();
	}
	
	/**
	 * @inheritDoc
	 */
	public function suspend () : void {
		if (state != MessageState.ACTIVE) {
			illegalState("suspend");
		}
		logStatus("Suspend");
		_state = MessageState.SUSPENDED;
	}

	/**
	 * @inheritDoc
	 */
	public function cancel () : void {
		if (state == MessageState.CANCELLED) {
			return;
		}
		logStatus("Cancel");
		_state = MessageState.CANCELLED;
		currentProcessor = null;
		remainingProcessors = null;
	}

	private function handleError (e:Error) : Boolean {
		var handlers:Array = new Array();
		var errorHandlers:Array = (_message) ? cache.getReceivers(MessageReceiverKind.ERROR_HANDLER, _message.selector) : [];
		for each (var errorHandler:MessageErrorHandler in errorHandlers) {
			if (e is errorHandler.errorType) {
				handlers.push(errorHandler);
			}
		}
		if (log.isInfoEnabled()) {
			log.info("Select " + handlers.length + " out of " + errorHandlers.length + " error handlers");
		}
		if (handlers.length > 0) {
			currentError = e;
			remainingProcessors.unshift(currentProcessor);
			currentProcessor = new Processor(handlers, invokeErrorHandler, false);
			return true;
		}
		else {
			return unhandledError(e);
		}
	}
	
	private function unhandledError (e:Error) : Boolean {
		if (settings.unhandledError == ErrorPolicy.RETHROW) {
			throw new MessageProcessorError("Error in message receiver", e);
		}
		else if (settings.unhandledError == ErrorPolicy.ABORT) {
			log.info("Unhandled error - abort message processor");
			return false;
		}
		else {
			log.info("Unhandled error - continue message processing");
			return true;
		}
	}
	
	private function invokeTarget (target:MessageTarget) : void {
		target.handleMessage(this);
	}
	
	private function invokeErrorHandler (errorHandler:MessageErrorHandler) : void {
		errorHandler.handleError(this, currentError);
	}
	
	/**
	 * @inheritDoc
	 */
	public function rewind () : void {
		if (state == MessageState.CANCELLED) {
			illegalState("rewind");
		}
		logStatus("Rewind");
		createProcessors();
	}
	
	private function createProcessors () : void {	
		currentProcessor = new Processor(fetchReceivers(), receiverHandler);
		remainingProcessors = [];
	}
	
	/**
	 * Fetches the receivers for the message type and receiver kind this processor handles.
	 * 
	 * @return the receivers for the message type and receiver kind this processor handles
	 */
	protected function fetchReceivers () : Array {
		return cache.getReceivers(MessageReceiverKind.TARGET, _message.selector);
	}
	
	/**
	 * The receiver cache for the message type this processor handles
	 */
	protected function get cache () : MessageReceiverCache {
		return _cache;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get message () : Message {
		return (_message);
	}
	
	/**
	 * @inheritDoc
	 */
	public function sendResponse (msg:Object, selector:* = null) : void {
		if (message && message.senderContext) {
			message.senderContext.scopeManager.dispatchMessage(msg, selector);
		}
		else {
			throw new IllegalStateError("Unable to send response for message " 
					+ message + ": sender Context unknown");
		}
	}
	
	
}
}

import org.spicefactory.lib.errors.NestedError;
import org.spicefactory.parsley.core.messaging.receiver.MessageReceiver;

class Processor {
	
	private var receivers:Array;
	private var handler:Function;
	private var currentIndex:uint = 0;
	internal var handleErrors:Boolean;
	
	function Processor (receivers:Array, handler:Function, handleErrors:Boolean = true) {
		this.receivers = receivers;
		this.handler = handler;
		this.handleErrors = handleErrors;
		receivers.sortOn("order", Array.NUMERIC);
	}
	
	internal function hasNext () : Boolean {
		return (receivers.length > currentIndex);
	}
	
	internal function get receiverCount () : uint {
		return receivers.length;
	}

	internal function rewind () : void {
		currentIndex = 0;
	}
	
	internal function get currentReceiver () : MessageReceiver {
		return (hasNext()) ? receivers[currentIndex] as MessageReceiver : null;
	}

	internal function proceed () : void {
		handler(receivers[currentIndex++]);
	}
	
}

class MessageProcessorError extends NestedError {
	
	public function MessageProcessorError (message:String = "", cause:Error = null) {
		super(message, cause);
	}
	
}

