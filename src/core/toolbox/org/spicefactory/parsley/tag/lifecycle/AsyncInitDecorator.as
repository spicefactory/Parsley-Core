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

package org.spicefactory.parsley.tag.lifecycle {
import org.spicefactory.parsley.config.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.registry.AsyncInitConfig;
import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;

[Metadata(name="AsyncInit", types="class")]
[XmlMapping(elementName="async-init")]
/**
 * Represents a Metadata, MXML or XML tag that can be used to mark an object as being asynchronously initializing.
 * 
 * @author Jens Halm
 */
public class AsyncInitDecorator extends AsyncInitConfig implements ObjectDefinitionDecorator {


	/**
	 * @inheritDoc
	 */
	public function decorate (builder:ObjectDefinitionBuilder) : void {
		builder
			.lifecycle()
				.asyncInit()
					.completeEvent(completeEvent)
					.errorEvent(errorEvent);
	}
}
}
