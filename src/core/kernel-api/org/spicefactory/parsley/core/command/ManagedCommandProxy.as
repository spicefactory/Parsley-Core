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

package org.spicefactory.parsley.core.command {
	
import org.spicefactory.lib.command.proxy.CommandProxy;

/**
 * Represent a single command proxy managed by the container.
 * 
 * @author Jens Halm
 */
public interface ManagedCommandProxy extends CommandProxy {
	
	
	/**
	 * The id the command is registered with in the Context.
	 */
	function get id () : String;
	
	
}
}
