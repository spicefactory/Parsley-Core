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

package org.spicefactory.parsley.tag.command {

import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;
	
/**
 * @author Jens Halm
 */
public class CommandRefTag implements NestedCommandTag {


	public var idRef:String;


	public function resolve (config:Configuration) : ManagedCommandFactory {
		if (!idRef) throw IllegalStateError("idRef must be set");
		
		return new Factory(config.context, idRef);
	}
	
	
}
}

import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.core.command.ManagedCommandProxy;
import org.spicefactory.parsley.core.context.Context;

class Factory implements ManagedCommandFactory {

	private var context:Context;
	private var id:String;
	private var factory:ManagedCommandFactory;
	
	function Factory (context:Context, id:String) {
		this.context = context;
		this.id = id;
	}

	public function newInstance () : ManagedCommandProxy {
		if (!factory) {
			factory = context.getObject(id) as ManagedCommandFactory;
			if (!factory) {
				throw new IllegalStateError("Object with id " 
						+ id + " does not implement ManagedCommandFactory");
			}
		}
		return factory.newInstance();
	}

	public function get type () : ClassInfo {
		return context.findDefinition(id).type;
	}
	
	
}