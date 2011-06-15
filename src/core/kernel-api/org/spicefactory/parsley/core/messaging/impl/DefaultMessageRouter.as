/*
 * Copyright 2008-2009 the original author or authors.
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

package org.spicefactory.parsley.core.messaging.impl {

import org.spicefactory.parsley.core.bootstrap.BootstrapInfo;
import org.spicefactory.parsley.core.bootstrap.InitializingService;
import org.spicefactory.parsley.core.command.ObservableCommand;
import org.spicefactory.parsley.core.command.impl.DefaultCommandObserverProcessor;
import org.spicefactory.parsley.core.messaging.Message;
import org.spicefactory.parsley.core.messaging.MessageReceiverCache;
import org.spicefactory.parsley.core.messaging.MessageRouter;
import org.spicefactory.parsley.core.messaging.MessageSettings;

/**
 * Default implementation of the MessageRouter interface.
 * 
 * @author Jens Halm
 */
public class DefaultMessageRouter implements MessageRouter, InitializingService {
	
	
	private var settings:MessageSettings;
	
	/**
	 * @inheritDoc
	 */
	public function init (info:BootstrapInfo) : void {
		this.settings = info.messageSettings;
	}
	
	/**
	 * @inheritDoc
	 */
	public function dispatchMessage (message:Message, cache:MessageReceiverCache) : void {
		var processor:DefaultMessageProcessor = new DefaultMessageProcessor(message, cache, settings);
		processor.start();
	}	
	
	/**
	 * @inheritDoc
	 */
	public function observeCommand (command:ObservableCommand, cache:MessageReceiverCache) : void {
		var processor:DefaultCommandObserverProcessor 
				= new DefaultCommandObserverProcessor(command, cache, settings);
		processor.start();
	}
	
	
}
}
