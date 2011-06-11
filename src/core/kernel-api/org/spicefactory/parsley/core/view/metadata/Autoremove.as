/*
 * Copyright 2010 the original author or authors.
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
 
package org.spicefactory.parsley.core.view.metadata {

[Metadata(name="Autoremove", types="class", multiple="false")]
/**
 * Represents a metadata tag that can be used to specify whether the component should 
 * be removed from the Context when it is removed from stage.
 * If not specified the value from
 * <code>ViewSettings.autoremoveComponent</code> or <code>ViewSettings.autoremoveViewRoots</code> respectively will be used.
 * 
 * @author Jens Halm
 */
public class Autoremove {
	
	
	[DefaultProperty]
	/**
	 * Indicates whether the component should 
 	 * be removed from the Context when it is removed from stage.
	 */
	public var value:Boolean = true;
	
	
}
}
