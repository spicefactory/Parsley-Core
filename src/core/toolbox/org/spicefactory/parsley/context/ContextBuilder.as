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

package org.spicefactory.parsley.context {
import org.spicefactory.parsley.util.ContextCallbacks;
import org.spicefactory.parsley.core.bootstrap.BootstrapProcessor;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilderFactory;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.runtime.processor.RuntimeConfigurationProcessor;

/**
 * A ContextBuilder offers the option to create a new Context programmatically using the convenient
 * configuration DSL.
 * 
 * <p>A standard ContextBuilder can be created using the <code>newBuilder</code> method:</p>
 * 
 * <p><pre>ContextBuilder.newBuilder()
 *     .config(XmlConfig.forFile("logging.xml"))
 *     .config(FlexConfig.forClass(MyConfig))
 * 	   .build();</pre></p>
 * 	   
 * <p>If you need to specify more options than just the configuration artifacts, you must enter
 * setup mode first:</p>
 * 
 * <p><pre>var viewRoot:DisplayObject = ...;
 * var parent:Context = ...;
 * ContextBuilder.newSetup()
 *     .viewRoot(viewRoot)
 *     .parent(parent)
 *     .viewSettings().autoremoveComponents(false)
 *     .newBuilder()
 *         .config(XmlConfig.forFile("logging.xml"))
 *         .config(FlexConfig.forClass(MyConfig))
 * 	       .build();</pre></p>
 * 
 * @author Jens Halm
 */
public class ContextBuilder {
	
	
	/**
	 * Creates a new ContextBuilder instance applying default settings.
	 * In case you want to specify options like view root, custom scopes
	 * or parent Contexts, use <code>newSetup</code> instead.
	 * 
	 * @return a new ContextBuilder instance applying default settings
	 */
	public static function newBuilder () : ContextBuilder {
		return new ContextBuilderSetup().newBuilder();
	}
	
	/**
	 * Creates a new setup instance that allows to specify custom
	 * options for the ContextBuilder to be created.
	 * 
	 * @return a new setup instance that allows to specify custom
	 * options for the ContextBuilder to be created
	 */
	public static function newSetup () : ContextBuilderSetup {
		return new ContextBuilderSetup();
	}

	
	private var processor:BootstrapProcessor;
	private var runtimeConfig:RuntimeConfigurationProcessor;
	
	private var completeHandlers:Array = new Array();
	private var errorHandlers:Array = new Array();
	
	
	/**
	 * @private
	 */
	function ContextBuilder (processor:BootstrapProcessor) {
		this.processor = processor;
	}
	
	/**
	 * Adds a configuration processor to this builder.
	 * 
	 * <p>The builtin configuration mechanisms offer convenient shortuts to 
	 * create such a processor like <code>FlexConfig.forClass(MyConfig)</code>
	 * or <code>XmlConfig.forFile("config.xml")</code>.</p>
	 * 
	 * @param processor the processor to add
	 * @return this builder instance for method chaining
	 */
	public function config (processor:ConfigurationProcessor) : ContextBuilder {
		this.processor.addProcessor(processor);
		return this;
	}
	
	/**
	 * Adds an existing instance to the Context created by this builder.
	 * The only way to apply framework features to the target instance
	 * is metadata in this case. If you need other means of applying features
	 * to an object, consider using the <code>objectDefinition</code> method instead.
	 * 
	 * @param instance the instance to add to the Context
	 * @param id the optional id of the instance
	 * @return this builder instance for method chaining
	 */
	public function object (instance:Object, id:String = null) : ContextBuilder {
		if (!runtimeConfig) {
			runtimeConfig = new RuntimeConfigurationProcessor();
			processor.addProcessor(runtimeConfig);
		}
		runtimeConfig.addInstance(instance, id);
		return this;
	}
	
	/**
	 * Returns the factory that can be used to programmatically create new
	 * object definitions using the framework's configuration DSL.
	 * This allows for more fine-grained control of the functionality that
	 * should be applied to the target instance than using the simple shortcut of
	 * the <code>object</code> method, where all object configuration would need
	 * to be done with metadata.
	 * 
	 * @return the factory that can be used to programmatically create new object definitions
	 */
	public function objectDefinition () : ObjectDefinitionBuilderFactory {
		return processor.info.registry.builders;
	}
	
	/**
	 * Adds a callback to invoke when the Context created by this builder
	 * finishes initialization. This may happen synchronously or asynchronously.
	 * 
	 * <p>The handler function has to accept a parameter of type Context.</p>
	 * 
	 * @param handler a callback to invoke when the Context created by this builder
	 * finishes initialization
	 * @return this builder instance for method chaining
	 */
	public function complete (handler: Function) : ContextBuilder {
		completeHandlers.push(handler);
		return this;
	}
	
	/**
	 * Adds a callback to invoke when Context creation aborts with an error. 
	 * This may happen synchronously or asynchronously.
	 * 
	 * <p>The handler function has to accept a parameter of type Object for 
	 * the cause of the failure. This is usually an instance of type <code>Error</code>
	 * or <code>ErrorEvent</code>.</p>
	 * 
	 * @param handler a callback to invoke when Context creation aborts with an error
	 * @return this builder instance for method chaining
	 */
	public function error (handler: Function) : ContextBuilder {
		errorHandlers.push(handler);
		return this;
	}
	
	private function completeHandler (context: Context): void {
		for each (var handler: Function in completeHandlers) {
			handler(context);
		}
	}
	
	private function errorHandler (cause: Object): void {
		for each (var handler: Function in errorHandlers) {
			handler(cause);
		}
	}
	
	/**
	 * Builds and returns the final Context instance, applying all settings
	 * specified for this builder.
	 * 
	 * @return the final Context instance
	 */
	public function build () : Context {
		var context: Context;
		try {
			context = processor.process();
		}
		catch (e: Error) {
			if (errorHandlers.length) {
				errorHandler(e);
				return null;
			}
			else {
				throw e;
			}
		}
		if (completeHandlers.length || errorHandlers.length) {
			ContextCallbacks
				.forContext(context)
				.initialized(completeHandler)
				.error(errorHandler);
		}
		return context;
	}
	
	
}
}
