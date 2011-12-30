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
package org.spicefactory.parsley.command {

import org.spicefactory.lib.command.builder.CommandProxyBuilder;
import org.spicefactory.parsley.command.impl.DefaultManagedCommandProxy;
import org.spicefactory.parsley.core.command.ManagedCommandProxy;
import org.spicefactory.parsley.core.context.Context;
	
/**
 * A builder DSL for creating command instances that are managed by the container.
 * This API adds on top of the standalone Spicelib Commands builder APIs the ability
 * to let commands get managed by a Parsley Context during execution.
 * 
 * @author Jens Halm
 */
public class ManagedCommandBuilder {
	
	
	private var builder:CommandProxyBuilder;
	
	private var proxy:DefaultManagedCommandProxy;
	
	private var _id:String;
	
	
	/**
	 * @private
	 */
	function ManagedCommandBuilder (target:Object) {
		this.proxy = new DefaultManagedCommandProxy();
		builder = new CommandProxyBuilder(target, proxy);
	}
	
	/**
	 * The identifier of the managed command.
	 * The id is optional and can be used for identifying matching command observers.
	 * 
	 * @param the identifier of the managed command
	 * @return this builder instance for method chaining
	 */
	public function id (value:String) : ManagedCommandBuilder {
		_id = value;
		return this;
	}
	
	/**
	 * Sets the timeout for the command execution. When the specified
	 * amount of time is elapsed the command will abort with an error.
	 * 
	 * @param milliseconds the timeout for the command execution in milliseconds
	 * @return this builder instance for method chaining
	 */
	public function timeout (milliseconds:uint) : ManagedCommandBuilder {
		builder.timeout(milliseconds);
		return this;
	}
	
	/**
	 * Adds a value that can get passed to the command
	 * executed by the proxy this builder creates.
	 * 
	 * @param value the value to pass to the command
	 * @return this builder instance for method chaining
	 */
	public function data (value:Object) : ManagedCommandBuilder {
		builder.data(value);
		return this;
	}
	
	/**
	 * Adds a callback to invoke when the command completes successfully.
	 * The result produced by the command will get passed to the callback.
	 * 
	 * @param callback the callback to invoke when the command completes successfully
	 * @return this builder instance for method chaining
	 */
	public function result (callback:Function) : ManagedCommandBuilder {
		builder.result(callback);
		return this;
	}
	
	/**
	 * Adds a callback to invoke when the command produced an error.
	 * The cause of the error will get passed to the callback.
	 * 
	 * @param callback the callback to invoke when the command produced an error
	 * @return this builder instance for method chaining
	 */
	public function error (callback:Function) : ManagedCommandBuilder {
		builder.error(callback);
		return this;
	}
	
	/**
	 * Adds a callback to invoke when the command gets cancelled.
	 * The callback should not expect any parameters.
	 * 
	 * @param callback the callback to invoke when the command gets cancelled
	 * @return this builder instance for method chaining
	 */
	public function cancel (callback:Function) : ManagedCommandBuilder {
		builder.cancel(callback);
		return this;
	}
	
	/**
	 * Builds the target command without executing it, applying all configurations specified
	 * through this builder instance and associating it with the specified
	 * Context.
	 * 
	 * @param the Context that is responsible for managing the command created by this builder
	 * @return the command proxy will all configuration of this builder applied
	 */
	public function build (context:Context) : ManagedCommandProxy {
		builder.domain(context.domain);
		proxy.id = _id;
		proxy.context =  context;
		builder.build();
		return proxy;
	}
	
	/**
	 * Builds and executes the target command.
	 * A shortcut for calling <code>build().execute()</code>.
	 * In case of asynchronous commands the returned proxy
	 * will still be active. In case of synchronous commands
	 * it will already be completed, so that adding event
	 * listeners won't have any effect.
	 * 
	 * @param the Context that is responsible for managing the command created by this builder
	 * @return the command that was built and executed by this builder
	 */
	public function execute (context:Context) : ManagedCommandProxy {
		var com:ManagedCommandProxy = build(context);
		com.execute();
		return com;
	}
	
	
}
}
