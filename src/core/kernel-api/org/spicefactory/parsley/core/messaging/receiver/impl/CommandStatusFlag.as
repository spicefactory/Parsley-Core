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

package org.spicefactory.parsley.core.messaging.receiver.impl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.command.CommandManager;
import org.spicefactory.parsley.core.messaging.command.CommandObserverProcessor;
import org.spicefactory.parsley.core.messaging.command.CommandStatus;
import org.spicefactory.parsley.core.messaging.receiver.CommandObserver;

[Deprecated(replacement="same class in new parsley.processor.messaging.receiver package")]
/**
 * @author Jens Halm
 */
public class CommandStatusFlag extends AbstractTargetInstanceReceiver implements CommandObserver {
	
	private var manager:CommandManager;
	private var property:Property;
	private var _status:CommandStatus;
	
	function CommandStatusFlag (provider:ObjectProvider, propertyName:String, manager:CommandManager, 
			status:CommandStatus, messageType:ClassInfo, selector:* = undefined, order:int = int.MAX_VALUE) {
		super(provider, messageType.getClass(), selector, order);
		property = targetType.getProperty(propertyName);
		if (property == null) {
			throw new ContextError("Target type " + targetType.name 
					+ " does not contain a property with name " + property);	
		}
		else if (!property.writable) {
			throw new ContextError("Target " + property + " is not writable");
		}
		else if (property.type.getClass() != Boolean) {
			throw new ContextError("Target " + property + " for CommandStatus must be of type Boolean");
		}
		_status = status;
		this.manager = manager;
	}

	public function observeCommand (processor:CommandObserverProcessor) : void {
		property.setValue(targetInstance, manager.hasActiveCommands(messageType, selector));
	}
	
	public function get status () : CommandStatus {
		return _status;
	}
	
}
}
