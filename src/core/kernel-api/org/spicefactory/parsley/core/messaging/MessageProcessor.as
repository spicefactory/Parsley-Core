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

package org.spicefactory.parsley.core.messaging {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.messaging.command.Command;

/**
 * Responsible for processing a single message. Will be passed to registered message interceptors and error handlers
 * which may chose to cancel or suspend and later resume the message processing.
 * 
 * @author Jens Halm
 */
public interface MessageProcessor {
	
	/**
	 * The message instance.
	 */
	function get message () : Object;
	
	/**
	 * The optional selector value to be used for selecting matching receivers.
	 */
	function get selector () : *; 
	
	/**
	 * The current state of this processor.
	 */
	function get state () : MessageState;

	/**
	 * The Context the object that sent the message belongs to.
	 * This value may be null. It is only set if the message was sent
	 * by an object managed by Parsley through one of the available options
	 * for dispatching a message (like ManagedEvents or MessageDispatchers).
	 * If the message was dispatched programmatically using the ScopeManager API,
	 * then the sender Context is unknown.
	 */
 	function get senderContext () : Context;
	
	/**
	 * Cancels processing of this message.
	 * No further handlers will be invoked and all resources associated with this message are disposed.
	 */
	function cancel () : void;
	
	/**
	 * Suspends processing of the message. No further handlers will be invoked
	 * before <code>resume</code> gets called on this processor.
	 * To permanently discard this message call <code>cancel</code> to free
	 * all resources associated with this message.
	 */
	function suspend () : void;
	
	/**
	 * Resumes with message processing, invoking the next receiver.
	 * May only be called after <code>suspend</code> has been called on this processor
	 */
	function resume () : void;
	
	/**
	 * Rewinds the processor so it will start with the first interceptor or handler again 
	 * the next time the proceed method gets invoked. Calling this method also causes
	 * all receivers to be refetched from the registry and thus takes into account
	 * any new receivers registered after processing this message started.
	 */
	function rewind () : void;
	
	/**
	 * Sends the response to the Context the message originated from.
	 * It does not send this message to the sending object instance only, as this would not be very
	 * helpful in most cases. Essentially this method is just a short cut for calling:
	 * <code><pre>processor.senderContext.scopeManager.dispatchMessage(new MyMessage());</pre></code>
	 * Note that the response is dispatched through all scopes of the Context of the sending instance,
	 * including the global scope. Therefor for point-to-point messaging the receiver of the response
	 * should listen to the local scope (or a custom scope) instead.
	 * 
	 * @param message the message to dispatch
	 * @param selector the selector to use if it cannot be determined from the message instance itself
	 */
	function sendResponse (msg:Object, selector:* = null) : void;
	
	/**
	 * Creates a Command instance for the specified value returned from a command object or method.
	 * The return value must be a value known by the <code>CommandFactoryRegistry</code>, like <code>AsyncToken</code>.
	 * The new command instance can then be passed to <code>Context.scopeManger.observeCommand()</code>
	 * or dealt with in any other way.
	 * 
	 * @param returnValue the value returned from a command object or method
	 * @return a Command instance for the specified return value  
	 */
	function createCommand (returnValue:*) : Command;
	
	
}
}
