/*
 * Copyright 2009 the original author or authors.
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

package org.spicefactory.parsley.core.view.impl {
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.bootstrap.BootstrapInfo;
import org.spicefactory.parsley.core.bootstrap.InitializingService;
import org.spicefactory.parsley.core.bootstrap.impl.ServiceFactory;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.view.ViewManager;
import org.spicefactory.parsley.core.view.ViewRootHandler;
import org.spicefactory.parsley.core.view.ViewSettings;
import org.spicefactory.parsley.core.view.util.StageEventFilterCollection;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.system.ApplicationDomain;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

/**
 * Default implementation of the ViewManager interface.
 * Delegates most of the work to ViewRootHandlers.
 * 
 * @author Jens Halm
 */
public class DefaultViewManager implements ViewManager, InitializingService {


	private static const log:Logger = LogContext.getLogger(DefaultViewManager);
	
	private var customRemovedEvent:String = "removeView";

	private var context:Context;
	private var domain:ApplicationDomain;
	
	private var settings:ViewSettings;
	
	private var handlers:Array;
	
	private var viewRoots:Dictionary = new Dictionary();
	private var viewRootCount:int = 0;
	
	private var stageEventFilter:StageEventFilterCollection = new StageEventFilterCollection();
	
	
	private static const globalViewRootRegistry:Dictionary = new Dictionary();
	
	
	/**
	 * Creates a new instance.
	 */
	function DefaultViewManager () {
		
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function init (info:BootstrapInfo) : void {
		this.context = info.context;
		this.domain = info.domain;
		this.settings = info.viewSettings;
		this.handlers = new Array();
		initViewRootHandlers(settings.getViewRootHandlers());
		context.addEventListener(ContextEvent.DESTROYED, contextDestroyed);
	}
	
	private function initViewRootHandlers (classes:Array) : void {
		for each (var handlerFactory:ServiceFactory in classes) {
			var handler:ViewRootHandler = handlerFactory.newInstance() as ViewRootHandler;
			handler.init(context, settings);
			handlers.push(handler);
		}
	}

	private function contextDestroyed (event:ContextEvent) : void {
		context.removeEventListener(ContextEvent.DESTROYED, contextDestroyed);
		for each (var view:ViewRoot in viewRoots) {
			handleRemovedViewRoot(view);	
		}
		viewRoots = new Dictionary();
		viewRootCount = 0;
		for each (var handler:ViewRootHandler in handlers) {
			handler.destroy();
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function addViewRoot (view:DisplayObject) : void {
		if (viewRoots[view]) return;
		log.info("Add view root: {0}/{1}", view.name, getQualifiedClassName(view));
		if (globalViewRootRegistry[view] != undefined) {
			// we do not allow two view managers on the same view, but we allow switching them
			log.info("Switching ViewManager for view root '{0}'", view);
			var vm:ViewManager = globalViewRootRegistry[view];
			vm.removeViewRoot(view);
		}
		globalViewRootRegistry[view] = this;
		
		var autoremove:Boolean = (view is DisplayObject) ? settings.autoremoveViewRoots : false;
		if (autoremove) {
			stageEventFilter.addTarget(view, filteredViewRootRemoved, ignoredFilteredAddedToStage);
		}
		else {
			view.addEventListener(customRemovedEvent, viewRootRemoved);
		}
		
		viewRoots[view] = new ViewRoot(view, autoremove);
		viewRootCount++;
		
		for each (var handler:ViewRootHandler in handlers) {
			handler.addViewRoot(view);
		}
	}

	private function viewRootRemoved (event:Event) : void {
		var viewRoot:DisplayObject = DisplayObject(event.target);
		removeViewRoot(viewRoot);
	}
	
	private function filteredViewRootRemoved (viewRoot:DisplayObject) : void {
		removeViewRoot(viewRoot);
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeViewRoot (view:DisplayObject) : void {
		var viewRoot:ViewRoot = viewRoots[view];
		if (viewRoot) {
			log.info("Remove view root: {0}/{1}", viewRoot.view.name, getQualifiedClassName(viewRoot.view));
	 		handleRemovedViewRoot(viewRoot);
			delete viewRoots[view];
			viewRootCount--;
			if (viewRootCount == 0) {
				log.info("Last view root removed from ViewManager - Destroy Context");
				context.destroy();
			}
		}
	}
	
	private function handleRemovedViewRoot (viewRoot:ViewRoot) : void {
		for each (var handler:ViewRootHandler in handlers) {
			handler.removeViewRoot(viewRoot.view);
		}
			
		if (viewRoot.autoremove) {
			stageEventFilter.removeTarget(viewRoot.view);
		}
		else {
	 		viewRoot.view.removeEventListener(customRemovedEvent, viewRootRemoved);
		}
		delete globalViewRootRegistry[viewRoot.view];
	}
	
	private function ignoredFilteredAddedToStage (view:IEventDispatcher) : void {
		/* do nothing */
	}
}
}

import flash.display.DisplayObject;

class ViewRoot {
	
	public var view:DisplayObject;
	public var autoremove:Boolean;
	
	function ViewRoot (view:DisplayObject, autoremove:Boolean) {
		this.view = view;
		this.autoremove = autoremove;
	}
}
