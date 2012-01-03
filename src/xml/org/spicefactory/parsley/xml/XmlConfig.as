/*
 * Copyright 2008-2009 the original author or authors.
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

package org.spicefactory.parsley.xml {

import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.xml.mapper.DefaultXmlTags;
import org.spicefactory.parsley.xml.processor.XmlConfigurationProcessor;

/**
 * Static entry point methods for creating XML configuration processors to be added to a ContextBuilder.
 * 
 * <p>Example:</p>
 * <pre><code>ContextBuilder
 *     .newInstance()
 *     .config(XmlConfig.forFile("config.xml"))
 *     .build();</code></pre>
 * 
 * <p>For details on XML configuration see 
 * <a href="http://www.spicefactory.org/parsley/docs/2.4/manual?page=config&amp;section=xml">3.3 XML Configuration</a>
 * in the Parsley Manual.</p>
 * 
 * @author Jens Halm
 */
public class XmlConfig {
	
	
	/**
	 * Creates a processor for the specified XML configuration file.
	 * 
	 * @param file the name of the file that contains the XML configuration
	 * @return a new configuration processor instance which can be added to a ContextBuilder
	 */
	public static function forFile (file:String) : ConfigurationProcessor {
		DefaultXmlTags.install();
		return new XmlConfigurationProcessor([file]);	
	}
	
	/**
	 * Creates a processor for the specified XML configuration files.
	 * 
	 * @param files the names of the files that contain the XML configuration
	 * @return a new configuration processor instance which can be added to a ContextBuilder
	 */
	public static function forFiles (...files) : ConfigurationProcessor {
		DefaultXmlTags.install();
		return new XmlConfigurationProcessor(files);	
	}
	
	/**
	 * Creates a processor for the specified XML configuration instance.
	 * 
	 * @param file the name of the file that contains the XML configuration
	 * @return a new configuration processor instance which can be added to a ContextBuilder
	 */
	public static function forInstance (xml:XML) : ConfigurationProcessor {
		DefaultXmlTags.install();
		var processor:XmlConfigurationProcessor = new XmlConfigurationProcessor([]);
		processor.addXml(xml);
		return processor;	
	}

	
}
}

