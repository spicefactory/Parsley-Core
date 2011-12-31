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
package org.spicefactory.parsley.core.processor {
	
/**
 * Represents a phase in the lifecycle of an object processor.
 * 
 * @author Jens Halm
 */
public interface Phase {
	

	/**
	 * The key representation of the type of this phase (init or destroy phase)
	 * without the exact ordering detail.
	 */	
	function get typeKey (): String;
	
	
}
}
