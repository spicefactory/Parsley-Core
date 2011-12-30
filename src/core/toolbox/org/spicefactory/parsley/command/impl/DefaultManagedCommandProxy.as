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
package org.spicefactory.parsley.command.impl {

import org.spicefactory.lib.command.Command;
import org.spicefactory.lib.command.lifecycle.CommandLifecycle;
import org.spicefactory.lib.command.proxy.DefaultCommandProxy;
import org.spicefactory.parsley.core.command.ManagedCommandProxy;
import org.spicefactory.parsley.core.context.Context;

/**
 * Default implementation of the ManagedCommandProxy interface.
 * 
 * @author Jens Halm
 */
public class DefaultManagedCommandProxy extends DefaultCommandProxy implements ManagedCommandProxy {

	private var _context:Context;
	private var _id:String;
	
	/**
	 * Creates a new instance.
	 * 
	 * @param context the Context the command belongs to
	 * @param target the target command to be executed by this proxy
	 * @param id the id the command is registered with in the Context
	 */
	function DefaultManagedCommandProxy (context:Context = null, target:Command = null, id:String = null) {
		_context = context;
		this.target = target;
		_id = id;
	}

	/**
	 * @private
	 */
	protected override function createLifecycle () : CommandLifecycle {
		return new ManagedCommandLifecycle(_context, this);
	}
	
	/**
	 * The Context the command belongs to.
	 */
	public function set context (value:Context) : void {
		_context = value;
	}

	public function set id (value:String) : void {
		_id = id;
	}

	/**
	 * @inheritDoc
	 */
	public function get id () : String {
		return _id;
	}
	

}
}
