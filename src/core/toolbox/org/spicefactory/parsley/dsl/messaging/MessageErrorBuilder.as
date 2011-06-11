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

package org.spicefactory.parsley.dsl.messaging {

/**
 * Builder for message error handlers.
 * 
 * @author Jens Halm
 */
public interface MessageErrorBuilder {
	
	
	/**
	 * Sets the name of the scope this error handler should be applied to.
	 * 
	 * @param name the name of the scope this error handler should be applied to
	 * @return this builder instance for method chaining
	 */
	function scope (name:String) : MessageErrorBuilder;
	
	/**
	 * Sets the type of the messages the error handler wants to handle.
	 * 
	 * @param value the type of the messages the error handler wants to handle
	 * @return this builder instance for method chaining
	 */
	function type (value:Class) : MessageErrorBuilder;

	/**
	 * Sets an optional selector value to be used in addition to selecting messages by type.
	 *
	 * @param value an optional selector value to be used in addition to selecting messages by type
	 * @return this builder instance for method chaining
	 */
	function selector (value:*) : MessageErrorBuilder;
	
	/**
	 * Sets the execution order for this error handler. Will be processed in ascending order. 
	 * The default is <code>int.MAX_VALUE</code>.
	 * 
	 * @param value the execution order for this error handler
	 * @return this builder instance for method chaining
	 */
	function order (value:int) : MessageErrorBuilder;
	
	/**
	 * Sets the type of the error that this handler is interested in.
	 * The default is the top level Error class.
	 * 
	 * @param value the type of the error that this handler is interested in
	 * @return this builder instance for method chaining
	 */
	function errorType (value:Class) : MessageErrorBuilder;
	
	
}
}
