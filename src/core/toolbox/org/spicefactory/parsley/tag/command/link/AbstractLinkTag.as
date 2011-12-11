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
package org.spicefactory.parsley.tag.command.link {

import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.command.Command;
import org.spicefactory.lib.command.flow.CommandLink;
import org.spicefactory.lib.command.flow.DefaultCommandLink;
import org.spicefactory.lib.command.flow.LinkCondition;
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.parsley.tag.command.NestedCommandTag;

/**
 * Base class for tags that represent command links.
 * 
 * @author Jens Halm
 */
public class AbstractLinkTag implements LinkTag {
	
	
	/**
	 * The target command to execute in case the condition
	 * specified by this tag is met.
	 */
	public var to:NestedCommandTag;
	
	
	/**
	 * @inheritDoc
	 */
	public function build (commands:Map) : CommandLink {
		if (!to) {
			throw IllegalStateError("No target has been specified for this link");
		}
		if (!commands.containsKey(to)) {
			throw new IllegalStateError("Target of link does not point to a command of the same flow " + to);
		}
		var command:Command = commands.get(to) as Command;
		return new DefaultCommandLink(condition, new ExecuteCommandAction(command));
	}
	
	/**
	 * The condition to apply to the links produced by this tag.
	 */
	protected function get condition () : LinkCondition {
		throw new AbstractMethodError();
	}
	
	
}
}

import org.spicefactory.lib.command.Command;
import org.spicefactory.lib.command.flow.CommandLinkProcessor;
import org.spicefactory.lib.command.flow.LinkAction;

class ExecuteCommandAction implements LinkAction {

	private var command:Command;
	
	function ExecuteCommandAction (command:Command) {
		this.command = command;
	}

	public function execute (processor:CommandLinkProcessor) : void {
		processor.execute(command);
	}
	
}
