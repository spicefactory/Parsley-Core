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

package org.spicefactory.parsley.core.state.manager.impl {

import org.spicefactory.lib.command.builder.CommandGroupBuilder;
import org.spicefactory.lib.command.builder.Commands;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.state.manager.GlobalDomainManager;

import flash.system.ApplicationDomain;
import flash.utils.Dictionary;

/**
 * Default implementation of the GlobalDomainManager interface.
 * 
 * @author Jens Halm
 */
public class DefaultGlobalDomainManager implements GlobalDomainManager {
	

	private static const log:Logger = LogContext.getLogger(DefaultGlobalDomainManager);
	
	private const domainCounter:Dictionary = new Dictionary();
	private const domainByContext:Dictionary = new Dictionary();
	private const domainPurgeHandlers:Dictionary = new Dictionary();
	private const domainByCustomKey:Dictionary = new Dictionary();
	
	
	/**
	 * @inheritDoc
	 */
	public function addPurgeHandler (domain:ApplicationDomain, handler:Function, ...params) : void {
		params.unshift(domain);
		params.unshift(handler);
		var chain:CommandGroupBuilder = CommandGroupBuilder(domainPurgeHandlers[domain]);
		if (chain) chain.add(Commands.delegate.apply(null, params));
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function putIfAbsent (key:Object, domain:ApplicationDomain) : ApplicationDomain {
		if (domainByCustomKey[key]) {
			log.info("Using registered ApplicationDomain for key " + key);
			return domainByCustomKey[key] as ApplicationDomain;
		}
		log.info("Using new ApplicationDomain for key " + key);
		domainByCustomKey[key] = domain;
		return domain;
	}
	
	/**
	 * Manages the domain of the specified Context until it gets destroyed.
	 * 
	 * @param domain the domain to add to the cache
	 */
	public function addContext (context:Context) : void {
		var domain:ApplicationDomain = context.domain;
		if (domainCounter[domain] != undefined) {
			domainCounter[domain]++;
		}
		else {
			domainCounter[domain] = 1;
		}
		if (domainPurgeHandlers[domain] == undefined) {
			domainPurgeHandlers[domain] = Commands.asSequence();
		}
		domainByContext[context] = domain;
		context.addEventListener(ContextEvent.DESTROYED, contextDestroyed, false, -100);
	}

	private function contextDestroyed (event:ContextEvent) : void {
		var context:Context = event.target as Context;
		context.removeEventListener(ContextEvent.DESTROYED, contextDestroyed);
		var domain:ApplicationDomain = domainByContext[context];
		if (!domain) return;
		delete domainByContext[context];
		if (domainCounter[domain] == undefined) {
			log.warn("No counter available for ApplicationDomain");
			return;
		}
		if (domainCounter[domain] > 1) {
			domainCounter[domain]--;
		}
		else {
			log.info("Purging reflection cache for ApplicationDomain that is no longer used by any Context");
			delete domainCounter[domain];
			ClassInfo.cache.purgeDomain(domain);
			var chain:CommandGroupBuilder = CommandGroupBuilder(domainPurgeHandlers[domain]);
			if (chain) chain.execute();
			delete domainPurgeHandlers[domain];
			for (var key:Object in domainByCustomKey) {
				if (domainByCustomKey[key] == domain) {
					delete domainByCustomKey[key];
				}
			}
		}
	}
	
	
}
}
