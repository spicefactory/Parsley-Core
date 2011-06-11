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
import org.spicefactory.parsley.core.context.LookupStatus;

/**
 * A registry to obtain CommandFactories from. 
 * For each supported return type (like AsyncToken for remoting for example)
 * a <code>CommandFactory</code> must be registered with the framework with
 * <code>GlobalFactoryRegistry.instance.messageRouter.addCommandFactory</code>.
 * 
 * @author Jens Halm
 */
public interface CommandFactoryRegistry {
	
	
	/**
	 * Returns the factory registered for the specified return type.
	 * 
	 * @param returnValue the value returned by the method executing the command
	 * @param status optional paramater to avoid duplicate lookups, for internal use only
	 * @return the factory registered for the specified return value
	 */
	function getCommandFactory (returnValue:Object, status:LookupStatus = null) : CommandFactory;
	
	/**
	 * Adds a factory that creates Command instances for all command methods
	 * that have the specified return type.
	 * 
	 * @param returnType the return type of the command methods the specified factory is responsible for
	 * @param factory the factory to add
	 */
	function addCommandFactory (returnType:Class, factory:CommandFactory) : void;
	
	
}
}
