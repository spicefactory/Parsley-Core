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

package org.spicefactory.parsley.tag.lifecycle {
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.core.context.provider.SynchronizedObjectProvider;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.scope.Scope;
import org.spicefactory.parsley.core.scope.ScopeName;

import flash.system.ApplicationDomain;

[Deprecated]
/**
 * @author Jens Halm
 */
public class AbstractSynchronizedProviderDecorator implements ObjectDefinitionDecorator {
	
	public var scope:String = ScopeName.GLOBAL;
	
	protected var domain:ApplicationDomain;
	
	protected var targetScope:Scope;
	
	public function decorate (definition:ObjectDefinition, registry:ObjectDefinitionRegistry) : ObjectDefinition {
		validate(definition, registry);
		domain = registry.domain;
		targetScope = registry.context.scopeManager.getScope(scope);
		definition.objectLifecycle.synchronizeProvider(handleProvider);
		return definition;
	}
	
	protected function validate (definition:ObjectDefinition, registry:ObjectDefinitionRegistry) : void {
		/* do nothing */
	}
	
	protected function handleProvider (provider:SynchronizedObjectProvider) : void {
		throw new AbstractMethodError();
	}
	
}
}
