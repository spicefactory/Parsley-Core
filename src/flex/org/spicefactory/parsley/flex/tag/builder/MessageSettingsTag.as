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
import org.spicefactory.parsley.core.messaging.ErrorPolicy;

/**
 * MXML tag for providing the settings to apply for messaging.  
 * <p>The tag can be used as a child tag of the ContextBuilder tag:</p>
 * 
 * <pre><code>&lt;parsley:ContextBuilder&gt;
 *     &lt;parsley:MessageSettings undhandledErrors="{ErrorPolicy.RETHROW}"/&gt;
 *     &lt;parsley:FlexConfig type="{BookStoreConfig}"/&gt;
 *     &lt;parsley:XmlConfig file="logging.xml"/&gt;
 * &lt;/parsley:ContextBuilder&gt;</code></pre> 
 * 
 * @author Jens Halm
 */
public class MessageSettingsTag implements BootstrapConfigProcessor {
	
	
	/**
	 * A handler that gets invoked for each Error thrown in any message receiver
	 * in any Context in any scope. The signature of the function must be:
	 * <code>function (processor:MessageProcessor, error:Error) : void</code>
	 */
	public var errorHandler:Function;
	
	/**
	 * The policy to apply for unhandled errors. An unhandled error
	 * is an error thrown by a message handler where no matching error handler
	 * was registered for. The default is <code>ErrorPolicy.IGNORE</code>.
	 */
	public var unhandledErrors:ErrorPolicy;
	
	/**
	 * @copy org.spicefactory.parsley.core.messaging.MessageSettingsTag#defaultReceiverScope
	 */
	public var defaultReceiverScope:String;
	
	
	/**
	 * @private
	 */
	public function processConfig (config:BootstrapConfig) : void {
		/* var settings:MessageSettings = (local) 
				? builder.factories.messageSettings : GlobalFactoryRegistry.instance.messageSettings; */
		if (defaultReceiverScope != null) {
			config.messageSettings.defaultReceiverScope = defaultReceiverScope;
		}
		if (unhandledErrors != null) {
			config.messageSettings.unhandledError = unhandledErrors;
		}
		if (errorHandler != null) {
			config.messageSettings.addErrorHandler(new GlobalMessageErrorHandler(errorHandler));
		}
	}
}
}

import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;
import org.spicefactory.parsley.processor.messaging.receiver.AbstractMessageReceiver;

class GlobalMessageErrorHandler extends AbstractMessageReceiver implements MessageErrorHandler {

	
	private var handler:Function;


	function GlobalMessageErrorHandler (handler:Function) {
		super();
		this.handler = handler;
	}

	public function handleError (processor:MessageProcessor, error:Error) : void {
		handler(processor, error);
	}
	
	public function get errorType () : Class {
		return Error;
	}
	
	
}

