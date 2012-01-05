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

package org.spicefactory.parsley.flex.tag.view {
import org.spicefactory.lib.util.Flag;
import org.spicefactory.parsley.core.view.ViewConfiguration;
import org.spicefactory.parsley.core.view.impl.DefaultViewConfiguration;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.events.ViewConfigurationEvent;
import org.spicefactory.parsley.flex.tag.ConfigurationTagBase;

import flash.display.DisplayObject;

[DefaultProperty("targets")]
/**
 * MXML Tag that can be used for views that wish to be wired to the IOC Container.
 * With the target property of this tag the object to be wired to the Context can be explicitly specified
 * and does not have to be a DisplayObject. If the target property is not used the document object this tag is placed
 * upon will be wired. That object must always be a DisplayObject since it is used to 
 * dispatch a bubbling event.
 * 
 * @author Jens Halm
 */
public class ConfigureTag extends ConfigurationTagBase {
	
	
	private static const log:Logger = LogContext.getLogger(ConfigureTag);

	
	/**
	 * @private
	 */
	function ConfigureTag () {
		/*
		 * Using a lower priority here to make sure to execute after ContextBuilders listening for the 
		 * same event types of the document instance.
		 */
		super(-1);
	}
	
	
	/**
	 * The target objects to be wired to the Context.
	 * If this property is not set explicitly then the document object this tag
	 * was placed upon will be the only object getting wired.
	 */
	public var targets:Array;
	
	/**
	 * The id to use to lookup a matching configuration in the container.
	 * This parameter is optional, if omitted and the wired target instance
	 * is a DisplayObject its name will be used for id lookup.
	 * If there is no matching configuration for a particular id
	 * then the container matches by type. If that fails too,
	 * no container configuration will be used and only metadata on the target instance
	 * will be processed.
	 */
	public var configId:String;
	
	
	private var _reuse:Flag;
	
	/**
	 * Indicates whether the wiring should happen repeatedly after the wired
	 * object has been removed from the stage. When set to false it is only wired once.
	 * The default is false.
	 */
	public function set reuse (value:Boolean) : void {
		_reuse = new Flag(value);
	}
	
	private var _autoremove:Flag;
	
	/**
	 * @copy org.spicefactory.parsley.core.view.ViewConfiguration#autoremove
	 */
	public function set autoremove (value:Boolean) : void {
		_autoremove = new Flag(value);
	}
	
	/**
	 * @private
	 */
	protected override function executeAction (view:DisplayObject) : void { 
		dispatchConfigurationEvent(view);
	}
	
	private function dispatchConfigurationEvent (view:DisplayObject) : void {
		var targets:Array = (targets) ? targets : (target) ? [target] : [view];
		var configs:Array = new Array();
		for each (var target:Object in targets) {
			var config:ViewConfiguration = new DefaultViewConfiguration(view, target, configId);
			config.reuse = _reuse;
			config.autoremove = _autoremove;
			configs.push(config);
		}
		var event:ViewConfigurationEvent = ViewConfigurationEvent.forConfigurations(configs);
		view.dispatchEvent(event);
		if (!event.received) {
			log.warn("Configure tag could not be processed for targets " + event.configurations
					+ ": no Context found in view hierarchy");
		}
	}
	
	
}
}
