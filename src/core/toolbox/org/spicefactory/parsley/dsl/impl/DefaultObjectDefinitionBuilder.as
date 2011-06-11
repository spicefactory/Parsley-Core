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

package org.spicefactory.parsley.dsl.impl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;
import org.spicefactory.parsley.dsl.core.ConstructorBuilder;
import org.spicefactory.parsley.dsl.core.DynamicObjectBuilder;
import org.spicefactory.parsley.dsl.core.EventBuilder;
import org.spicefactory.parsley.dsl.core.MethodBuilder;
import org.spicefactory.parsley.dsl.core.PropertyBuilder;
import org.spicefactory.parsley.dsl.core.SingletonBuilder;
import org.spicefactory.parsley.dsl.core.impl.DefaultConstructorBuilder;
import org.spicefactory.parsley.dsl.core.impl.DefaultDynamicObjectBuilder;
import org.spicefactory.parsley.dsl.core.impl.DefaultMethodBuilder;
import org.spicefactory.parsley.dsl.core.impl.DefaultPropertyBuilder;
import org.spicefactory.parsley.dsl.core.impl.DefaultSingletonBuilder;
import org.spicefactory.parsley.dsl.lifecycle.LifecycleBuilder;
import org.spicefactory.parsley.dsl.lifecycle.impl.DefaultLifecycleBuilder;
import org.spicefactory.parsley.tag.util.ReflectionUtil;

/**
 * Default implementation of the ObjectDefinitionBuilder interface.
 * 
 * @author Jens Halm
 */
public class DefaultObjectDefinitionBuilder implements ObjectDefinitionBuilder {


	private var context:ObjectDefinitionContext;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param context the context of the definition to build
	 */
	function DefaultObjectDefinitionBuilder (context:ObjectDefinitionContext) {
		this.context = context;
	}

	
	/**
	 * @inheritDoc
	 */
	public function get typeInfo () : ClassInfo {
		return context.targetType;
	}

	/**
	 * @inheritDoc
	 */
	public function get config () : Configuration {
		return context.config;
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function constructorArgs () : ConstructorBuilder {
		var builder:DefaultConstructorBuilder = new DefaultConstructorBuilder(context);
		context.addBuilderPart(builder);
		return builder;
	}
	
	/**
	 * @inheritDoc
	 */
	public function property (name:String) : PropertyBuilder {
		var property:Property = ReflectionUtil.getProperty(name, context.targetType, false, true);
		return new DefaultPropertyBuilder(property, context);
	}
	
	/**
	 * @inheritDoc
	 */
	public function method (name:String) : MethodBuilder {
		var method:Method = ReflectionUtil.getMethod(name, context.targetType);
		return new DefaultMethodBuilder(method, context);
	}
	
	/**
	 * @inheritDoc
	 */
	public function event (name:String) : EventBuilder {
		return new DefaultEventBuilder(context, name);
	}
	
	/**
	 * @inheritDoc
	 */
	public function lifecycle () : LifecycleBuilder {
		return new DefaultLifecycleBuilder(context);
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function asSingleton () : SingletonBuilder {
		return new DefaultSingletonBuilder(context, this);
	}
	
	/**
	 * @inheritDoc
	 */
	public function asDynamicObject () : DynamicObjectBuilder {
		return new DefaultDynamicObjectBuilder(context, this);
	}
}
}

import org.spicefactory.parsley.core.messaging.impl.MessageDispatcher;
import org.spicefactory.parsley.dsl.core.EventBuilder;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionContext;
import org.spicefactory.parsley.dsl.impl.ObjectProcessorBuilderPart;
import org.spicefactory.parsley.processor.messaging.ManagedEventsProcessor;

class DefaultEventBuilder implements EventBuilder {

	private var context:ObjectDefinitionContext;
	private var event:String;
	
	function DefaultEventBuilder (context:ObjectDefinitionContext, event:String) {
		this.context = context;
		this.event = event;
	}

	public function manage (scope:String = null) : void {
		var dispatcher:Function = new MessageDispatcher(context.config.context.scopeManager, scope).dispatchMessage;
		context.addBuilderPart(new ObjectProcessorBuilderPart(ManagedEventsProcessor.newFactory([event], dispatcher)));
	}
}



