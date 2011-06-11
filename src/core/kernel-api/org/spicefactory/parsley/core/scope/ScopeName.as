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

package org.spicefactory.parsley.core.scope {

/**
 * Enumeration for the two builtin scope types.
 * 
 * @author Jens Halm
 */
public class ScopeName {
	
	
	/**
	 * Constant for the name of the global scope.
	 * 
	 * <p>A global scope spans the entire Context hierarchy and is inherited by each
	 * child Context added to the hierarchy. It is not necessarily global application-wide,
	 * since you can build disconnected Context hierachies, although this is a rather rare use case.</p>
	 */
	public static const GLOBAL:String = "global";

	/**
	 * Constant for the name of the local scope.
	 * 
	 * <p>A local scope only spans a single Context. Such a scope is automatically created for each
	 * Context created in an application.</p>
	 */
	public static const LOCAL:String = "local";
	
	
}
}
