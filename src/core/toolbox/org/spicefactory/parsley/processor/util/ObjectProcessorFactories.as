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

package org.spicefactory.parsley.processor.util {
import org.spicefactory.parsley.core.registry.ObjectProcessorFactory;

/**
 * Utility methods for creating ObjectProcessorFactory instances.
 * 
 * @author Jens Halm
 */
public class ObjectProcessorFactories {
	
	
	/**
	 * Create a new processor factory instance of the specified type, using the provided constructor arguments.
	 * The specified arguments will always be added to the target argument of type <code>ManagedObject</code>
	 * which will always be the first argument. The specified type must implement the <code>ObjectProcessor</code>
	 * interface.
	 * 
	 * @param processorType the type of processor to create
	 * @param additionalArgs constructor arguments for the processor in addition to the target argument
	 * @return a new ObjectProcessorFactory instance
	 */
	public static function newFactory (processorType:Class, additionalArgs:Array = null) : ObjectProcessorFactory {
		if (additionalArgs == null) additionalArgs = [];
		return new SimpleObjectProcessorFactory(processorType, additionalArgs);
	}
	
	
}
}

import org.spicefactory.lib.util.ClassUtil;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.ObjectProcessor;
import org.spicefactory.parsley.core.registry.ObjectProcessorFactory;

class SimpleObjectProcessorFactory implements ObjectProcessorFactory {

	private var processorType:Class;
	private var additionalArgs:Array;

	function SimpleObjectProcessorFactory (processorType:Class, additionalArgs:Array) {
		this.processorType = processorType;
		this.additionalArgs = additionalArgs;
	}

	public function createInstance (target:ManagedObject) : ObjectProcessor {
		var args:Array = additionalArgs.concat();
		args.unshift(target);
		return ObjectProcessor(ClassUtil.createNewInstance(processorType, args));
	}
	
}