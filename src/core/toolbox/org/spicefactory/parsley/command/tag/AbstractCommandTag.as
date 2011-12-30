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
	
/**
 * Base tag for commands declared in MXML or XML configuration.
 * 
 * @author Jens Halm
 */
public class AbstractCommandTag {
	
	
	/**
	 * The id of the command.
	 * May be used to identify a command in a flow declared in XML
	 * (not necessary in MXML) or for matching CommandResult handlers.
	 */
	public var id:String;
	
	
	private var _links:Array = new Array();
	
	/**
	 * The links of this command tag in case it represents a command
	 * in a flow.
	 */
	public function get links () : Array {
		return _links;
	}
	
	[ArrayElementType("org.spicefactory.parsley.command.tag.link.LinkTag")]
	[ChoiceType("org.spicefactory.parsley.command.tag.link.LinkTag")]
	public function set links (value:Array) : void {
		_links = value;
	}
	
	
}
}
