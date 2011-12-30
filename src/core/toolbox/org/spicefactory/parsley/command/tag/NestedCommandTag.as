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

package org.spicefactory.parsley.command.tag {

import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
	
/**
 * Represents a tag that produces a command and can be nested
 * inside other command tags.
 * 
 * @author Jens Halm
 */
public interface NestedCommandTag extends CommandConfiguration {
	
	
	/**
	 * Creates a new command factory based on the configuration of this tag.
	 * 
	 * @registry the registry this tag is associated with
	 * @return a new command factory based on the configuration of this tag
	 */
	function resolve (registry:ObjectDefinitionRegistry) : ManagedCommandFactory;
	
	/**
	 * The links of this command tag in case it represents a command
	 * in a flow.
	 */
	function get links () : Array;
	
	
}
}
