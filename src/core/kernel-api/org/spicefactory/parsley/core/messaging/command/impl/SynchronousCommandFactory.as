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

package org.spicefactory.parsley.core.messaging.command.impl {
import org.spicefactory.parsley.core.messaging.Message;
import org.spicefactory.parsley.core.messaging.command.Command;
import org.spicefactory.parsley.core.messaging.command.CommandFactory;

/**
 * CommandFactory implementation that supports command methods that
 * have a void return type and execute synchronously.
 * 
 * @author Jens Halm
 */
public class SynchronousCommandFactory implements CommandFactory {

	/**
	 * @inheritDoc
	 */
	public function createCommand (returnValue:Object, message:Message) : Command {
		return new SynchronousCommand(message);
	}
}
}

import org.spicefactory.parsley.core.messaging.Message;
import org.spicefactory.parsley.core.messaging.command.impl.AbstractCommand;

class SynchronousCommand extends AbstractCommand {


	function SynchronousCommand (message:Message) {
		super(undefined, message);
		complete();
		start();
	}
	
	
}
