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
 * MXML tag for declaring a properties represented by name/value pairs of a generic AS3 object.
 * 
 * <p>The tag can be used as a child tag of the ContextBuilder tag:</p>
 * 
 * <pre><code>&lt;parsley:ContextBuilder&gt;
 *     &lt;parsley:PropertiesObject&gt;
 *         &lt;fx:Object serviceUrl="http://www.company.com/services/" mediaPath="images"/&gt;
 *     &lt;/parsley:PropertiesObject&gt;
 *     &lt;parsley:FlexConfig type="{BookStoreConfig}"/&gt;
 *     &lt;parsley:XmlConfig file="logging.xml"/&gt;
 * &lt;/parsley:ContextBuilder&gt;</code></pre> 
 * 
 * @author Jens Halm
 */
public class PropertiesObjectTag implements BootstrapConfigProcessor {


	/**
	 * The reference to a generic Object that holds the properties as name/value
	 * pairs of its properties.
	 */
	public var ref:Object;
	
	
	/**
	 * @private
	 */
	public function processConfig (config:BootstrapConfig) : void {
		config.addProcessor(Properties.forObject(ref));
	}
	
	
}
}
