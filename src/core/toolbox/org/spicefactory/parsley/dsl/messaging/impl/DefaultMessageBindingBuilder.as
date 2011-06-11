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
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionBuilderPart;
import org.spicefactory.parsley.dsl.messaging.MessageBindingBuilder;
import org.spicefactory.parsley.processor.messaging.MessageReceiverFactory;
import org.spicefactory.parsley.processor.messaging.MessageReceiverProcessorFactory;
import org.spicefactory.parsley.processor.messaging.receiver.MessageBinding;

/**
 * Default implementation for the MessageBindingBuilder interface.
 * 
 * @author Jens Halm
 */
public class DefaultMessageBindingBuilder implements MessageBindingBuilder, ObjectDefinitionBuilderPart {

	
	private var info:MessageReceiverInfo;
	private var targetProperty:Property;
	private var messagePropertyName:String;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param property the property to apply the binding to
	 * @param info the configuration for the binding
	 */
	function DefaultMessageBindingBuilder (property:Property, info:MessageReceiverInfo) {
		this.targetProperty = property;
		this.info = info;
	}

	/**
	 * @inheritDoc
	 */
	public function scope (name:String) : MessageBindingBuilder {
		info.scope = name;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function type (value:Class) : MessageBindingBuilder {
		info.type = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function selector (value:*) : MessageBindingBuilder {
		info.selector = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function order (value:int) : MessageBindingBuilder {
		info.order = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function messageProperty (value:String) : MessageBindingBuilder {
		messagePropertyName = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function apply (target:ObjectDefinition) : void {
		if (type == null) {
			throw new ContextError("type attribute must be specified for MessageBindings");
		}
		var messageType:ClassInfo = ClassInfo.forClass(info.type, info.config.domain);
		var factory:MessageReceiverFactory 
				= MessageBinding.newFactory(targetProperty.name, messageType, messagePropertyName, info.selector, info.order);
		target.addProcessorFactory(new MessageReceiverProcessorFactory(target, factory, info.config.context, info.scope));
	}
	
	
}
}
