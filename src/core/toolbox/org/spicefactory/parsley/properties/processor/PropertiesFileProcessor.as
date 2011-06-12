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

package org.spicefactory.parsley.properties.processor {

import org.spicefactory.parsley.core.bootstrap.AsyncConfigurationProcessor;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.properties.Properties;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

/**
 * ConfigurationProcessor implementation that loads property files and adds the properties to the registry.
 * 
 * @author Jens Halm
 */
public class PropertiesFileProcessor extends EventDispatcher implements AsyncConfigurationProcessor {
	
	
    private var file:String;
    private var loader:URLLoader;
	private var registry:ObjectDefinitionRegistry;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param file the name of the property file to load
	 */
    public function PropertiesFileProcessor (file:String) {
        this.file = file;
    }

	/**
	 * @inheritDoc
	 */
    public function cancel () : void {
    	if (loader) {
	        loader.close();
	        loader = null;
    	}
    }

	/**
	 * @inheritDoc
	 */
    public function processConfiguration (registry:ObjectDefinitionRegistry) : void {
        this.registry = registry;

        var request:URLRequest = new URLRequest(file);
        loader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.TEXT;
        loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
        loader.addEventListener(IOErrorEvent.IO_ERROR, handleError);
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
        loader.load(request);
    }

    private function loadCompleteHandler (event:Event) : void {
        Properties.forString(loader.data).processConfiguration(registry);
		dispatchEvent(new Event(Event.COMPLETE));
    }


    private function handleError (event:IOErrorEvent) : void {
        var message:String = "Error loading properties file " + file + ": " + event.text;
        dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, message));
    }
    
    /**
	 * @private
	 */
	public override function toString () : String {
		return "Properties{" + file + "}";
	}
    
    
}
}