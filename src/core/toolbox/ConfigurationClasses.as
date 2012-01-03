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

package {

import org.spicefactory.parsley.asconfig.ActionScriptConfig;
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.asconfig.processor.ActionScriptConfigurationProcessor;
import org.spicefactory.parsley.command.ManagedCommands;
import org.spicefactory.parsley.command.MappedCommands;
import org.spicefactory.parsley.command.tag.CommandFactoryTag;
import org.spicefactory.parsley.command.tag.CommandFlowTag;
import org.spicefactory.parsley.command.tag.CommandSequenceTag;
import org.spicefactory.parsley.command.tag.CommandTag;
import org.spicefactory.parsley.command.tag.ParallelCommandsTag;
import org.spicefactory.parsley.context.ContextBuilder;
import org.spicefactory.parsley.core.builder.metadata.MetadataDecoratorAssembler;
import org.spicefactory.parsley.object.DynamicObjectTag;
import org.spicefactory.parsley.object.RootObjectTag;
import org.spicefactory.parsley.object.ViewTag;
import org.spicefactory.parsley.properties.Properties;
import org.spicefactory.parsley.runtime.RuntimeContextBuilder;
import org.spicefactory.parsley.runtime.processor.RuntimeConfigurationProcessor;
import org.spicefactory.parsley.view.Configure;
import org.spicefactory.parsley.view.FastInject;
import org.spicefactory.parsley.view.FirstChildContext;
import org.spicefactory.parsley.view.ParentContext;

/**
 * @private 
 * 
 * Needed since unfortunately compc does not allow to combine include-namespaces with include-source.
 * Lists all classes that are not added through include-namespaces.
 * 
 * @author Jens Halm
 */
public class ConfigurationClasses {
	
	ActionScriptConfigurationProcessor;
	ActionScriptContextBuilder;
	ActionScriptConfig;
	
	RuntimeConfigurationProcessor;
	RuntimeContextBuilder;
	
	MetadataDecoratorAssembler;
	
	ContextBuilder;
	Configure;
	FastInject;
	ParentContext;
	FirstChildContext;
	
	RootObjectTag,
	ViewTag,
	DynamicObjectTag,
	
	CommandFactoryTag,
	CommandSequenceTag,
	ParallelCommandsTag,
	CommandFlowTag,
	CommandTag,
	
	MappedCommands,
	ManagedCommands,
	
	Properties;
}
}
