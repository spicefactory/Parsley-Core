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

package org.spicefactory.parsley.core.state {
import org.spicefactory.parsley.core.bootstrap.impl.GlobalStateAccessor;

/**
 * Holds global state information for all currently active Contexts.
 * It is provided in a read-only format and can be consumed by application code or extensions as required.
 * 
 * @author Jens Halm
 */
public class GlobalState {
	
	
	/**
	 * Global status information about managed objects.
	 */
	public static function get objects () : GlobalObjectState {
		return GlobalStateAccessor.objects;
	}

	/**
	 * Global status information about currently active scopes.
	 */
	public static function get scopes () : GlobalScopeState {
		return GlobalStateAccessor.scopes;
	}
	
	
}
}
