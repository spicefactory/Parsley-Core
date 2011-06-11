/*
 * Copyright 2008-2009 the original author or authors.
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

package org.spicefactory.parsley.tag.messaging {
import org.spicefactory.lib.reflect.metadata.EventInfo;
import org.spicefactory.parsley.config.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.impl.MessageDispatcher;
import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;

[Metadata(name="ManagedEvents", types="class", multiple="true")]
/**
 * Represents a Metadata, MXML or XML tag that can be used on classes that dispatch events
 * that should be dispatched through Parsleys central message router.
 * 
 * May only be place on classes that implement <code>IEventDispatcher</code>. The class definition
 * should contain additional regular <code>[Event]</code> tags for all events it dispatches.
 * 
 * @author Jens Halm
 */
public class ManagedEventsDecorator implements ObjectDefinitionDecorator {


	[DefaultProperty]
	[Ignore]
	/**
	 * The event names/types of all events dispatched by the annotated class that should be managed by Parsley.
	 */
	public var names:Array;
	
	/**
	 * The scope these managed events should be dispatched to.
	 * If this attribute is omitted the event will be dispatched through 
	 * all scopes of the corresponding Context.
	 */
	public var scope:String;
	
	
	/**
	 * @inheritDoc
	 */
	public function decorate (builder:ObjectDefinitionBuilder) : void {
		var dispatcher:Function = new MessageDispatcher(builder.config.context.scopeManager, scope).dispatchMessage;
		if (names == null) {
			names = new Array();
			var events:Array = builder.typeInfo.getMetadata(EventInfo);
			for each (var eventInfo:EventInfo in events) {
				names.push(eventInfo.name);	
			}
		}
		if (names.length == 0) {
			throw new ContextError("ManagedEvents on class " + builder.typeInfo.name 
					+ ": No event names specified in ManagedEvents tag and no Event tag on class");	
		}
		for each (var event:String in names) {
			builder.event(event).manage(scope);
		}
	}
	
	
}
}


