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

package org.spicefactory.parsley.lifecycle.tag {

import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.processor.InitPhase;
import org.spicefactory.parsley.core.processor.Phase;
import org.spicefactory.parsley.lifecycle.Observe;

[Metadata(name="Observe", types="method", multiple="true")]
[XmlMapping(elementName="observe")]
/**
 * Represents a Metadata, MXML or XML tag that can be used on methods that should be invoked for
 * lifecycle events of other objects.
 * 
 * @author Jens Halm
 */
public class ObserveMethodDecorator implements ObjectDefinitionDecorator {


	[Target]
	/**
	 * The name of the method.
	 */
	public var method:String;

	/**
	 * The name of the scope to observe.
	 */
	public var scope:String;
	
	[Attribute]
	/**
	 * The object lifecycle phase to listen for. Default is postInit.
	 */
	public var phase:Phase;
	
	/**
	 * The (optional) id of the object to observe.
	 */
	public var objectId:String;
	

	/**
	 * @inheritDoc
	 */
	public function decorate (builder:ObjectDefinitionBuilder) : void {
		phase ||= InitPhase.postInit(int.MIN_VALUE);
		Observe
			.forMethod(method)
				.phase(phase)
				.scope(scope)
				.objectId(objectId)
					.apply(builder);
	}
	
	
}
}
