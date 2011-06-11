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

package org.spicefactory.parsley.core.factory {
import org.spicefactory.parsley.core.view.ViewAutowireFilter;

[Deprecated(replacement="BootstrapConfig.viewSettings or ViewSettings MXML tag")]
public interface ViewManagerFactory {
	
	function get autowireFilter () : ViewAutowireFilter;
	
	function set autowireFilter (value:ViewAutowireFilter) : void;
	
	function get viewRootRemovedEvent () : String;
	
	function set viewRootRemovedEvent (value:String) : void;

	function get componentRemovedEvent () : String;
	
	function set componentRemovedEvent (value:String) : void;

	function get componentAddedEvent () : String;
	
	function set componentAddedEvent (value:String) : void;
	
}
}
