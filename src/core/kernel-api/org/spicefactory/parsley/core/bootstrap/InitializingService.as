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

package org.spicefactory.parsley.core.bootstrap {

/**
 * Interface to be implemented by IOC kernel services that need access
 * to the environment of the Context building process. The BootstrapInfo
 * instance passed to the init method gives access to the settings and
 * collaborating services.
 * 
 * @author Jens Halm
 */
public interface InitializingService {
	
	
	/**
	 * Invoked once after the service has been instantiated.
	 * The BootstrapInfo instance passed to this method gives access to the settings and
 	 * collaborating services.
 	 * 
 	 * @param info the environment of the Context building process
	 */
	function init (info:BootstrapInfo) : void;
	
	
}
}
