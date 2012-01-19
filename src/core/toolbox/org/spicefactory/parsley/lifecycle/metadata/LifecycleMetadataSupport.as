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
package org.spicefactory.parsley.lifecycle.metadata {

import org.spicefactory.lib.reflect.Converters;
import org.spicefactory.lib.reflect.Metadata;
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.core.bootstrap.BootstrapConfigProcessor;
import org.spicefactory.parsley.core.processor.Phase;
import org.spicefactory.parsley.lifecycle.tag.AsyncInitDecorator;
import org.spicefactory.parsley.lifecycle.tag.DestroyMethodDecorator;
import org.spicefactory.parsley.lifecycle.tag.FactoryMethodDecorator;
import org.spicefactory.parsley.lifecycle.tag.InitMethodDecorator;
import org.spicefactory.parsley.lifecycle.tag.ObserveMethodDecorator;


/**
 * Provides a static method to initalize the lifecycle metadata tags.
 * Can be used as a child tag of a &lt;ContextBuilder&gt; tag in MXML alternatively.
 * The use of this class is only required when disabling the default set of metadata 
 * tags with <code>DefaultMetadataTags.disable()</code>, otherwise these tags will
 * be installed automatically.
 * 
 * @author Jens Halm
 */
public class LifecycleMetadataSupport implements BootstrapConfigProcessor {
	
	
	private static var initialized:Boolean = false;
	

	/**
	 * Initializes the support for the lifecycle metadata tags.
	 * Must be invoked before building the first Context.
  	 */
	public static function initialize () : void {
		
		if (initialized) return;
		initialized = true;
		
		Metadata.registerMetadataClass(FactoryMethodDecorator);
		Metadata.registerMetadataClass(InitMethodDecorator);
		Metadata.registerMetadataClass(DestroyMethodDecorator);
		Metadata.registerMetadataClass(ObserveMethodDecorator);
		Metadata.registerMetadataClass(AsyncInitDecorator);
		
		Converters.addConverter(Phase, new PhaseConverter());
		
	}
	
	/**
	 * @private
	 */
	public function processConfig (config: BootstrapConfig): void {
		initialize();
	}
	
}
}


import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.reflect.Converter;
import org.spicefactory.parsley.core.processor.DestroyPhase;
import org.spicefactory.parsley.core.processor.InitPhase;

import flash.system.ApplicationDomain;

class PhaseConverter implements Converter {

	public function convert (value: *, domain: ApplicationDomain = null): * {
		switch (value) {
			case "preInit": return InitPhase.preInit(int.MAX_VALUE);
			case "init": return InitPhase.init();
			case "postInit": return InitPhase.preInit(int.MIN_VALUE);
			case "preDestroy": return DestroyPhase.preDestroy(int.MAX_VALUE);
			case "destroy": return DestroyPhase.destroy();
			case "postDestroy": return DestroyPhase.postDestroy(int.MIN_VALUE);
			
			otherwise: throw new IllegalArgumentError("Not a valid constant for a phase: " + value);
		}
	}
	
}
