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

package org.spicefactory.parsley.properties {
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.properties.processor.PropertiesFileProcessor;
import org.spicefactory.parsley.properties.util.PropertiesParser;

/**
 * Static entry point methods for creating processors that load or parse properties to be added to a ContextBuilder.
 * 
 * <p>Example:</p>
 * <pre><code>ContextBuilder
 *     .newInstance()
 *     .config(Properties.forFile("config.properties"))
 *     .config(XmlConfig.forFile("config.xml"))
 *     .build();</code></pre>
 * 
 * @author Jens Halm
 */
public class Properties {
	
	
	/**
	 * Creates a processor that loads and processes a properties file.
	 * 
	 * @param file the name of the file
	 * @return a processor that loads and processes a properties file
	 */
	public static function forFile (file:String) : ConfigurationProcessor {
		return new PropertiesFileProcessor(file);
	}
	
	/**
	 * Creates a processor that parses the specified string into properties.
	 * The supported syntax is the same as for loaded files. 
	 * 
	 * @param string the string to parse
	 * @return a processor that parses the specified string into properties
	 */
	public static function forString (string:String) : ConfigurationProcessor {
		var parser:PropertiesParser = new PropertiesParser();
        var properties:Object = parser.parse(string);
		return new PropertiesProcessor(properties);
	}
	
	/**
	 * Creates a processor that adds the specified properties to the registry.
	 * The properties of the provided objects will be used as name/value pairs. 
	 * 
	 * @param object the object holding the property names and values
	 * @return a processor that adds the specified properties to the registry
	 */
	public static function forObject (object:Object) : ConfigurationProcessor {
		return new PropertiesProcessor(object);
	}
}
}

import org.spicefactory.parsley.core.builder.ConfigurationProcessor;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;

class PropertiesProcessor implements ConfigurationProcessor {
	
	protected var properties:Object;
	
	function PropertiesProcessor (properties:Object) {
		this.properties = properties;
	}

	public function processConfiguration (registry:ObjectDefinitionRegistry) : void {
		for (var name:String in properties) {
			registry.properties.setValue(name, properties[name]);
		}
	}
	
	public function toString () : String {
		return "Properties{<runtime>}";
	}
	
}
