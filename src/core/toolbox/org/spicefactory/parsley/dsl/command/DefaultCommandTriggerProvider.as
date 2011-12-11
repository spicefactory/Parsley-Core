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

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.FunctionBase;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.lib.reflect.Parameter;
/**
 * Default implementation of the CommandTriggerProvider interface that
 * determines the trigger for a command based on the first parameter type
 * of the execute method or (if the execute method does not have parameters)
 * based on the first parameter type of the constructor.
 * 
 * @author Jens Halm
 */
public class DefaultCommandTriggerProvider implements CommandTriggerProvider {


	/**
	 * @inheritDoc
	 */
	public function getTriggerType (commandType:ClassInfo) : ClassInfo {
		var execute:Method = commandType.getMethod("execute");
		if (!execute) {
			return null;
		}
		var triggerType:ClassInfo = getFirstParameterType(execute);
		if (!triggerType) {
			triggerType = getFirstParameterType(commandType.getConstructor());
		}
		return triggerType;
	}
	
	private function getFirstParameterType (f:FunctionBase) : ClassInfo {
		return (f.parameters.length) ? Parameter(f.parameters[0]).type : null;
	}

	
}
}
