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
package org.spicefactory.parsley.flex.binding {

import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.binding.PropertyWatcher;

import mx.binding.utils.BindingUtils;
import mx.binding.utils.ChangeWatcher;

/**
 * Implementation of the PropertyWatcher interface that relies on the
 * Flex Binding architecture for observing property changes.
 * 
 * @author Jens Halm
 */
public class FlexPropertyWatcher implements PropertyWatcher {


	private var callback: Function;
	private var changeWatcher: ChangeWatcher;


	/**
	 * @inheritDoc
	 */
	public function watch (target: Object, property: Property, changeEvent: String, callback: Function): void {
		this.callback = callback;
		changeWatcher = BindingUtils.bindSetter(propertyChanged, target, property.name);
	}
	
	private function propertyChanged (value: *): void {
		callback(value);
	}

	/**
	 * @inheritDoc
	 */
	public function unwatch (): void {
		changeWatcher.unwatch();
		changeWatcher = null;
		callback = null;
	}
	
	
}
}
