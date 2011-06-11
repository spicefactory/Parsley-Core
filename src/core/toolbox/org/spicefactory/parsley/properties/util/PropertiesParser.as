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

package org.spicefactory.parsley.properties.util {

/**
 * Parses a string conforming to property file syntac into an object representing the name/value pairs in its properties.
 * 
 * <p>The supported syntax looks like this:</p>
 * 
 * <pre><code>name1=some value
 * name2 = another value
 * # a comment
 * name 3 = this is a \
 * multiline value</code></pre>
 * 
 * <p>The name and value pairs are delimited by a '=' character. Both name and value will be trimmed.
 * A comment line starts with the '#' character and will be ignored. The same goes for empty lines.
 * Multiline property values can be created through the use of the '\' character at the end of the line.</p>
 * 
 * @author Jens Halm
 */
public class PropertiesParser {


	/**
	 * Parses the specified string into name/value pairs represented by the properties of the returned object.
	 * 
	 * @param string the string to parse
	 * @return an object representing the name/value pairs
	 */
	public function parse (string:String) : Object {

		var result:Object = new Object();
        var lines:Array = string.replace("\n\r", "\n").split("\n");
        var multiline:Boolean = false;
        var currentValue:String;
        var currentName:String;
        for each (var line:String in lines) {
        	
           	line = trim(line);
           	
            if (multiline) {
            	currentValue += "\n";
            }
            else if (line.length && !isComment(line)) {
            	var split:Array = line.split("=", 2);
            	currentName = trim(split[0]);
            	if (!currentName.length) continue;
            	line = (split.length == 2) ? trim(split[1]) : "";
            	currentValue = "";
            }
            else {
            	continue;
            }
        	
        	multiline = isMultiline(line);
        	if (multiline) {
        		line = line.substring(0, line.length - 1);
        	}
        	
        	currentValue += line;
        	 
            if (!multiline) {
            	result[currentName] = currentValue;
            }
            
        }

		return result;
    }
    
    private function trim (string:String) : String {
    	return string.replace(/^\s+|\s+$/g, '');
    }
    
    private function isMultiline (string:String) : Boolean {
    	return (string.length) ? (string.lastIndexOf("\\") == string.length - 1) : false;
    }
    
    private function isComment (string:String) : Boolean {
    	return (string.indexOf("#") == 0);
    }

        
}
}