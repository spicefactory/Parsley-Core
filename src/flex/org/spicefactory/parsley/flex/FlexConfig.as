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

package org.spicefactory.parsley.flex {
import org.spicefactory.parsley.core.builder.ConfigurationProcessor;
import org.spicefactory.parsley.flex.processor.FlexConfigurationProcessor;

/**
 * Static entry point methods for creating MXML configuration processors to be added to a ContextBuilder.
 * 
 * <p>Example:</p>
 * <pre><code>ContextBuilder
 *     .newInstance()
 *     .config(FlexConfig.forClass(MyConfig))
 *     .build();</code></pre>
 * 
 * <p>For details on MXML configuration see 
 * <a href="http://www.spicefactory.org/parsley/docs/2.4/manual?page=config&amp;section=mxml">3.2 MXML Configuration</a>
 * in the Parsley Manual.</p>
 * 
 * @author Jens Halm
 */
public class FlexConfig {
	
	
	/**
	 * Creates a processor for the specified MXML configuration class.
	 * 
	 * @param configClass the class that contains the MXML configuration
	 * @return a new configuration processor instance which can be added to a ContextBuilder
	 */
	public static function forClass (configClass:Class) : ConfigurationProcessor {
		return new FlexConfigurationProcessor([configClass]);	
	}
	
	/**
	 * Creates a processor for the specified MXML configuration classes.
	 * 
	 * @param configClasses the classes that contain the MXML configuration
	 * @return a new configuration processor instance which can be added to a ContextBuilder
	 */
	public static function forClasses (...configClasses) : ConfigurationProcessor {
		return new FlexConfigurationProcessor(configClasses);
	}
	
	
}
}

