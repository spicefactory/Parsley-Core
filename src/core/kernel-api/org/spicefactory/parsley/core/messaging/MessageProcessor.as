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
	function get message () : Message;
	
	/**
	 * The current state of this processor.
	 */
	function get state () : MessageState;

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
	
	
}
}
