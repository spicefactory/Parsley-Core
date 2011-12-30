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
import org.spicefactory.lib.events.NestedErrorEvent;
import org.spicefactory.lib.expr.ExpressionContext;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.xml.XmlObjectMapper;
import org.spicefactory.lib.xml.XmlProcessorContext;
import org.spicefactory.lib.xml.mapper.XmlObjectMappings;
import org.spicefactory.parsley.xml.events.XmlFileEvent;
import org.spicefactory.parsley.xml.events.XmlFileProgressEvent;
import org.spicefactory.parsley.xml.mapper.XmlObjectDefinitionMapperFactory;
import org.spicefactory.parsley.xml.tag.Include;
import org.spicefactory.parsley.xml.tag.Variable;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;

/**
 * Responsible for loading Parsley XML configuration files.
 * 
 * @author Jens Halm
 */
public class XmlConfigurationLoader extends EventDispatcher {
	
	
	private static var log:Logger = LogContext.getLogger(XmlConfigurationLoader);
	
	
	private var files:Array;
	
	private var _currentFile:String;
	private var _currentLoader:URLLoader;
	
	private var _loadedFiles:Array = new Array();
	
	private var expressionContext:ExpressionContext;
	private var domain:ApplicationDomain;
	
	private var variableMapper:XmlObjectMapper;
	private var includeMapper:XmlObjectMapper;

	
	/**
	 * Creates a new instance.
	 * 
	 * @param files the names of the files to load
	 * @param expressionContext the expression context to use for preprocessing the loaded files
	 */
	function XmlConfigurationLoader (files:Array, expressionContext:ExpressionContext) {
		this.files = files;
		this.expressionContext = expressionContext;
	}
	
	
	/**
	 * The files that were already loaded. An Array of <code>XmlFile</code> instances.
	 */
	public function get loadedFiles () : Array {
		return _loadedFiles.concat();
	}
	
	/**
	 * The name of the file currently loading.
	 */
	public function get currentFile () : String {
		return _currentFile;
	}

	
	/**
	 * Loads the XML configuration files.
	 * 
	 * @param domain the ApplicationDomain for preprocessing the loaded files
	 */
	public function load (domain:ApplicationDomain) : void {
		this.domain = domain;
		variableMapper = XmlObjectMappings
			.forNamespace(XmlObjectDefinitionMapperFactory.PARSLEY_NAMESPACE_URI)
			.withRootElement(Variable, domain)
			.build();
		includeMapper = XmlObjectMappings
			.forNamespace(XmlObjectDefinitionMapperFactory.PARSLEY_NAMESPACE_URI)
			.withRootElement(Include, domain)
			.build();
		dispatchEvent(new Event(Event.INIT));
		loadNextFile();
	}
	
	private function loadNextFile () : void {
		if (files.length == 0) {
			_currentFile = null;
			dispatchEvent(new Event(Event.COMPLETE));
			return;
		}
		_currentFile = files.shift(); 
		log.debug("Start loading next file: {0}", _currentFile);
		loadFile(_currentFile);
	}
	
	/**
	 * Starts the loading operation for a single file.
	 * 
	 * @param file the name of the file to load
	 */
	protected function loadFile (file:String) : void {
		log.info("Start loading XML configuration file {0}", file);
		_currentLoader = new URLLoader();
		_currentLoader.addEventListener(Event.COMPLETE, fileComplete);
		_currentLoader.addEventListener(IOErrorEvent.IO_ERROR, fileError);
		_currentLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fileError);
		_currentLoader.addEventListener(ProgressEvent.PROGRESS, fileProgress);
		_currentLoader.dataFormat = URLLoaderDataFormat.TEXT;
		_currentLoader.load(new URLRequest(file));
		dispatchEvent(new XmlFileEvent(XmlFileEvent.FILE_INIT, file));
	}

	private function fileProgress (event:ProgressEvent) : void {
		dispatchEvent(new XmlFileProgressEvent(XmlFileProgressEvent.FILE_PROGRESS, _currentFile, event.bytesLoaded, event.bytesTotal));
	}
	
	private function fileError (evt:ErrorEvent) : void {
		handleError("Error in URLLoader", evt);
	}
	
	private function fileComplete (event:Event) : void {
		if (_currentLoader == null) return;
		log.info("Loaded XML File {0}", _currentFile);
		handleLoadedFile(_currentLoader.data);
	}
	
	/**
	 * Invoked when the loading operation for a single file has completed.
	 * 
	 * @param fileContent the content of the file as a String (containing the loaded XML)
	 */
	protected function handleLoadedFile (fileContent:String) : void {
		var xml:XML;
		try {
			xml = new XML(fileContent);
		} catch (e:Error) {
			handleError("XML Parser error", e);
			return;
		}
		try {
			preprocess(xml);
		} catch (e:Error) {
			handleError("Error preprocessing XML context definition", e);
			return;
		}
		_loadedFiles.push(new XmlFile(_currentFile, xml));
		loadedFiles.push(xml);
		loadNextFile();
	}

	/**
	 * Invoked when the loading operation for a single file failed.
	 * 
	 * @param message the error message
	 * @param cause the cause of the failure
	 */
	protected function handleError (message:String, cause:Object = null) : void {
		var msg:String = "Error loading " + _currentFile + ": " + message;
		if (cause == null) {
			log.error(msg);
		}
		else {
			log.error(msg + "{0}", cause);
		}
		dispatchEvent(new NestedErrorEvent(ErrorEvent.ERROR, cause, msg)); 
	}

	/**
	 * Preprocesses the loaded XML. This includes processing variable elements and include elements.
	 * For each include element the name of the file will be added to the internal list of files to load.
	 * After preprocessing variable and include nodes will be removed from the XML as the main
	 * XML-to-Object Mapper for Parsley XML configuration does not know/accept them (and wouldn't be
	 * able to deal with them).
	 * 
	 * @param xml the loaded XML to preprocess
	 */
	protected function preprocess (xml:XML) : void {
		var parsley:Namespace = new Namespace(XmlObjectDefinitionMapperFactory.PARSLEY_NAMESPACE_URI);
		var context:XmlProcessorContext = new XmlProcessorContext(expressionContext, domain);
		for each (var variableXml:XML in xml.parsley::variable) {
			var variable:Variable = variableMapper.mapToObject(variableXml, context) as Variable;
			expressionContext.setVariable(variable.name, variable.value);
		}
		for each (var includeXml:XML in xml[new QName(XmlObjectDefinitionMapperFactory.PARSLEY_NAMESPACE_URI, "include")]) {
			var incl:Include = includeMapper.mapToObject(includeXml, context) as Include;
			files.push(incl.filename);
		}
		delete xml.parsley::variable;
		delete xml[new QName(XmlObjectDefinitionMapperFactory.PARSLEY_NAMESPACE_URI, "include")]; // necessary since include is a keyword
		if (context.hasErrors()) {
			var msg:String = "One or more errors preprocessing loaded xml: ";
			for each (var xmlError:Error in context.errors) {
				msg += "\n" + xmlError.message;
			}
			handleError(msg);
		}
	}
	
	/**
	 * Cancels the loading operation.
	 */
	public function cancel () : void {
		_currentLoader.close();
		_currentLoader = null;
		_currentFile = null;
		_loadedFiles = new Array();
	}
	
	
}
}


