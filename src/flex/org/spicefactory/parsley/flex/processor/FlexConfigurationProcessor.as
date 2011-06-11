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

package org.spicefactory.parsley.flex.processor {
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.util.ClassUtil;
import org.spicefactory.parsley.asconfig.processor.ActionScriptConfigurationProcessor;

/**
 * ConfigurationProcessor implementation that processes MXML configuration classes.
 * 
 * @author Jens Halm
 */
public class FlexConfigurationProcessor extends ActionScriptConfigurationProcessor {
	
	
	private static const log:Logger = LogContext.getLogger(FlexConfigurationProcessor);
	
	
	private var configClasses:Array;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param configClasses the classes that contain the MXML configuration
	 */
	function FlexConfigurationProcessor (configClasses:Array) {
		super(configClasses);
		this.configClasses = configClasses;
	}
	
	
	/**
	 * @private
	 */
	public override function toString () : String {
		var classNames:Array = new Array();
		for each (var type:Class in configClasses) {
			classNames.push(ClassUtil.getSimpleName(type));
		}
		return "FlexConfig{" + classNames.join(",") + "}";
	}
	
	
}
}
