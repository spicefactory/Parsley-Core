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

package org.spicefactory.parsley.config {
import org.spicefactory.parsley.tag.core.ObjectDecoratorMarker;
import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;

/**
 * The core extension interface for adding configuration artifacts to an object definition.
 * 
 * <p>All builtin configuration tags like <code>[Inject]</code> or <code>[MessageHandler]</code>
 * implement this interface. But it can also be used to create custom configuration tags.
 * Parsleys flexibility makes it possible that in most cases implementations of this interface
 * can be used as Metadata, MXML and XML tag.</p>
 * 
 * <p>For details see 
 * <a href="http://www.spicefactory.org/parsley/docs/2.4/manual?page=extensions&amp;section=decorators">11.2 Creating Custom Configuration Tags</a>
 * in the Parsley Manual.</p>
 * 
 * @author Jens Halm
 */
public interface ObjectDefinitionDecorator extends ObjectDecoratorMarker {
	
	/**
	 * Method to be invoked by the container for each configuration tag it encounters for an object 
	 * that was added to the container. It doesn't matter whether it is a builtin configuration tag 
	 * or a custom extension tag, or whether it is a metadata tag, an MXML or XML tag. 
	 * As long as the tag is mapped to a class that implements this interface the container 
	 * will invoke it for each tag on each object.
	 * 
	 * <p>The builder parameter getting passed to the decorator can be used to customize the ObjectDefinition that 
	 * is currently getting processed. 
	 * In most custom tag implementations you will peform tasks like specifying constructor arguments, 
	 * property values, message receivers, custom lifecycle processors or instantiators.</p>
	 * 
	 * <p>A decorator is also allowed to register additional definitions through using <code>builder.newBuilder</code>.
 	 * Those additional definitions might describe collaborators that the processed definition will need 
 	 * to operate for example. If you want to register collaborators that are globally accessible (or within a certain scope)
 	 * you may consider adding them to the <code>ScopeExtensionRegistry</code> in the <code>GlobalFactoryRegistry</code> instead.</p>
 	 * 
	 * @param builder the builder that can be used to modify the target definition
	 */
	function decorate (builder:ObjectDefinitionBuilder) : void;
	
}

}
