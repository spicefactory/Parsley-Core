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

package org.spicefactory.parsley.core.bootstrap.impl {
import org.spicefactory.parsley.core.state.manager.GlobalDomainManager;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.bootstrap.ApplicationDomainProvider;

import flash.display.DisplayObject;
import flash.system.ApplicationDomain;

/**
 * The default implementation of the ApplicationDomainProvider interface that can also be used in pure Flash Applications.
 * It tries to determine the ApplicationDomain from the <code>loaderInfo</code> or <code>root.loaderInfo</code> properties
 * of the specified DisplayObject. 
 * 
 * @author Jens Halm
 */
public class DefaultApplicationDomainProvider implements ApplicationDomainProvider {
	
	
	private static const log:Logger = LogContext.getLogger(DefaultApplicationDomainProvider);
	
	
	/**
	 * @inheritDoc
	 */
	public function getDomainForView (view:DisplayObject, domainManager:GlobalDomainManager) : ApplicationDomain {
		try {
			if (view.loaderInfo && view.loaderInfo.applicationDomain) {
				return domainManager.putIfAbsent(view.loaderInfo, view.loaderInfo.applicationDomain);
			}
			else if (view.root && view.root.loaderInfo.applicationDomain) {
				return domainManager.putIfAbsent(view.root.loaderInfo, view.root.loaderInfo.applicationDomain);
			}
		}
		catch (e:Error) {
			log.error("Error trying to determine the ApplicationDomain of view root {0}: {1}", view, e);
		}
		log.warn("Unable to automatically determine ApplicationDomain from moduleFactory of view root {0}", view);
		return null;
	}
	
	
}
}
