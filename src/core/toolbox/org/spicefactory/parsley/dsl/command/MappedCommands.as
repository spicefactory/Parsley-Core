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
	
/**
 * API for mapping commands to messages programmatically.
 * 
 * @author Jens Halm
 */
public class MappedCommands {
	
	/**
	 * Creates a new mapping builder for the specified command type.
	 * 
	 * @return a new mapping builder for the specified command type
	 */
	public static function create (type:Class) : MappedCommandBuilder {
		return MappedCommandBuilder.forType(type);
	}
	
	/**
	 * Creates a new mapping builder for the specified factory function.
	 * The factory function should not expect any arguments and create
	 * a new command instance on each invocation. It will get invoked
	 * for each matching message that triggers a command execution. 
	 * 
	 * @param factory the factory function for creating new command instances
	 * @param type the type of command the factory creates
	 */
	public static function factoryFunction (factory:Function, type:Class) : MappedCommandBuilder {
		return MappedCommandBuilder.forFactoryFunction(factory, type);
	}
	
	
}
}

