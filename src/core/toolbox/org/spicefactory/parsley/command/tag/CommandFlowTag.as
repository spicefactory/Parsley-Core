/*
 * Copyright 2011 the original author or authors.
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
 
package org.spicefactory.parsley.command.tag {

import org.spicefactory.lib.collection.Map;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;

[XmlMapping(elementName="command-flow")]

/**
 * Tag for command flows declared in MXML or XML configuration.
 * 
 * @author Jens Halm
 */
public class CommandFlowTag extends AbstractCommandParentTag implements NestedCommandTag {
	
	
	/**
	 * @inheritDoc
	 */
	public override function resolve (registry:ObjectDefinitionRegistry) : ManagedCommandFactory {
		var map:Map = new Map();
		for each (var tag:NestedCommandTag in commands) {
			map.put(tag, tag.resolve(registry));
		}
		return new Factory(id, map, registry.context);
	}
	
	
}
}

import org.spicefactory.lib.collection.Map;
import org.spicefactory.lib.command.CommandResult;
import org.spicefactory.lib.command.flow.CommandFlow;
import org.spicefactory.lib.command.flow.CommandLink;
import org.spicefactory.lib.command.flow.CommandLinkProcessor;
import org.spicefactory.lib.command.flow.DefaultCommandFlow;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.command.impl.DefaultManagedCommandProxy;
import org.spicefactory.parsley.command.tag.NestedCommandTag;
import org.spicefactory.parsley.command.tag.link.LinkTag;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.core.command.ManagedCommandProxy;
import org.spicefactory.parsley.core.context.Context;

class Factory implements ManagedCommandFactory {
	
	private var id:String;
	private var map:Map;
	private var context:Context;
	
	function Factory (id:String, map:Map, context:Context) {
		this.id = id;
		this.map = map;
		this.context = context;
	}
	
	public function newInstance () : ManagedCommandProxy {
		var flow:CommandFlow = new DefaultCommandFlow();
		var resolvedMap:Map = new Map();
		for each (var tag:NestedCommandTag in map.keys) {
			var factory:ManagedCommandFactory = map.get(tag);
			var com:ManagedCommandProxy = factory.newInstance();
			resolvedMap.put(tag, com);
			resolvedMap.put(com.id, com);
		}
		for each (var key:Object in resolvedMap.keys) {
			var resolvedTag:NestedCommandTag = key as NestedCommandTag;
			if (!resolvedTag) continue;
			var command:ManagedCommandProxy = resolvedMap.get(resolvedTag);
			for each (var linkTag:LinkTag in resolvedTag.links) {
				var link:CommandLink = linkTag.build(resolvedMap);
				flow.addLink(command, link);
			}
		}
		flow.setDefaultLink(new DefaultLink());
		return new DefaultManagedCommandProxy(context, flow, id);
	}

	public function get type () : ClassInfo {
		return ClassInfo.forClass(CommandFlow, context.domain);
	}
	
}

class DefaultLink implements CommandLink {

	public function link (result:CommandResult, processor:CommandLinkProcessor) : void {
		processor.complete();
	}
	
}
