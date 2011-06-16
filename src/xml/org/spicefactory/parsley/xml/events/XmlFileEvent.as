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
 
package org.spicefactory.parsley.xml.events {
import flash.events.Event;

/**
 * Event dispatched when an XML file loading operation starts or completes.
 * 
 * @author Jens Halm
 */
public class XmlFileEvent extends Event {


	/**
	 * Constant for the type of event dispatched when an XML file starts to load.
	 * 
	 * @eventType org.spicefactory.parsley.xml.events.XmlFileEvent.FILE_INIT
	 */
	public static const FILE_INIT : String = "fileInit";
	
	/**
	 * Constant for the type of event dispatched when an XML file has completed to load.
	 * 
	 * @eventType org.spicefactory.parsley.xml.events.XmlFileEvent.FILE_COMPLETE
	 */
	public static const FILE_COMPLETE : String = "fileComplete";
	
	
	private var _filename:String;
	
	
	/**
	 * Creates a new event instance.
	 * 
	 * @param type the type of this event
	 * @param filename the name of the XML configuration file
	 */
	public function XmlFileEvent (type:String, filename:String) {
		super(type);
		_filename = filename;
	}		
	
	
	/**
	 * The name of the XML configuration file.
	 */
	public function get filename () : String {
		return _filename;
	}	
	
	
	/**
	 * @private
	 */
	public override function clone () : Event {
		return new XmlFileEvent(type, filename);
	}		
		
		
}
	
}