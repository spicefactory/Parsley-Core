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
package org.spicefactory.parsley.command.tag.link {

import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.command.flow.CommandLink;
import org.spicefactory.parsley.command.tag.CommandConfiguration;
import org.spicefactory.parsley.core.builder.ObjectConfiguration;

/**
 * Interface to be implemented by all tags that represent command links.
 * 
 * @author Jens Halm
 */
public interface LinkTag extends ObjectConfiguration, CommandConfiguration {
	
	/**
	 * Builds a new command link instance based on the configuration
	 * of this tag.
	 * 
	 * @return a new command link instance
	 */
	function build (commands:Map) : CommandLink;
	
}
}
