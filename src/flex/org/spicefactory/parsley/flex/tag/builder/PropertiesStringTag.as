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

package org.spicefactory.parsley.flex.tag.builder {
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.properties.Properties;

/**
 * MXML tag for declaring a String containing properties.
 * The tag supports the same syntax for the String reference as 
 * the PropertiesFile tag for loading external files. This could be useful
 * for external files that should not get loaded during runtime but instead
 * get compiled into the application.
 * 
 * <p>The tag can be used as a child tag of the ContextBuilder tag:</p>
 * 
 * <pre><code>&lt;mx:String id="properties" source="bookstore.properties" /&gt;
 * 
 * &lt;parsley:ContextBuilder&gt;
 *     &lt;parsley:PropertiesString source="{properties}"/&gt;
 *     &lt;parsley:FlexConfig type="{BookStoreConfig}"/&gt;
 *     &lt;parsley:XmlConfig file="logging.xml"/&gt;
 * &lt;/parsley:ContextBuilder&gt;</code></pre> 
 * 
 * For the supported syntax see:
 * @see org.spicefactory.parsley.properties.util.PropertiesParser
 * 
 * @author Jens Halm
 */
public class PropertiesStringTag implements BootstrapConfigProcessor {


	/**
	 * The reference to a String to be parsed and interpreted
	 * the same way as a loaded properties file.
	 */
	public var source:String;
	
	
	/**
	 * @private
	 */
	public function processConfig (config:BootstrapConfig) : void {
		config.addProcessor(Properties.forString(source));
	}
	
	
}
}
