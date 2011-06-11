/*
 * Copyright 2008-2009 the original author or authors.
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

package org.spicefactory.parsley.core.registry.definition.impl {
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.definition.MethodParameterRegistry;
import org.spicefactory.parsley.core.registry.definition.MethodRegistry;

import flash.utils.Dictionary;

[Deprecated]
/**
 * @author Jens Halm
 */
public class DefaultMethodRegistry extends AbstractRegistry implements MethodRegistry {

	private var methods:Dictionary = new Dictionary();
	private var targetType:ClassInfo;

	function DefaultMethodRegistry (def:ObjectDefinition) {
		super(def);
		this.targetType = def.type;
	}

	public function addTypeReferences (methodName:String) : void {
		checkState();
		var mpr:MethodParameterRegistry = addMethod(methodName);
		var params:Array = mpr.method.parameters;
		if (params.length == 0) {
			throw new IllegalArgumentError("Cannot add type references for method without parameters: Method "
					+ mpr.method.name + " in class " + targetType.name);
		}
		for (var i:uint = 0; i < params.length; i++) {
			mpr.addTypeReference();
		}
	}

	public function addMethod (methodName:String) : MethodParameterRegistry {
		checkState();
		var method:Method = getMethodReference(targetType, methodName);
		var mpr:MethodParameterRegistry = new DefaultMethodParameterRegistry(method, definition);
		methods[methodName] = mpr;
		return mpr;
	}

	private function getMethodReference (type:ClassInfo, name:String) : Method {
		var method:Method = type.getMethod(name);
		if (method == null) {
			throw new IllegalArgumentError("Method with name " + name + " does not exist in Class " + type.name);
		}
		return method;
	}
	
	public function removeMethod (methodName:String) : void {
		checkState();
		delete methods[methodName];
	}
	
	public function getMethod (methodName:String) : MethodParameterRegistry {
		return methods[methodName];
	}
	
	public function getAll () : Array {
		var all:Array = new Array();
		for each (var pv:Object in methods) {
			all.push(pv);	
		}
		return all;
	}
	
}

}
