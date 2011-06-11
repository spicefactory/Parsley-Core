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

package org.spicefactory.parsley.core.view.processor {
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.view.ViewConfiguration;
import org.spicefactory.parsley.core.view.ViewProcessor;

/**
 * Implementation of the ViewProcessor interface that injects an object into the target from the view
 * without adding the target itself to the Context and thus avoiding expensive reflection on the target.
 * 
 * @author Jens Halm
 */
public class FastInjectProcessor implements ViewProcessor {

	
	private static const log:Logger = LogContext.getLogger(FastInjectProcessor);
	
	
	private var property:String;
	private var type:Class;
	private var objectId:String;
	
	private var dynamicObject:DynamicObject;
	
	
	/**
	 * Creates a new event instance.
	 * 
	 * @param property the property to inject into
	 * @param type the type of the object to inject
	 * @param objectId the id of the object to inject
	 */
	function FastInjectProcessor (property:String, type:Class, objectId:String = null) {
		this.property = property;
		this.type = type;
		this.objectId = objectId;
		if (!type && !objectId) {
			throw new IllegalStateError("Either type or objectId must be specified for FastInject");
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function init (config:ViewConfiguration, context:Context) : void {
		var def:ObjectDefinition;
		if (type) {
			def = context.findDefinitionByType(type);
			if (!def) {
				throw new ContextError("Unsatisfied dependency: Context does not contain an object of type " 
					+ type);
			}
		}
		else {
			def = context.findDefinition(objectId);
			if (!def) {
				throw new ContextError("Unsatisfied dependency: Context does not contain an object with id " 
					+ objectId);
			}
		}
		var inject:Object;
		if (def is DynamicObjectDefinition) {
			dynamicObject = context.addDynamicDefinition(def as DynamicObjectDefinition);
			inject = dynamicObject.instance;
		}
		else {
			inject = def.registry.context.getObject(def.id);
		}
		config.target[property] = inject;
		log.debug("Fast-inject '{0}' into property {1} of {2}", inject, property, config.target);
	}
	
	/**
	 * @inheritDoc
	 */
	public function destroy () : void {
		if (dynamicObject) {
			log.debug("Remove dynamic dependency '{0}' from {1}", dynamicObject.instance, dynamicObject.context);
			dynamicObject.remove();
		}
	}
	
	
}
}
