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
import org.spicefactory.parsley.core.view.impl.DefaultViewSettings;

/**
 * MXML tag for providing the settings to apply for dynamic view wiring. 
 * <p>The tag can be used as a child tag of the ContextBuilder tag:</p>
 * 
 * <pre><code>&lt;parsley:ContextBuilder&gt;
 *     &lt;parsley:ViewSettings autoremoveComponents="false" autowireComponents="true"/&gt;
 *     &lt;parsley:FlexConfig type="{BookStoreConfig}"/&gt;
 *     &lt;parsley:XmlConfig file="logging.xml"/&gt;
 * &lt;/parsley:ContextBuilder&gt;</code></pre> 
 * 
 * @author Jens Halm
 */
public class ViewSettingsTag extends DefaultViewSettings implements BootstrapConfigProcessor {
	
	/**
	 * The type of a view root handler to add to this Context. 
	 * The class must implement the <code>ViewRootHandler</code> interface.
	 * For specifying more than one view handler multiple ViewSettings tags can be used.
	 */
	public var viewRootHandler:Class;
	
	/**
	 * @private
	 */
	public function processConfig (config:BootstrapConfig) : void {
		config.viewSettings.autoremoveComponents = autoremoveComponents;
		config.viewSettings.autoremoveViewRoots = autoremoveViewRoots;
		config.viewSettings.autowireComponents = autowireComponents;
		if (autowireFilter) {
			config.viewSettings.autowireFilter = autowireFilter;
		}
		if (viewRootHandler) {
			config.viewSettings.addViewRootHandler(viewRootHandler);
		}
	}
	
	
}
}
