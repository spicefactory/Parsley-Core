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

import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.core.bootstrap.BootstrapConfigProcessor;
import org.spicefactory.parsley.messaging.tag.MessageBindingDecorator;
import org.spicefactory.parsley.messaging.tag.MessageDispatcherDecorator;
import org.spicefactory.parsley.messaging.tag.MessageErrorDecorator;
import org.spicefactory.parsley.xml.tag.ManagedEventsDecoratorTag;
import org.spicefactory.parsley.xml.tag.MessageHandlerDecoratorTag;
	
/**
 * Provides a static method to initalize the XML tags for messaging.
 * Can be used as a child tag of a &lt;LightContextBuilder&gt; tag in MXML alternatively.
 * The use of this class is only required when using the LightContextBuilder with LightXmlConfig API or tag.
 * The standard XmlConfig API and tag automatically installs these XML tags.
 * 
 * @author Jens Halm
 */
public class MessagingXmlSupport implements BootstrapConfigProcessor {
	
	
	private static var initialized:Boolean = false;
	

	/**
	 * Initializes the support for the XML tags for messaging.
	 * Must be invoked before a <code>LightContextBuilder</code> is used for the first time.
  	 */
	public static function initialize () : void {
		
		if (initialized) return;
		initialized = true;
		
		XmlConfigurationNamespaceRegistry
			.getNamespace(XmlObjectDefinitionMapperFactory.PARSLEY_NAMESPACE_URI)
			.choiceId(XmlObjectDefinitionMapperFactory.CHOICE_ID_DECORATORS, 
					MessageHandlerDecoratorTag, MessageBindingDecorator, MessageErrorDecorator,
				    MessageDispatcherDecorator, ManagedEventsDecoratorTag);
	}

	/**
	 * @private
	 */
	public function processConfig (config: BootstrapConfig): void {
		initialize();
	}
	
}
}
