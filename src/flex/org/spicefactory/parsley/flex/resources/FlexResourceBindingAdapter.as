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

package org.spicefactory.parsley.flex.resources {
import flash.events.Event;
import flash.events.EventDispatcher;
import mx.resources.ResourceManager;
import org.spicefactory.parsley.resources.processor.ResourceBindingAdapter;
import org.spicefactory.parsley.resources.processor.ResourceBindingEvent;



/**
 * Adapts the ResourceBinding facility to the Flex ResourceManager.
 * 
 * @author Jens Halm
 */
public class FlexResourceBindingAdapter extends EventDispatcher implements ResourceBindingAdapter {


	/**
	 * @private
	 */
	function FlexResourceBindingAdapter () {
		ResourceManager.getInstance().addEventListener(Event.CHANGE, dispatchUpdateEvent);
	}
	
	
	private function dispatchUpdateEvent (event:Event) : void {
		dispatchEvent(new ResourceBindingEvent(ResourceBindingEvent.UPDATE));
	}

	
	/**
	 * @inheritDoc
	 */
	public function getResource (bundle:String, key:String) :* {
		return ResourceManager.getInstance().getObject(bundle, key);
	}
	
	
}
}
