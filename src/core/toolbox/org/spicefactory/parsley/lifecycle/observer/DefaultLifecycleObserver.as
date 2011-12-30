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

package org.spicefactory.parsley.lifecycle.observer {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.lifecycle.LifecycleObserver;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;

/**
 * Default implementation of the LifecycleObserver interface.
 * 
 * @author Jens Halm
 */
public class DefaultLifecycleObserver implements LifecycleObserver {

	
	private var provider:ObjectProvider;
	private var targetMethod:Method;
	
	private var _observedType:ClassInfo;
	private var _event:ObjectLifecycle;
	private var _objectId:String;
	
	
	/**
	 * Creates a new instance.
	 * The target method must have a single parameter that matches the observed type.
	 * 
	 * @param provider the provider for the actual instance that contains the observer method
	 * @param method the name of the observer method
	 * @param phase the phase of the object lifecycle that should trigger the observer
	 * @param objectId the optional id of the object as registered in the Context
	 * @param explicitType the type of object to observe
	 */	
	function DefaultLifecycleObserver (provider:ObjectProvider, method:String, 
			phase:ObjectLifecycle = null, objectId:String = null, explicitType:ClassInfo = null) {
		this.provider = provider;
		this._event = phase;
		this._objectId = objectId;
		this.targetMethod = provider.type.getMethod(method);
		if (targetMethod == null) {
			throw new ContextError("Target instance of type " + provider.type.name 
					+ " does not contain a method with name " + method);
		}
		this._observedType = getObservedType(provider, method, explicitType);
	}

	
	private function getObservedType (provider:ObjectProvider, method:String, explicitType:ClassInfo) : ClassInfo {
		if (targetMethod.parameters.length != 1) {
			throw new ContextError("Target " + targetMethod  
				+ ": Exactly one parameter required for a lifecycle observer methods.");
		}
		var param:Parameter = targetMethod.parameters[0];
		if (explicitType == null) {
			return param.type;
		}
		else if (!explicitType.isType(param.type.getClass())) {
			throw new ContextError("Target " + method
				+ ": Method parameter of type " + param.type.name
				+ " is not applicable to observed type " + explicitType.name);
		}
		else {
			return explicitType;
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function get observedType () : Class {
		return _observedType.getClass();
	}

	/**
	 * @inheritDoc
	 */
	public function get phase () : ObjectLifecycle {
		return _event;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get objectId () : String {
		return _objectId;
	}
	
	/**
	 * @inheritDoc
	 */	
	public function observe (observed:Object) : void {
		targetMethod.invoke(provider.instance, [observed]);
	}
	
	
}
}
