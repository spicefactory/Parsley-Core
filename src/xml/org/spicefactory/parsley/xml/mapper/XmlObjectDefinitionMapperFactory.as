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

package org.spicefactory.parsley.xml.mapper {

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.types.Any;
import org.spicefactory.lib.reflect.types.Void;
import org.spicefactory.lib.xml.XmlObjectMapper;
import org.spicefactory.lib.xml.mapper.SimpleValueMapper;
import org.spicefactory.lib.xml.mapper.XmlObjectMappings;
import org.spicefactory.parsley.binding.decorator.PublishDecorator;
import org.spicefactory.parsley.binding.decorator.PublishSubscribeDecorator;
import org.spicefactory.parsley.binding.decorator.SubscribeDecorator;
import org.spicefactory.parsley.tag.command.CommandFactoryTag;
import org.spicefactory.parsley.tag.command.CommandFlowTag;
import org.spicefactory.parsley.tag.command.CommandRefTag;
import org.spicefactory.parsley.tag.command.CommandSequenceTag;
import org.spicefactory.parsley.tag.command.CommandTag;
import org.spicefactory.parsley.tag.command.MapCommandTag;
import org.spicefactory.parsley.tag.command.ParallelCommandsTag;
import org.spicefactory.parsley.tag.command.link.LinkAllResultsTag;
import org.spicefactory.parsley.tag.command.link.LinkResultPropertyTag;
import org.spicefactory.parsley.tag.command.link.LinkResultTypeTag;
import org.spicefactory.parsley.tag.command.link.LinkResultValueTag;
import org.spicefactory.parsley.tag.core.ArrayTag;
import org.spicefactory.parsley.tag.core.ConstructorTag;
import org.spicefactory.parsley.tag.core.DynamicObjectTag;
import org.spicefactory.parsley.tag.core.DynamicPropertyTag;
import org.spicefactory.parsley.tag.core.NestedObjectTag;
import org.spicefactory.parsley.tag.core.ObjectReferenceTag;
import org.spicefactory.parsley.tag.core.PropertyTag;
import org.spicefactory.parsley.tag.core.RootObjectTag;
import org.spicefactory.parsley.tag.core.ViewTag;
import org.spicefactory.parsley.tag.lifecycle.AsyncInitDecorator;
import org.spicefactory.parsley.tag.lifecycle.DestroyMethodDecorator;
import org.spicefactory.parsley.tag.lifecycle.FactoryMethodDecorator;
import org.spicefactory.parsley.tag.lifecycle.InitMethodDecorator;
import org.spicefactory.parsley.tag.lifecycle.ObserveMethodDecorator;
import org.spicefactory.parsley.tag.messaging.CommandCompleteDecorator;
import org.spicefactory.parsley.tag.messaging.CommandErrorDecorator;
import org.spicefactory.parsley.tag.messaging.CommandResultDecorator;
import org.spicefactory.parsley.tag.messaging.CommandStatusDecorator;
import org.spicefactory.parsley.tag.messaging.MessageBindingDecorator;
import org.spicefactory.parsley.tag.messaging.MessageDispatcherDecorator;
import org.spicefactory.parsley.tag.messaging.MessageErrorDecorator;
import org.spicefactory.parsley.tag.resources.ResourceBindingDecorator;
import org.spicefactory.parsley.xml.tag.ManagedEventsDecoratorTag;
import org.spicefactory.parsley.xml.tag.MessageHandlerDecoratorTag;
import org.spicefactory.parsley.xml.tag.ObjectsTag;

import flash.system.ApplicationDomain;

/**
 * Factory that builds the XML-to-Object mappers for the Parsley XML configuration format.
 * Built upon the Spicelib XML-to-Object Mapping Framework.
 * 
 * @author Jens Halm
 */
public class XmlObjectDefinitionMapperFactory {
	

	/**
	 * The main Parsley XML configuration namespace.
	 */
	public static const PARSLEY_NAMESPACE_URI:String = "http://www.spicefactory.org/parsley";
	
	/**
	 * @private
	 */
	public static const CHOICE_ID_ROOT_ELEMENTS:String = "rootElements";
	/**
	 * @private
	 */
	public static const CHOICE_ID_NESTED_ELEMENTS:String = "nestedElements";
	/**
	 * @private
	 */
	public static const CHOICE_ID_DECORATORS:String = "decorators";

	private var domain:ApplicationDomain;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param domain the ApplicationDomain to use for reflection.
	 */
	function XmlObjectDefinitionMapperFactory (domain:ApplicationDomain = null) {
		this.domain = domain;
	}
	
	
	/**
	 * Creates the mapper for the root objects tag of Parsley XML configuration files.
	 * 
	 * @return the mapper for the root objects tag of Parsley XML configuration files
	 */
	public function createObjectDefinitionMapper () : XmlObjectMapper {
		
		var mappings:XmlObjectMappings = XmlObjectMappings
			.forNamespace(PARSLEY_NAMESPACE_URI)
				.withRootElement(ObjectsTag, domain)
					.customMapper(new NullXmlObjectMapper())
					.customMapper(new StaticPropertyRefMapper(domain))
					.customMapper(createSimpleValueMapper(Boolean, "boolean"))
					.customMapper(createSimpleValueMapper(Number, "number"))
					.customMapper(createSimpleValueMapper(int, "int"))
					.customMapper(createSimpleValueMapper(uint, "uint"))
					.customMapper(createSimpleValueMapper(String, "string"))
					.customMapper(createSimpleValueMapper(Date, "date"))
					.customMapper(createSimpleValueMapper(Class, "class"))
				    .choiceId(CHOICE_ID_DECORATORS, ConstructorTag, PropertyTag, DynamicPropertyTag, 
				    								AsyncInitDecorator, FactoryMethodDecorator, 
				    								InitMethodDecorator, DestroyMethodDecorator, ObserveMethodDecorator,
				    								MessageHandlerDecoratorTag, MessageBindingDecorator,
				    								MessageErrorDecorator, MessageDispatcherDecorator,
				    								CommandResultDecorator, CommandCompleteDecorator,
				    								CommandErrorDecorator, CommandStatusDecorator,
				    								ManagedEventsDecoratorTag, ResourceBindingDecorator,
				    								PublishDecorator, PublishSubscribeDecorator, SubscribeDecorator)
				    .choiceId(CHOICE_ID_ROOT_ELEMENTS, RootObjectTag, DynamicObjectTag, ViewTag, CommandFactoryTag, MapCommandTag)
				    .choiceId(CHOICE_ID_NESTED_ELEMENTS, ArrayTag, ObjectReferenceTag, NestedObjectTag,
				    								CommandTag, CommandFlowTag, CommandSequenceTag, ParallelCommandsTag,
				    								LinkResultTypeTag, LinkResultValueTag, LinkResultPropertyTag,
				    								LinkAllResultsTag, CommandRefTag, 
				    								Void, Any, Boolean, Number, int, uint, String, Date, Class);
		
		addCustomConfigurationNamespaces(mappings);
		
		return mappings.build();
	}
	
	private function addCustomConfigurationNamespaces (mappings:XmlObjectMappings) : void {
		var namespaces:Array = XmlConfigurationNamespaceRegistry.getAllNamespaces();
		for each (var ns:XmlObjectMappings in namespaces) {
			mappings.mergedMappings(ns);
		}
	}
	
	private function createSimpleValueMapper (type:Class, tagName:String) : XmlObjectMapper {
		return new SimpleValueMapper(ClassInfo.forClass(type), new QName(PARSLEY_NAMESPACE_URI, tagName));
	}
}
}

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.types.Any;
import org.spicefactory.lib.reflect.types.Void;
import org.spicefactory.lib.xml.XmlObjectMapper;
import org.spicefactory.lib.xml.XmlProcessorContext;
import org.spicefactory.lib.xml.mapper.AbstractXmlObjectMapper;
import org.spicefactory.lib.xml.mapper.PropertyMapperBuilder;
import org.spicefactory.parsley.xml.mapper.XmlObjectDefinitionMapperFactory;
import org.spicefactory.parsley.xml.tag.StaticPropertyRef;

