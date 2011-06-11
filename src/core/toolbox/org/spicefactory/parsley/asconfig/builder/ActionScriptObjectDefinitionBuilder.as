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

package org.spicefactory.parsley.asconfig.builder {
import org.spicefactory.parsley.asconfig.processor.ActionScriptConfigurationProcessor;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;

[Deprecated(replacement="ActionScriptConfigurationProcessor")]
/**
 * @author Jens Halm
 */
public class ActionScriptObjectDefinitionBuilder extends ActionScriptConfigurationProcessor implements ObjectDefinitionBuilder {

	function ActionScriptObjectDefinitionBuilder (configClasses:Array) {
		super(configClasses);
	}
	
	public function build (registry:ObjectDefinitionRegistry) : void {
		processConfiguration(registry);
	}	

}
}

