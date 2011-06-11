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

package org.spicefactory.parsley.core.messaging.command {
import org.spicefactory.parsley.core.messaging.Message;

/**
 * A factory responsible for creating Command instances based on the return value of
 * the command method. For each supported return type (like AsyncToken for remoting for example)
 * a <code>CommandFactory</code> must be registered with the framework with
 * <code>GlobalFactoryRegistry.instance.messageRouter.addCommandFactory</code>.
 * 
 * @author Jens Halm
 */
public interface CommandFactory {
	
	
	/**
	 * Creates a new Command instance.
	 * 
	 * @param returnValue the value returned by the method that executed the command
	 * @param message the message that triggered the command execution
	 * @return a new Command instance 
	 */
	function createCommand (returnValue:Object, message:Message) : Command;
	
	
}
}
