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

package org.spicefactory.parsley.comobserver.receiver {

import org.spicefactory.parsley.core.command.CommandManager;
import org.spicefactory.parsley.core.command.CommandObserverProcessor;
import org.spicefactory.parsley.core.messaging.MessageReceiverKind;
import org.spicefactory.parsley.core.messaging.receiver.CommandObserver;
import org.spicefactory.parsley.messaging.receiver.AbstractPropertyReceiver;
import org.spicefactory.parsley.messaging.receiver.MessageReceiverInfo;

/**
 * A message target where a property value serves as a flag for indicating whether there is 
 * at least one active command matching the specified message type and selector. 
 *  
 * @author Jens Halm
 */
public class CommandStatusFlag extends AbstractPropertyReceiver implements CommandObserver {
	
	
	private var manager:CommandManager;
	
	
	
	/**
	 * Creates a new instance. 
	 *
	 * @param info the mapping information for this receiver 
	 * @param kind the phase of the command lifecycle this status flag reacts to
	 * @param manager the command manager to look up matching active commands
	 */
	function CommandStatusFlag (info: MessageReceiverInfo, kind:MessageReceiverKind, manager:CommandManager) {
				
		super(info);
		
		info.order = int.MIN_VALUE;
		_kind = kind;
		this.manager = manager;
	}

	
	private var _kind:MessageReceiverKind;

	/**
	 * @inheritDoc
	 */
	public function get kind () : MessageReceiverKind {
		return _kind;
	}
	
	/**
	 * @inheritDoc
	 */
	public function observeCommand (processor:CommandObserverProcessor) : void {
		if (!processor.root) return;
		
		targetProperty.setValue(provider.instance, manager.hasActiveCommandsForTrigger(type, selector));
	}

	
}
}
