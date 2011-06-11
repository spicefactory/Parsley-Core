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

package org.spicefactory.parsley.flex.tag.view {

/**
 * MXML Tag that can be used for as a child tag for the FastInject tag in case
 * multiple injections are required for a single component.
 * The tag allows the object to be selected by type or by id.
 * 
 * @author Jens Halm
 */
public class InjectTag {
	
	
	/**
	 * The target object to inject into.
	 */
	public var target:Object;
	
	/**
	 * The property to inject into.
	 */
	public var property:String;
	
	/**
	 * The type of the object to inject.
	 */
	public var type:Class;
	
	/**
	 * The id of the object to inject.
	 */
	public var objectId:String;
	
	
}
}
