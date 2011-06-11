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
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;

[Deprecated(replacement="org.spicefactory.parsley.core.lifecycle.LifecycleObserverRegistry")]
public interface ObjectLifecycleScope {
	
	function addListener (type:Class, event:ObjectLifecycle, listener:Function, id:String = null) : void;

	function removeListener (type:Class, event:ObjectLifecycle, listener:Function, id:String = null) : void;
	
	function addProvider (provider:ObjectProvider, methodName:String, event:ObjectLifecycle, id:String = null) : void;

	function removeProvider (provider:ObjectProvider, methodName:String, event:ObjectLifecycle, id:String = null) : void;

	
}
}
