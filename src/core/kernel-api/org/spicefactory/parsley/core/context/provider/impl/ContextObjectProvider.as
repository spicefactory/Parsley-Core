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

package org.spicefactory.parsley.core.context.provider.impl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;

import flash.utils.getQualifiedClassName;

[Deprecated]
/**
 * @author Jens Halm
 */
public class ContextObjectProvider implements ObjectProvider {
	
	private var _type:ClassInfo;
	private var id:String;
	private var context:Context;
	private var initialized:Boolean = false;
	
	function ContextObjectProvider (context:Context, type:ClassInfo, id:String = null) {
		this.context = context;
		this._type = type;
		this.id = id;
	}

	public function initialize () : void {
		if (id != null) {
			if (!context.containsObject(id)) {
				throw new ContextError("Invalid ObjectProvider: Context does not contain an object with id " + id);
			}
			if (!type.isType(context.getType(id))) {
				throw new ContextError("Invalid ObjectProvider: Object with id " + id 
						+ " has an incompatible type - Expected type: " + type.name 
						+ " - Actual type: " + getQualifiedClassName(context.getType(id)));
			}
		}
		else {
			var cnt:int = context.getObjectCount(type.getClass());
			if (cnt != 1) {
				throw new ContextError("Invalid ObjectProvider: Context must contain exactly one object of type " + type.name);
			}
			id = context.getObjectIds(type.getClass())[0];
		}
		initialized = true;
	}
	
	public function get instance () : Object {
		return (initialized) ? context.getObject(id) : null;
	}
	
	public function get type () : ClassInfo {
		return _type;
	}
	
}
}
