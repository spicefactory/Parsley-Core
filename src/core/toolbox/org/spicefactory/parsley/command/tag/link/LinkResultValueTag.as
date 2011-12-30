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

import org.spicefactory.lib.command.flow.LinkConditions;
import org.spicefactory.lib.command.flow.LinkCondition;

/**
 * Links a specific result value
 * to the the target command specified by this tag.
 * 
 * @author Jens Halm
 */
public class LinkResultValueTag extends AbstractLinkTag {
	
	
	[Attribute]
	/**
	 * The expected result value.
	 */
	public var value:*;
	
	
	/**
	 * @private
	 */
	protected override function get condition () : LinkCondition {
		return LinkConditions.forResultValue(value);
	}
	
	
}
}
