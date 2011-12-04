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

package org.spicefactory.parsley.flex.command {

import mx.rpc.AsyncToken;
import mx.rpc.Responder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
/**
 * Result processor for commands that produce an AsyncToken as a result.
 * This allows for transparent replacement of the AsyncToken with the result
 * or fault it generates.
 * 
 * @author Jens Halm
 */
public class AsyncTokenResultProcessor {
	
	
	private var active: Boolean;
	private var callback: Function;
	
	
	/**
	 * Processes the specified token.
	 * 
	 * @param token the AsyncToken result of a command
	 * @param callback the function to invoke once the result or fault is available 
	 */
	public function execute (token: AsyncToken, callback: Function): void {
		this.callback = callback;
		active = true;
		token.addResponder(new Responder(result, fault));
	}
	
	private function result (event: ResultEvent): void {
		if (!active) return;
		callback(event.result);
		active = false;
	}
	
	private function fault (event: FaultEvent): void {
		if (!active) return;
		callback(event.fault);
		active = false;
	}
	
	/**
	 * Cancels the result processor, discarding any result of the
	 * AsyncToken.
	 */
	public function cancel (): void {
		active = false;
	}
	
	
}
}
