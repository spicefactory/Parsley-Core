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
 
package org.spicefactory.parsley.binding.impl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.binding.Subscriber;

/**
 * A Subscriber that updates the value of a single property whenever the
 * value of matching publishers changes.
 * 
 * @author Jens Halm
 */
public class PropertySubscriber extends AbstractSubscriber implements Subscriber {

	
	private var target:Object;
	private var property:Property;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param target the instance that holds the property to observe
	 * @param property the target property that holds the published value
	 * @param type the type of the published value
	 * @param id the id the value is published with
	 */
	function PropertySubscriber (target:Object, property:Property, type:ClassInfo = null, id:String = null) {
		super(type ? type : property.type, id);
		this.target = target;
		this.property = property;
	}
	
	/**
	 * @inheritDoc
	 */
	public function update (newValue:*) : void {
		property.setValue(target, newValue);
	}
	
	/**
	 * @private
	 */
	public override function toString () : String {
		return "[Subscriber(property=" + property.name + ",type=" + type.name 
				+ ((id) ? ",id=" + id : "") + ")]";
	}
	
	
}
}
