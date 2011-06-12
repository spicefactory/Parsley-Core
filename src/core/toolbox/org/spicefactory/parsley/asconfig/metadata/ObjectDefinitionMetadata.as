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

package org.spicefactory.parsley.asconfig.metadata {

[Metadata(name="ObjectDefinition", types="property")]
/**
 * Represents a metadata tag that can be used to specify additional configuration for object definitions
 * in an ActionScript configuration class.
 * 
 * @author Jens Halm
 */
public class ObjectDefinitionMetadata {
	

	/**
	 * The id the object should be registered with.
	 */
	public var id:String;
	
	/**
	 * Indicates whether this object should be lazily initialized.
	 * If set to false the object will be instantiated upon Context initialization.
	 */
	public var lazy:Boolean = false;
	
	/**
	 * The processing order for this object. 
	 * 
	 * Only has an effect for non-lazy singletons. Those are instantiated when the
	 * Context initializes and this property allows to determine the initialization
	 * order of these singletons. Will be processed in ascending order.
	 */
	public var order:int = int.MAX_VALUE;
	
	
}

}
