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
package org.spicefactory.parsley.dsl.command {

import org.spicefactory.lib.command.builder.CommandProxyBuilder;
import org.spicefactory.parsley.core.command.ManagedCommandProxy;
import org.spicefactory.parsley.core.context.Context;
	
/**
 * @author Jens Halm
 */
public class ManagedCommandBuilder {
	
	
	private var builder:CommandProxyBuilder;
	
	private var proxy:DefaultManagedCommandProxy;
	
	private var _id:String;
	
	
	function ManagedCommandBuilder (target:Object) {
		this.proxy = new DefaultManagedCommandProxy();
		builder = new CommandProxyBuilder(target, proxy);
	}
	
	public function id (value:String) : ManagedCommandBuilder {
		_id = value;
		return this;
	}
	
	public function timeout (milliseconds:uint) : ManagedCommandBuilder {
		builder.timeout(milliseconds);
		return this;
	}
	
	public function data (value:Object) : ManagedCommandBuilder {
		builder.data(value);
		return this;
	}
	
	public function result (callback:Function) : ManagedCommandBuilder {
		builder.result(callback);
		return this;
	}
	
	public function error (callback:Function) : ManagedCommandBuilder {
		builder.error(callback);
		return this;
	}
	
	public function cancel (callback:Function) : ManagedCommandBuilder {
		builder.cancel(callback);
		return this;
	}
	
	public function build (context:Context) : ManagedCommandProxy {
		builder.domain(context.domain);
		proxy.id = _id;
		proxy.context =  context;
		builder.build();
		return proxy;
	}
	
	public function execute (context:Context) : ManagedCommandProxy {
		var com:ManagedCommandProxy = build(context);
		com.execute();
		return com;
	}
	
	
}
}
