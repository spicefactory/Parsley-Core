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
import org.spicefactory.parsley.core.binding.Subscriber;
import org.spicefactory.parsley.core.context.Context;

/**
 * A publisher that observes the value of a single property and uses its value
 * as the published value and subscribes to the values of other matching publishers at the same time. 
 * 
 * @author Jens Halm
 */
public class SubscribingPropertyPublisher extends PropertyPublisher implements Subscriber {


	private var subscriber:Subscriber;

	
	/**
	 * Creates a new instance.
	 * 
	 * @param target the instance that holds the property to observe
	 * @param property the target property that holds the published value
	 * @param type the type of the published value
	 * @param id the id the value is published with
	 * @param context the corresponding Context in case the published object should be managed
	 * @param changeEvent the event type that signals that the property value has changed (has no effect in Flex applications)
	 */
	function SubscribingPropertyPublisher (target:Object, property:Property, 
			type:ClassInfo = null, id:String = null, context:Context = null, changeEvent:String = null) {
		super(target, property, type, id, context, changeEvent);
		this.subscriber = new PropertySubscriber(target, property, type, id);
	}


	/**
	 * @inheritDoc
	 */	
	public function update (newValue:*) : void {
		enabled = false;
		try {
			subscriber.update(newValue);
		}
		finally {
			enabled = true;
		}
	}
	
	/**
	 * @private
	 */
	public override function toString () : String {
		return super.toString() + " with matching [Subscriber]";
	}


}
}
