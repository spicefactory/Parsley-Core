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
 
package org.spicefactory.parsley.binding.impl {
import org.spicefactory.parsley.binding.PersistenceManager;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.binding.Subscriber;

/**
 * @author Jens Halm
 */
public class PersistentSubscriber extends AbstractSubscriber implements Subscriber {
	
	private var manager:PersistenceManager;
	private var scopeId:String;
	
	public function PersistentSubscriber (manager:PersistenceManager, scopeId:String, type:ClassInfo, id:String = null) {
		super(type, id, true);
		this.manager = manager;
		this.scopeId = scopeId;
	}

	public function update (newValue : *) : void {
		manager.saveValue(scopeId, type.getClass(), id, newValue);
	}
	

}
}
