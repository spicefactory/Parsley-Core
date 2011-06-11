/*
 * Copyright 2008-2009 the original author or authors.
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

package org.spicefactory.parsley.tag.lifecycle.legacy {
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;

[Deprecated(replacement="InitMethodDecorator")]
[Metadata(name="PostConstruct", types="method")]
[XmlMapping(elementName="post-construct")]
/**
 * @author Jens Halm
 */
public class PostConstructMethodDecorator implements ObjectDefinitionDecorator {


	[Target]
	/**
	 * @private
	 */
	public var method:String;
	
	
	/**
	 * @private
	 */
	public function decorate (definition:ObjectDefinition, registry:ObjectDefinitionRegistry) : ObjectDefinition {
		LogContext.getLogger(PostConstructMethodDecorator).warn("The PostConstruct tag is deprecated. It has been renamed to Init");
		definition.initMethod = method;
		return definition;
	}
	
	
}
}
