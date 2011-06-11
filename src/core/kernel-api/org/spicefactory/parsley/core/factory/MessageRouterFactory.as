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

package org.spicefactory.parsley.core.factory {
import org.spicefactory.parsley.core.messaging.ErrorPolicy;
import org.spicefactory.parsley.core.messaging.command.CommandFactory;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;

[Deprecated(replacement="BootstrapConfig.messageSettings or MessageSettings MXML tag")]
public interface MessageRouterFactory {
	
	function get unhandledError () : ErrorPolicy;

	function set unhandledError (policy:ErrorPolicy) : void;
	
	function addErrorHandler (target:MessageErrorHandler) : void;

	function addCommandFactory (type:Class, factory:CommandFactory) : void;
	
}
}
