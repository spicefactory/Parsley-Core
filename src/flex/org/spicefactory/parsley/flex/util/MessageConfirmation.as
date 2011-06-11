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

package org.spicefactory.parsley.flex.util {
import org.spicefactory.parsley.core.messaging.MessageProcessor;

import mx.controls.Alert;
import mx.events.CloseEvent;

/**
 * Utility class that allows to show a Flex Alert with Yes and No buttons
 * and only continue with message processing when the user clicks yes.
 * 
 * @author Jens Halm
 */
public class MessageConfirmation {

	private var title:String;
	private var text:String;

	/**
	 * Creates a new instance.
	 * 
	 * @param title the title of the Alert
	 * @param text the text of the Alert
	 */
	function MessageConfirmation (title:String, text:String) {
		this.title = title;
		this.text = text;
	}

	/**
	 * Shows an alert and only calls proceed on the specified processor
	 * if the user clicked Yes.
	 * 
	 * @param processor the processor for the intercepted message 
	 */
    public function showAlert (processor:MessageProcessor) : void {
    	
        var onClose:Function = function (event:CloseEvent) : void {
        	if (event.detail == Alert.YES) {
            	processor.proceed();
            }
        };
        
        Alert.show(
            text,
            title,
            Alert.YES | Alert.NO,
            null,
            onClose);
    }
        
        
}
}