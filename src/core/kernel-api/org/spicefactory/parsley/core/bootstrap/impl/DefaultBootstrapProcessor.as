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

package org.spicefactory.parsley.core.bootstrap.impl {
import org.spicefactory.lib.events.CompoundErrorEvent;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.bootstrap.AsyncConfigurationProcessor;
import org.spicefactory.parsley.core.bootstrap.BootstrapInfo;
import org.spicefactory.parsley.core.bootstrap.BootstrapProcessor;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.core.builder.AsyncObjectDefinitionBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.errors.ContextBuilderError;
import org.spicefactory.parsley.core.events.ContextEvent;

import flash.events.ErrorEvent;
import flash.events.Event;

/**
 * Default implementation of the BootstrapProcessor interface.
 * 
 * @author Jens Halm
 */
public class DefaultBootstrapProcessor implements BootstrapProcessor {
	
	
	private static const log:Logger = LogContext.getLogger(DefaultBootstrapProcessor);
	
	
	private var processors:Array = new Array();
	private var currentProcessor:Object;
	
	private var errors:Array = new Array();
	private var async:Boolean = false;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param info the environment, holding setting and collaborating services to use when building the new Context.
	 */
	function DefaultBootstrapProcessor (info:BootstrapInfo) {
		_info = info;
	}
	
	private var _info:BootstrapInfo;
		
	/**
	 * @inheritDoc
	 */
	public function get info () : BootstrapInfo {
		return _info;
	}
	
	/**
	 * @inheritDoc
	 */
	public function addProcessor (processor:ConfigurationProcessor) : void {
		processors.push(processor);
	}
	
	/**
	 * @inheritDoc
	 */
	public function process () : Context {
		info.context.addEventListener(ContextEvent.DESTROYED, contextDestroyed);
		invokeNextProcessor();
		if (currentProcessor != null) {
			async = true;
		}
		return _info.context;
	}
	
	private function invokeNextProcessor () : void {
		if (processors.length == 0) {
			info.context.removeEventListener(ContextEvent.DESTROYED, contextDestroyed);
			if (errors.length > 0) {
				handleErrors();
			}
			else {
				info.context.addEventListener(ErrorEvent.ERROR, contextError);
				info.registry.freeze();
				info.context.removeEventListener(ErrorEvent.ERROR, contextError);
				if (errors.length > 0) {
					handleErrors();
				}
			}
		}
		else {
			var async:Boolean = false;
			try {
				var processor:Object = processors.shift();
				if (processor is ConfigurationProcessor) {
					async = !handleProcessor(ConfigurationProcessor(processor));
				}
				else {
					async = !handleLegacyBuilder(ObjectDefinitionBuilder(processor));
				}
			} catch (e:Error) {
				removeCurrentProcessor();
				log.error("Error processing {0}: {1}", e);
				errors.push(e);
			}
			if (!async)	invokeNextProcessor();
		}
	}
	
	private function handleProcessor (processor:ConfigurationProcessor) : Boolean {
		if (processor is AsyncConfigurationProcessor) {
			currentProcessor = processor;
			var asyncProcessor:AsyncConfigurationProcessor = AsyncConfigurationProcessor(processor);
			asyncProcessor.addEventListener(Event.COMPLETE, processorComplete);				
			asyncProcessor.addEventListener(ErrorEvent.ERROR, processorError);		
			asyncProcessor.processConfiguration(info.registry);
			return false;
		}
		else {
			ConfigurationProcessor(processor).processConfiguration(info.registry);
			return true;
		}
	}
	
	private function handleLegacyBuilder (builder:ObjectDefinitionBuilder) : Boolean {
		/* TODO - deprecated - remove in later versions */
		if (builder is AsyncObjectDefinitionBuilder) {
			currentProcessor = builder;
			var asyncBuilder:AsyncObjectDefinitionBuilder = AsyncObjectDefinitionBuilder(builder);
			asyncBuilder.addEventListener(Event.COMPLETE, processorComplete);				
			asyncBuilder.addEventListener(ErrorEvent.ERROR, processorError);		
			asyncBuilder.build(info.registry);
			return false;
		}
		else {
			builder.build(info.registry);
			return true;
		}
	}
	
	private function handleErrors () : void {
		var msg:String = "One or more errors in BootstrapProcessor";
		if (async) {
			info.context.dispatchEvent(new CompoundErrorEvent(ErrorEvent.ERROR, errors, msg));
		}
		else {
			throw new ContextBuilderError(msg, errors);
		}		
	}
	
	private function processorComplete (event:Event) : void {
		removeCurrentProcessor();
		invokeNextProcessor();
	}
	
	private function processorError (event:ErrorEvent) : void {
		removeCurrentProcessor();
		log.error(event.text);
		errors.push(event);
		invokeNextProcessor();
	}
	
	private function removeCurrentProcessor () : void {
		if (currentProcessor == null) return;
		currentProcessor.removeEventListener(Event.COMPLETE, processorComplete);				
		currentProcessor.removeEventListener(ErrorEvent.ERROR, processorError);
		currentProcessor = null;			
	}
	
	private function contextError (event:ErrorEvent) : void {
		log.error("Error initializing Context: " + event.text);
		errors.push(event);
	}
	
	private function contextDestroyed (event:Event) : void {
		info.context.removeEventListener(ContextEvent.DESTROYED, contextDestroyed);
		if (currentProcessor != null) {
			currentProcessor.cancel();
		}
	}
	
	
}
}
