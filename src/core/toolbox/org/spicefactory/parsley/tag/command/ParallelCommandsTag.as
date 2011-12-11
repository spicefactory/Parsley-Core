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

package org.spicefactory.parsley.tag.command {

import org.spicefactory.lib.command.group.ParallelCommands;
	
[XmlMapping(elementName="parallel-commands")]

/**
 * Tag for parallel commands declared in MXML or XML configuration.
 * 
 * @author Jens Halm
 */
public class ParallelCommandsTag extends AbstractCommandGroupTag {
	
	
	/**
	 * @private
	 */
	function ParallelCommandsTag () {
		super(ParallelCommands);
	}
	
	
}
}
