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
 
package org.spicefactory.parsley.tag.command {

import org.spicefactory.lib.collection.Map;
import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;

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
	public override function resolve (config:Configuration) : ManagedCommandFactory {
		var map:Map = new Map();
		for each (var tag:NestedCommandTag in commands) {
			map.put(tag, tag.resolve(config));
		}
		return new Factory(map, config.context);
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
import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.core.command.ManagedCommandProxy;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.dsl.command.DefaultManagedCommandProxy;
import org.spicefactory.parsley.tag.command.NestedCommandTag;
import org.spicefactory.parsley.tag.command.link.LinkTag;

class Factory implements ManagedCommandFactory {
	
	private var map:Map;
	private var context:Context;
	
	function Factory (map:Map, context:Context) {
		this.map = map;
		this.context = context;
	}
	
	public function newInstance () : ManagedCommandProxy {
		var flow:CommandFlow = new DefaultCommandFlow();
		for each (var tag:NestedCommandTag in map.keys) {
			var factory:ManagedCommandFactory = map.get(tag);
			map.put(tag, factory.newInstance());
		}
		for each (var resolvedTag:NestedCommandTag in map.keys) {
			var command:ManagedCommandProxy = map.get(resolvedTag);
			for each (var linkTag:LinkTag in resolvedTag.links) {
				var link:CommandLink = linkTag.build(map);
				flow.addLink(command, link);
			}
		}
		flow.setDefaultLink(new DefaultLink());
		// TODO - 3.0.M2 - handle id
		return new DefaultManagedCommandProxy(context, flow);
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