import flash.errors.IllegalOperationError;
import flash.system.ApplicationDomain;

class NullXmlObjectMapper extends AbstractXmlObjectMapper {
	
	function NullXmlObjectMapper () {
		super(ClassInfo.forClass(Void), new QName(XmlObjectDefinitionMapperFactory.PARSLEY_NAMESPACE_URI, "null"));
	}
	
	public override function mapToObject (element:XML, context:XmlProcessorContext = null) : Object {
		return null;
	}

	public override function mapToXml (object:Object, context:XmlProcessorContext = null) : XML {
		return <null/>;
	}
	 
}

class StaticPropertyRefMapper extends AbstractXmlObjectMapper {
	
	private var delegate:XmlObjectMapper;
	
	function StaticPropertyRefMapper (domain:ApplicationDomain) {
		super(ClassInfo.forClass(Any), new QName(XmlObjectDefinitionMapperFactory.PARSLEY_NAMESPACE_URI, "static-property"));
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(StaticPropertyRef, elementName, null, domain);
		builder.mapAllToAttributes();
		delegate = builder.build();
	}
	
	public override function mapToObject (element:XML, context:XmlProcessorContext = null) : Object {
		var ref:StaticPropertyRef = delegate.mapToObject(element, context) as StaticPropertyRef;
		return (ref != null) ? ref.resolve(context.applicationDomain) : null;
	}

	public override function mapToXml (object:Object, context:XmlProcessorContext = null) : XML {
		throw new IllegalOperationError("This mapper does not support mapping back to XML");
	}	
	
	
}

