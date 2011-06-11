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

package org.spicefactory.parsley.core.context.provider {
import org.spicefactory.lib.reflect.ClassInfo;

/**
 * Provider for a (possibly lazily initializing) instance.
 * A provider for an object living in a Parsley Context can be obtained with 
 * <code>ObjectDefinitionRegistry.createObjectProvider</code>.
 * A simple wrapper for an existing instance can be obtained with
 * <code>Provider.forInstance</code>.
 * 
 * @author Jens Halm
 */
public interface ObjectProvider {
	
	
	/**
	 * The actual instance. May be null if it is a 
	 * lazy initializing provider.
	 */
	function get instance () : Object;
	
	/**
	 * The type of the instance.
	 * This property must be set even if the actual instance does not exist yet.
	 */
	function get type () : ClassInfo;
	
	
}
}
