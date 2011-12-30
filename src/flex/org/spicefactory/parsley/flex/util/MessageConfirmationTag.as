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

package org.spicefactory.parsley.flex.util {
import org.spicefactory.parsley.config.RootConfigurationElement;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.messaging.MessageHandler;

/**
 * Utility tag for convenient declaration of a confirmation dialog that opens
 * in response to a message and only proceeds when the user clicks Yes.
 * 
 * @author Jens Halm
 */
public class MessageConfirmationTag implements RootConfigurationElement {

	/**
	 * The text of the Alert.
	 */
	public var text:String;
	
	/**
	 * The title of the Alert.
	 */
	public var title:String;
	
	/**
	 * The name of the scope in which to listen for the message.
	 */
	public var scope:String;
	
	/**
	 * The type of the message to show an Alert for.
	 */
	public var type:Class;
	
	/**
	 * An optional selector value to be used in addition to selecting messages by type.
	 */
	public var selector:*;
	
	
	/**
	 * @inheritDoc
	 */
	public function process (registry:ObjectDefinitionRegistry) : void {
		
		var builder:ObjectDefinitionBuilder 
				= registry.builders.forClass(MessageConfirmation);
		
		builder
			.constructorArgs(title, text);
		
		MessageHandler
			.forMethod("showAlert")	
				.type(type)
				.selector(selector)
				.scope(scope)
					.apply(builder);
		
		builder
			.asSingleton()
				.register();
		
	}
	
}
}
