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
package org.spicefactory.parsley.tag.command.link {

import org.spicefactory.lib.command.flow.LinkConditions;
import org.spicefactory.lib.command.flow.LinkCondition;

/**
 * Links results that contain the specified property value
 * to the the target command specified by this tag.
 * 
 * @author Jens Halm
 */
public class LinkResultPropertyTag extends AbstractLinkTag {
	
	
	/**
	 * The name of the property.
	 */
	public var name:String;
	
	/**
	 * The value of the property.
	 */
	public var value:*;
	
	
	/**
	 * @private
	 */
	protected override function get condition () : LinkCondition {
		return LinkConditions.forResultProperty(name, value);
	}
	
	
}
}
