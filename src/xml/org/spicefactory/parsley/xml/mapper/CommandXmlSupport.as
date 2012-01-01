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
package org.spicefactory.parsley.xml.mapper {

import org.spicefactory.parsley.command.tag.CommandFactoryTag;
import org.spicefactory.parsley.command.tag.CommandFlowTag;
import org.spicefactory.parsley.command.tag.CommandRefTag;
import org.spicefactory.parsley.command.tag.CommandSequenceTag;
import org.spicefactory.parsley.command.tag.CommandTag;
import org.spicefactory.parsley.command.tag.MapCommandTag;
import org.spicefactory.parsley.command.tag.ParallelCommandsTag;
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.core.bootstrap.BootstrapConfigProcessor;
import org.spicefactory.parsley.xml.tag.command.XmlLinkAllResultsTag;
import org.spicefactory.parsley.xml.tag.command.XmlLinkResultPropertyTag;
import org.spicefactory.parsley.xml.tag.command.XmlLinkResultTypeTag;
import org.spicefactory.parsley.xml.tag.command.XmlLinkResultValueTag;
	
/**
 * Provides a static method to initalize the XML tags for commands and command links.
 * Can be used as a child tag of a &lt;LightContextBuilder&gt; tag in MXML alternatively.
 * The use of this class is only required when using the LightContextBuilder with LightXmlConfig API or tag.
 * The standard XmlConfig API and tag automatically installs these XML tags.
 * 
 * @author Jens Halm
 */
public class CommandXmlSupport implements BootstrapConfigProcessor {
	
	
	private static var initialized:Boolean = false;
	

	/**
	 * Initializes the support for the XML tags for commands and command links.
	 * Must be invoked before a <code>LightContextBuilder</code> is used for the first time.
  	 */
	public static function initialize () : void {
		
		if (initialized) return;
		initialized = true;
		
		XmlConfigurationNamespaceRegistry
			.getNamespace(XmlObjectDefinitionMapperFactory.PARSLEY_NAMESPACE_URI)
			.choiceId(XmlObjectDefinitionMapperFactory.CHOICE_ID_ROOT_ELEMENTS, CommandFactoryTag, MapCommandTag)
			.choiceId(XmlObjectDefinitionMapperFactory.CHOICE_ID_NESTED_ELEMENTS,
					CommandTag, CommandFlowTag, CommandSequenceTag, ParallelCommandsTag,
					XmlLinkResultTypeTag, XmlLinkResultValueTag, XmlLinkResultPropertyTag,
					XmlLinkAllResultsTag, CommandRefTag);
	}

	/**
	 * @private
	 */
	public function processConfig (config: BootstrapConfig): void {
		initialize();
	}
	
}
}
