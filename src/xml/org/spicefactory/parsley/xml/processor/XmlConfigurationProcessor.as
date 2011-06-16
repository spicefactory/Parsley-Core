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

package org.spicefactory.parsley.xml.processor {

import org.spicefactory.lib.events.CompoundErrorEvent;
import org.spicefactory.lib.expr.ExpressionContext;
import org.spicefactory.lib.expr.impl.DefaultExpressionContext;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.lib.xml.XmlObjectMapper;
import org.spicefactory.lib.xml.XmlProcessorContext;
import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.config.Configurations;
import org.spicefactory.parsley.config.RootConfigurationElement;
import org.spicefactory.parsley.core.bootstrap.AsyncConfigurationProcessor;
import org.spicefactory.parsley.core.errors.ConfigurationUnitError;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.xml.mapper.XmlObjectDefinitionMapperFactory;
import org.spicefactory.parsley.xml.tag.ObjectsTag;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * ObjectDefinitionBuilder implementation that processes XML configuration files.
 * This builder operates asynchronously.
 * 
 * @author Jens Halm
 */
public class XmlConfigurationProcessor extends EventDispatcher implements AsyncConfigurationProcessor {

	
	private static const log:Logger = LogContext.getLogger(XmlConfigurationProcessor);
	
	
	private var description:String;
	
	private var mapper:XmlObjectMapper;
	private var _loader:XmlConfigurationLoader;
	private var loadedFiles:Array = new Array();
	private var expressionContext:ExpressionContext;
	private var config:Configuration;

	
	/**
	 * Creates a new instance.
	 * 
	 * @param files the names of the XML configuration files
	 */
	function XmlConfigurationProcessor (files:Array, expressionContext:ExpressionContext = null, loader:XmlConfigurationLoader = null) {
		if (expressionContext == null) expressionContext = new DefaultExpressionContext();
		this.expressionContext = expressionContext;
		this._loader = (loader == null) ? new XmlConfigurationLoader(files, expressionContext) : loader;
		this.description = "XmlConfig{" + files.join(",") + "}";
	}

	
	/**
	 * The loader that loads the XML configuration files.
	 */	
	public function get loader () : XmlConfigurationLoader {
		return _loader;
	}
	
	/**
	 * Adds an XML reference containing Parsley XML configuration to be processed alongside the loaded files.
	 * 
	 * @param xml an XML reference containing Parsley XML configuration
	 */
	public function addXml (xml:XML) : void {
		loadedFiles.push(new XmlFile("<local XML reference>", xml));
	}
	
	/**
	 * @inheritDoc
	 */
	public function processConfiguration (registry:ObjectDefinitionRegistry) : void {
		expressionContext.addVariableResolver(new PropertiesResolver(registry.properties));
		this.config = Configurations.forRegistry(registry);
		var mapperFactory:XmlObjectDefinitionMapperFactory = new XmlObjectDefinitionMapperFactory(registry.domain);
		mapper = mapperFactory.createObjectDefinitionMapper();
		_loader.addEventListener(Event.COMPLETE, loaderComplete);
		_loader.addEventListener(ErrorEvent.ERROR, loaderError);
		_loader.load(registry.domain);
	}

	private function loaderComplete (event:Event) : void {
		loadedFiles = loadedFiles.concat(_loader.loadedFiles);
		processAllFiles(loadedFiles);
	}
	
	private function processAllFiles (files:Array) : void {
		var errors:Array = new Array();
		for each (var file:XmlFile in files) {
			try {
				processFile(file);
			}
			catch (e:Error) {
				log.error("Error processing {0}: {1}", file, e);
				errors.push(e);
			}
		}

		if (errors.length > 0) {
			var eventText:String = "One or more errors in XmlConfigurationProcessor";
			dispatchEvent(new CompoundErrorEvent(ErrorEvent.ERROR, errors, eventText));
		}
		else {
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
	
	private function processFile (file:XmlFile) : void {
		var context:XmlProcessorContext = new XmlProcessorContext(expressionContext, config.domain);
		var errors:Array;
		var container:ObjectsTag 
				= mapper.mapToObject(file.rootElement, context) as ObjectsTag;
		if (!context.hasErrors()) {
			errors = new Array();
			for each (var obj:Object in container.objects) {
				try {
					processObject(obj);
				} 
				catch (e:Error) {
					errors.push(e);		
				}
			}
		}	
		else {
			errors = context.errors;
		}
		if (errors.length > 0) {
			throw new ConfigurationUnitError(file, errors);
		}		
	}
	
	private function processObject (obj:Object) : void {
		try {
			if (obj is RootConfigurationElement) {
				RootConfigurationElement(obj).process(config);
			}
			else {
				createDefinition(obj);
			}
		}
		catch (e:Error) {
			log.error("Error processing {0}: {1}", obj, e);
			throw new ConfigurationUnitError(obj, [e]);
		}
	}
	
	private function createDefinition (obj:Object) : void {
		var idProp:Property = ClassInfo.forInstance(obj, config.domain).getProperty("id");
				
		config.builders
			.forInstance(obj)
				.asSingleton()
					.id((idProp == null) ? null : idProp.getValue(obj))
					.register();
	}
	
	private function loaderError (event:ErrorEvent) : void {
		dispatchEvent(event.clone());
	}
	
	/**
	 * @inheritDoc
	 */
	public function cancel () : void {
		_loader.cancel();
	}
	
	
	/**
	 * @private
	 */
	public override function toString () : String {
		return description;
	}
}
}

import org.spicefactory.lib.expr.VariableResolver;
import org.spicefactory.parsley.core.registry.ConfigurationProperties;

class PropertiesResolver implements VariableResolver {
	
	private var props:ConfigurationProperties;
	
	function PropertiesResolver (props:ConfigurationProperties) {
		this.props = props;
	}

	public function resolveVariable (variableName:String) : * {
		return props.getValue(variableName);
	}
	
}
