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
import org.spicefactory.parsley.core.bootstrap.BootstrapConfigProcessor;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;

[DefaultProperty("processor")]

/**
 * MXML tag for adding a custom configuration processor to a ContextBuilder.
 * 
 * <p>Example:</p>
 * 
 * <pre><code>&lt;parsley:ContextBuilder&gt;
 *     &lt;parsley:FlexConfig type="{BookStoreConfig}"/&gt;
 *     &lt;parsley:CustomConfig processor="{new MyDslProcessor()}"/&gt;
 * &lt;/parsley:ContextBuilder&gt;</code></pre> 
 * 
 * <p>Or:</p>
 * 
 * <pre><code>&lt;parsley:ContextBuilder&gt;
 *     &lt;parsley:FlexConfig type="{BookStoreConfig}"/&gt;
 *     &lt;parsley:CustomConfig&gt;
 *     	   &lt;custom:MyDslConfig someParam="someValue"/&gt;
 *     &lt;/parsley:CustomConfig&gt;
 * &lt;/parsley:ContextBuilder&gt;</code></pre>
 * 
 * @author Jens Halm
 */
public class CustomConfigTag implements BootstrapConfigProcessor {
	
	
	/**
	 * The actual processor.
	 */
	public var processor:ConfigurationProcessor;
	
	
	/**
	 * @private
	 */
	public function processConfig (config:BootstrapConfig) : void {
		config.addProcessor(processor);
	}
	
	
}
}
