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
	
/**
 * Strategy that allows to determine the trigger message type for a command
 * based on the type of the command.
 * 
 * @author Jens Halm
 */
public interface CommandTriggerProvider {
	
	
	/**
	 * Returns the trigger message for the specified command 
	 * type or null if it cannot be determined.
	 * 
	 * @param commandType the type of the target command
	 * @return the trigger message type for the specified command
	 */
	function getTriggerType (commandType:ClassInfo) : ClassInfo;
	
	
}
}
