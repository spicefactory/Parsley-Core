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

package org.spicefactory.parsley.flex.modules {
import org.spicefactory.parsley.core.state.manager.GlobalDomainManager;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.bootstrap.impl.DefaultApplicationDomainProvider;

import mx.core.UIComponent;

import flash.display.DisplayObject;
import flash.system.ApplicationDomain;

/**
 * Implementation of the ApplicationDomainProvider interface that can be used in Flex applications.
 * It tries to determine the ApplicationDomain from the <code>moduleFactory</code> property of the
 * specified view instance in case it is an <code>UIComponent</code>. If that attempt fails it delegates
 * to the default implementation that this class extends.
 * 
 * @author Jens Halm
 */
public class FlexApplicationDomainProvider extends DefaultApplicationDomainProvider {
	
	
	private static const log:Logger = LogContext.getLogger(DefaultApplicationDomainProvider);
	
	
	/**
	 * @inheritDoc
	 */
	public override function getDomainForView (view:DisplayObject, domainManager:GlobalDomainManager) : ApplicationDomain {
		try {
			if (view is UIComponent && view.hasOwnProperty("moduleFactory")) {
				var comp:Object = view;
				if (comp.moduleFactory) {
					var domain:ApplicationDomain = comp.moduleFactory.info().currentDomain;
					if (domain) {
						return domainManager.putIfAbsent(comp.moduleFactory, domain); 
					}
					else {
						log.warn("Unable to determine the ApplicationDomain from moduleFactory of view root {0}, " +
							"falling back to default mechanism", view);
					}
				}
				else {
					log.warn("moduleFactory property not set on view root {0}, " +
							"falling back to default mechanism for determining the ApplicationDomain", view);
				}
			}
		}
		catch (e:Error) {
			log.error("Error trying to determine the ApplicationDomain of view root {0}: {1}", view, e);
		}
		return super.getDomainForView(view, domainManager);
	}
	
	
}
}
