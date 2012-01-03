/*
 * Copyright 2012 the original author or authors.
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
package org.spicefactory.parsley.context {

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.parsley.binding.metadata.BindingMetadataSupport;
import org.spicefactory.parsley.comobserver.metadata.CommandObserverMetadataSupport;
import org.spicefactory.parsley.inject.metadata.InjectMetadataSupport;
import org.spicefactory.parsley.lifecycle.metadata.LifecycleMetadataSupport;
import org.spicefactory.parsley.messaging.metadata.MessagingMetadataSupport;
import org.spicefactory.parsley.resources.metadata.ResourceMetadataSupport;
	
/**
 * Allows to install or disable all default built-in metadata tags offered by Parsley.
 * For backwards-compatibility these tags are opt-out, not opt-in. Therefore the <code>install</code>
 * method gets called by the various entry points for Context building. To disable the default set
 * of metadata tags the <code>disable</code> method has to be called before creating the first Context.
 * 
 * @author Jens Halm
 */
public class DefaultMetadataTags {
	
	
	private static var installed: Boolean;
	private static var disabled: Boolean;
	
	
	/**
	 * Installs the default set of metadata tags.
	 * Since these tags are opt-out, not opt-in, there is no need for
	 * application code to call this method. The various entry points
	 * for Context building will automatically call this method.
	 */
	public static function install (): void {
		if (installed || disabled) return;
		installed = true;
		
		InjectMetadataSupport.initialize();
		BindingMetadataSupport.initialize();
		MessagingMetadataSupport.initialize();
		CommandObserverMetadataSupport.initialize();
		LifecycleMetadataSupport.initialize();
		ResourceMetadataSupport.initialize(); 
	}
	
	/**
	 * Disables all of the tags in the set of built-in metadata tags.
	 * This method has to be called before creating the first Context.
	 * Individual sets of the default tags can then get enabled again,
	 * either through their API or their MXML initializer tag.
	 * For injection for example it would be the InjectMetadataSupport
	 * MXML tag which can be used as a child of the ContextBuilder tag.
	 */
	public static function disable (): void {
		if (installed) {
			LogContext.getLogger(DefaultMetadataTags)
				.error("Disable method called too late, default metadata tags have already been installed");
			return;
		}
		disabled = true;
	}
	
	
}
}
