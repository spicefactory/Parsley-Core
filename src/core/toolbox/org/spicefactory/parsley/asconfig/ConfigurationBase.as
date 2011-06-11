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

package org.spicefactory.parsley.asconfig {
import org.spicefactory.parsley.core.registry.ConfigurationProperties;

/**
 * Base class for ActionScript configuration that gives access to configuration properties.
 * 
 * @author Jens Halm
 */
public class ConfigurationBase {

	
	private var _properties:Object;
	
	/**
	 * Properties that may be used for configuring objects.
	 */
	protected function get properties () : Object {
		return _properties;
	}
	
	protected function set properties (value:Object) : void {
		_properties = value;
	}
	
	/**
	 * Initializes this configuration class, passing properties that may be used for configuring objects.
	 */
	public function init (props:ConfigurationProperties) : void {
		properties = new PropertiesProxy(props);
	}
	
	
	
}
}

import org.spicefactory.parsley.core.registry.ConfigurationProperties;

import flash.utils.Proxy;
import flash.utils.flash_proxy;

use namespace flash_proxy;

class PropertiesProxy extends Proxy {
	
	private var props:ConfigurationProperties;
	
	function PropertiesProxy (props:ConfigurationProperties) {
		this.props = props;
	}

	override flash_proxy function getProperty (name:*) : * {
        return props.getValue(name);
    }
    
}

