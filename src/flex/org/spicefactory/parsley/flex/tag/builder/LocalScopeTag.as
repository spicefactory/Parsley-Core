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

package org.spicefactory.parsley.flex.tag.builder {
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.core.bootstrap.BootstrapConfigProcessor;

/**
 * MXML tag for setting the unique id for the local scope. 
 * The id normally gets generated automatically and only needs to be set
 * explicitly if you need point to point messaging between distinct
 * scopes and want to assign ids which are meaningful for your application.
 * 
 * <p>The tag can be used as a child tag of the ContextBuilder tag:</p>
 * 
 * <pre><code>&lt;parsley:ContextBuilder&gt;
 *     &lt;parsley:LocalScope uuid="{someObject.someId}"/&gt;
 *     &lt;parsley:FlexConfig type="{BookStoreConfig}"/&gt;
 *     &lt;parsley:XmlConfig file="logging.xml"/&gt;
 * &lt;/parsley:ContextBuilder&gt;</code></pre> 
 * 
 * @author Jens Halm
 */
public class LocalScopeTag implements BootstrapConfigProcessor {
	
	/**
	 * @copy org.spicefactory.parsley.core.scope.Scope#uid
	 */
	public var uuid:String;
	
	/**
	 * @private
	 */
	public function processConfig (config:BootstrapConfig) : void {
		config.localScopeUuid = uuid;
	}
	
}
}
