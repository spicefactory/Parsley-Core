/*
 * Copyright 2009 the original author or authors.
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

package org.spicefactory.parsley.core.context.provider.impl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.context.provider.ObjectProviderFactory;

import flash.system.ApplicationDomain;

[Deprecated]
/**
 * @author Jens Halm
 */
public class ContextObjectProviderFactory implements ObjectProviderFactory {

	private var context:Context;
	private var domain:ApplicationDomain;
	private var providers:Array = new Array();
	private var initialized:Boolean = false;

	function ContextObjectProviderFactory (context:Context, domain:ApplicationDomain) {
		this.context = context;
		this.domain = domain;
	}

	public function initialize () : void {
		initialized = true;
		for each (var provider:ContextObjectProvider in providers) {
			provider.initialize();
		}
	}
	
	public function createProvider (type:Class, id:String = null) : ObjectProvider {
		var provider:ContextObjectProvider = new ContextObjectProvider(context, ClassInfo.forClass(type, domain), id);
		providers.push(provider);
		if (initialized) provider.initialize();
		return provider;
	}
	
}
}
