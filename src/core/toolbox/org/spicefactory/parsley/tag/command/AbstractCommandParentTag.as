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

import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;

[DefaultProperty("commands")]
/**
 * Base class for any kind of tag that accepts an Array of command tags
 * as children.
 * 
 * @author Jens Halm
 */
public class AbstractCommandParentTag extends AbstractCommandTag {
	
	
	[ArrayElementType("org.spicefactory.parsley.tag.command.NestedCommandTag")]
	[ChoiceType("org.spicefactory.parsley.tag.command.NestedCommandTag")]
	/**
	 * The commands to be added to this command group or flow.
	 */
	public var commands:Array = new Array();
	
	
	public function resolve (config:Configuration) : ManagedCommandFactory {
		throw new AbstractMethodError();
	}
	
}
}
