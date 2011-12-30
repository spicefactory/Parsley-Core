/*
 * Copyright 2011 the original author or authors.
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
package org.spicefactory.parsley.core.processor.impl {

import org.spicefactory.parsley.core.processor.StatefulProcessor;
import org.spicefactory.parsley.core.processor.ObjectProcessor;
import org.spicefactory.parsley.core.processor.InitPhase;
import org.spicefactory.parsley.core.processor.DestroyPhase;
import org.spicefactory.lib.reflect.Member;
import org.spicefactory.parsley.core.processor.ObjectProcessorConfig;

/**
 * Default implementation of the ObjectProcessorConfig interface.
 * The configuration instance encapsulates the target processor and clones
 * it if necessary when <code>prepareForNextTarget</code> is invoked.
 * 
 * @author Jens Halm
 */
public class DefaultObjectProcessorConfig implements ObjectProcessorConfig {


	private var singleton: Boolean;
	private var initializer: Function;


	/**
	 * Creates a new instance.
	 * 
	 * @param processor the processor configured by this instance
	 * @param init the phase the processor should be invoked in during initialization
	 * @param destroy the phase the processor should be invoked in when the target gets removed from the Context
	 * @param target the member (property or method - if any) to get processed
	 * @param singleton whether the processor gets applied to a singleton definition
	 * @param initializer the initializer to call before handing out a new processor
	 */
	function DefaultObjectProcessorConfig (processor: ObjectProcessor,
			init: InitPhase, destroy: DestroyPhase, target: Member = null,
			singleton: Boolean = false, initializer: Function = null) {
			
		_processor = processor;
		_target = target;

		_initPhase = init;
		_destroyPhase = destroy;
				
		this.singleton = singleton;
		this.initializer = initializer;
		
		if (!cloneRequired) initialize(processor);
	}


	private function initialize (processor: ObjectProcessor): void {
		if (initializer != null) initializer(processor);
	}
	
	
	private function get cloneRequired (): Boolean {
		return !singleton && (processor is StatefulProcessor);
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function prepareForNextTarget (): ObjectProcessorConfig {
		if (cloneRequired) {
			var newProcessor: ObjectProcessor = StatefulProcessor(processor).clone();
			initialize(newProcessor);
			return new DefaultObjectProcessorConfig(newProcessor, initPhase, destroyPhase, target, singleton, initializer);
		}
		else {
			return this;
		}
	}


	private var _processor: ObjectProcessor;

	/**
	 * @inheritDoc
	 */
	public function get processor (): ObjectProcessor {
		return _processor;
	}


	private var _initPhase: InitPhase;
	
	/**
	 * @inheritDoc
	 */
	public function get initPhase (): InitPhase {
		return _initPhase;
	}


	private var _destroyPhase: DestroyPhase;

	/**
	 * @inheritDoc
	 */
	public function get destroyPhase (): DestroyPhase {
		return _destroyPhase;
	}


	private var _target: Member;

	/**
	 * @inheritDoc
	 */
	public function get target (): Member {
		return _target;
	}
	
	
}
}
