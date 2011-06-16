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

package org.spicefactory.parsley.core.state.manager.impl {
import flash.events.Event;
import org.spicefactory.parsley.core.events.ContextCreationEvent;
import org.spicefactory.parsley.core.events.ContextConfigurationEvent;
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.state.ChildContextObserver;
import org.spicefactory.parsley.core.state.GlobalViewState;
import org.spicefactory.parsley.core.events.ContextLookupEvent;

import flash.display.DisplayObject;

/**
 * Default implementation of the GlobalViewState interface.
 * 
 * @author Jens Halm
 */
public class DefaultGlobalViewState implements GlobalViewState {
	
	
	/**
	 * @inheritDoc
	 */
	public function findContextInHierarchy (view:DisplayObject, callback:Function, requiredEvent:String = null) : void {
		var f:Function = (requiredEvent) ? function (context:Context) : void {
			waitFor(context, requiredEvent, callback);
		} : callback;
		var event:ContextLookupEvent = new ContextLookupEvent(f);
		if (!view.stage) {
			var stageListener:Function = function (stageEvent:Event) : void {
				view.removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
				dispatchLookupEvent(view, event, callback);
			};
			view.addEventListener(Event.ADDED_TO_STAGE, stageListener);
		}
		else {
			dispatchLookupEvent(view, event, callback);
		}
	}
	
	private function dispatchLookupEvent (view:DisplayObject, event:ContextLookupEvent, callback:Function) : void {
		view.dispatchEvent(event);
		if (!event.processed) callback(null);
	}
	
	private function waitFor (context:Context, event:String, callback:Function) : void {
		if (event == ContextEvent.INITIALIZED) {
			if (context.initialized) {
				callback(context);
				return;
			}
		}
		else if (event == ContextEvent.CONFIGURED) {
			if (context.configured) {
				callback(context);
				return;
			}
		}
		else if (event == ContextEvent.DESTROYED) {
			if (context.destroyed) {
				callback(context);
				return;
			}
		}
		else {
			throw new IllegalStateError("Illegal Context event type: " + event);
		}
		var f:Function = function (event:ContextEvent) : void {
			context.removeEventListener(event.type, f);
			callback(context);
		};
		context.addEventListener(event, f);	
	}
	
	/**
	 * @inheritDoc
	 */
	public function configureFirstChildContext (view:DisplayObject, callback:Function) : ChildContextObserver {
		var f:Function = function (event:ContextConfigurationEvent) : void {
			callback(event.config);
		};
		return new ChildContextObserverImpl(view, ContextConfigurationEvent.CONFIGURE_CONTEXT, f);
	}

	/**
	 * @inheritDoc
	 */
	public function waitForFirstChildContext (view:DisplayObject, callback:Function, 
			requiredEvent:String = null) : ChildContextObserver {
		var f:Function = function (event:ContextCreationEvent) : void {
			if (requiredEvent) {
				waitFor(event.context, requiredEvent, callback);
			}
			else {
				callback(event.context);
			}
		};
		return new ChildContextObserverImpl(view, ContextCreationEvent.CREATE_CONTEXT, f);
	}
	
	
}
}

import org.spicefactory.parsley.core.state.ChildContextObserver;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

class ChildContextObserverImpl implements ChildContextObserver {

	private var _view:DisplayObject;
	private var callback:Function;
	private var event:String;
	private var timer:Timer;
	private var timeoutCallback:Function;
	
	function ChildContextObserverImpl (view:DisplayObject, event:String, callback:Function) {
		_view = view;
		_view.addEventListener(event, execute);
		this.event = event;
		this.callback = callback;
	}
	
	public function timeout (timeout:uint, callback:Function = null) : void {
		timer = new Timer(timeout, 1);
		timer.addEventListener(TimerEvent.TIMER, onTimeout);
		timer.start();
		this.timeoutCallback = callback;
	}

	public function cancel () : void {
		if (timer) {
			timer.removeEventListener(TimerEvent.TIMER, onTimeout);
			timer.stop();
			timer = null;
		}
		view.removeEventListener(event, execute);
	}
	
	private function execute (event:Event) : void {
		cancel();
		callback(event);
	}
	
	private function onTimeout (event:TimerEvent) : void {
		cancel();
		if (timeoutCallback != null) {
			timeoutCallback(view); 
		}
	}
	
	public function get view () : DisplayObject {
		return _view;
	}
	
}

