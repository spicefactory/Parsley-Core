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

package org.spicefactory.parsley.dsl.messaging.impl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionBuilderPart;
import org.spicefactory.parsley.dsl.messaging.MessageErrorBuilder;
import org.spicefactory.parsley.processor.messaging.MessageReceiverFactory;
import org.spicefactory.parsley.processor.messaging.MessageReceiverProcessorFactory;
import org.spicefactory.parsley.processor.messaging.receiver.DefaultMessageErrorHandler;

/**
 * Default implementation for the MessageErrorBuilder interface.
 * 
 * @author Jens Halm
 */
public class DefaultMessageErrorBuilder implements MessageErrorBuilder, ObjectDefinitionBuilderPart {

	
	private var info:MessageReceiverInfo;
	private var targetMethod:Method;
	private var _errorType:Class;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param method the target method that handles the error
	 * @param info the configuration for the binding
	 */
	function DefaultMessageErrorBuilder (method:Method, info:MessageReceiverInfo) {
		this.targetMethod = method;
		this.info = info;
	}

	/**
	 * @inheritDoc
	 */
	public function scope (name:String) : MessageErrorBuilder {
		info.scope = name;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function type (value:Class) : MessageErrorBuilder {
		info.type = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function selector (value:*) : MessageErrorBuilder {
		info.selector = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function order (value:int) : MessageErrorBuilder {
		info.order = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function errorType (type:Class) : MessageErrorBuilder {
		_errorType = type;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function apply (target:ObjectDefinition) : void {
		var errorTypeInfo:ClassInfo 
				= (_errorType != null) ? ClassInfo.forClass(_errorType, info.config.domain) : null;
		var factory:MessageReceiverFactory 
				= DefaultMessageErrorHandler.newFactory(targetMethod.name, info.type, info.selector, errorTypeInfo, info.order);
		target.addProcessorFactory(new MessageReceiverProcessorFactory(target, factory, info.config.context, info.scope));
	}
	
	
}
}
