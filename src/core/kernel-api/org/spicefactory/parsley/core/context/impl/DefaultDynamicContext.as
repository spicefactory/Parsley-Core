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

package org.spicefactory.parsley.core.context.impl {
import org.spicefactory.parsley.core.bootstrap.BootstrapInfo;
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.context.DynamicContext;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;

import flash.events.Event;
import flash.utils.Dictionary;

[Deprecated]
/**
 * @author Jens Halm
 */
public class DefaultDynamicContext extends DefaultContext implements DynamicContext {
	
	private var objects:Dictionary = new Dictionary();
	
	public override function init (info:BootstrapInfo) : void {
		super.init(info);
		addEventListener(ContextEvent.DESTROYED, contextDestroyed);
		registry.freeze();
	}
	
	public function addDefinition (definition:ObjectDefinition) : DynamicObject {
		checkState();
		checkDefinition(definition);
		var object:DynamicObject = new DefaultDynamicObject(this, DynamicObjectDefinition(definition));
		if (object.instance != null) {
			addDynamicObject(object);		
		}
		return object;
	}

	public function addObject (instance:Object, definition:ObjectDefinition = null) : DynamicObject {
		checkState();
		if (definition == null) {
			var ci:ClassInfo = ClassInfo.forInstance(instance, registry.domain);
			definition = registry.builders.forDynamicDefinition(ci.getClass()).build();
		}
		else {
			checkDefinition(definition);
		}
		var object:DynamicObject = new DefaultDynamicObject(this, DynamicObjectDefinition(definition), instance);
		addDynamicObject(object);
		return object;
	}
	
	private function checkDefinition (definition:ObjectDefinition) : void {
		if (definition is SingletonObjectDefinition) {
			throw new ContextError("SingletonObjectDefinition cannot be added to a DynamicContext");
		}
	}
	
	public function removeObject (instance:Object) : void {
		if (destroyed) return;
		var object:DefaultDynamicObject = DefaultDynamicObject(objects[instance]);
		if (object != null) {
			object.remove();
		}
	}
	
	private function contextDestroyed (event:Event) : void {
		removeEventListener(ContextEvent.DESTROYED, contextDestroyed);
		objects = null;
	}
	
	private function checkState () : void {
		if (destroyed) {
			throw new IllegalStateError("Attempt to access Context after it was destroyed");
		}
	}
	
}
}
