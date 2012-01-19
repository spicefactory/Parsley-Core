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
 
package org.spicefactory.parsley.binding.metadata {

import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.lib.reflect.Metadata;
import org.spicefactory.parsley.binding.tag.PublishDecorator;
import org.spicefactory.parsley.binding.tag.PublishSubscribeDecorator;
import org.spicefactory.parsley.binding.tag.SubscribeDecorator;
import org.spicefactory.parsley.core.bootstrap.BootstrapConfigProcessor;


/**
 * Provides a static method to initalize the metadata tags for the decoupled binding facility.
 * Can be used as a child tag of a &lt;ContextBuilder&gt; tag in MXML alternatively.
 * The use of this class is only required when disabling the default set of metadata 
 * tags with <code>DefaultMetadataTags.disable()</code>, otherwise these tags will
 * be installed automatically.
 * 
 * @author Jens Halm
 */
public class BindingMetadataSupport implements BootstrapConfigProcessor {
	
	
	private static var initialized:Boolean = false;
	

	/**
	 * Initializes the support for the metadata tags for decoupled bindings.
	 * Must be invoked before building the first Context.
  	 */
	public static function initialize () : void {
		
		if (initialized) return;
		initialized = true;
		
		Metadata.registerMetadataClass(SubscribeDecorator);
		Metadata.registerMetadataClass(PublishDecorator);
		Metadata.registerMetadataClass(PublishSubscribeDecorator);
		
	}

	/**
	 * @private
	 */
	public function processConfig (config: BootstrapConfig): void {
		initialize();
	}
	
}
}
