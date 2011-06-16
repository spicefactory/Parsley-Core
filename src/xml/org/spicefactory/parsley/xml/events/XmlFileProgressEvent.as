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
import flash.events.ProgressEvent;

/**
 * Event dispatched for signalling progress of an XML loading operation.
 * 
 * @author Jens Halm
 */
public class XmlFileProgressEvent extends ProgressEvent {


	/**
	 * Constant for the type of event dispatched to signal progress of an XML loading operation.
	 * 
	 * @eventType org.spicefactory.parsley.xml.events.XmlFileProgressEvent.FILE_PROGRESS
	 */
	public static const FILE_PROGRESS : String = "fileProgress";
	
	
	private var _filename:String;
	
	
	/**
	 * Creates a new event instance.
	 * 
	 * @param type the type of this event
	 * @param filename filename the name of the XML configuration file
	 * @param bytesLoaded the number of bytes already loaded
	 * @param bytesTotal the total number of bytes
	 */
	public function XmlFileProgressEvent (type:String, filename:String, bytesLoaded:int, bytesTotal:int) {
		super(type, false, false, bytesLoaded, bytesTotal);
		_filename = filename;
	}		
	
	
	/**
	 * The name of the XML configuration file.
	 */
	public function get filename () : String {
		return _filename;
	}
		
		
}
	
}