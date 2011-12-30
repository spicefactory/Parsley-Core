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
package org.spicefactory.parsley.command {

import org.flexunit.assertThat;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.spicefactory.lib.command.builder.Commands;
import org.spicefactory.lib.command.group.CommandSequence;
import org.spicefactory.parsley.command.observer.CommandObserversImmediate;
import org.spicefactory.parsley.command.observer.CommandObserversNonImmediate;
import org.spicefactory.parsley.command.target.SimpleCommand;
import org.spicefactory.parsley.command.trigger.Trigger;
import org.spicefactory.parsley.command.trigger.TriggerA;
import org.spicefactory.parsley.context.ContextBuilder;
import org.spicefactory.parsley.core.context.Context;

/**
 * @author Jens Halm
 */
public class CommandResultTest {
	
	
	private var context: Context;
	
	
	[Test]
	public function immediate () : void {
		
		var observers:CommandObserversImmediate = new CommandObserversImmediate();
		context = ContextBuilder.newBuilder().object(observers).build();
		MappedCommands
			.factoryFunction(createSequence, CommandSequence)
			.messageType(Trigger)
			.register(context);
		
		dispatchMessage();
		
		assertThat(observers.firstResult, isFalse());
		assertThat(observers.secondResult, isFalse());
		assertThat(observers.allResults, isFalse());
		
		SimpleCommand.activeCommand.complete("foo");
		
		assertThat(observers.firstResult, isTrue());
		assertThat(observers.secondResult, isFalse());
		assertThat(observers.allResults, isFalse());
		
		SimpleCommand.activeCommand.complete(new Date());
		
		assertThat(observers.firstResult, isTrue());
		assertThat(observers.secondResult, isTrue());
		assertThat(observers.allResults, isTrue());
		
	}
	
	
	[Test]
	public function notImmediate () : void {
		
		var observers:CommandObserversNonImmediate = new CommandObserversNonImmediate();
		context = ContextBuilder.newBuilder().object(observers).build();
		MappedCommands
			.factoryFunction(createSequence, CommandSequence)
			.messageType(Trigger)
			.register(context);
		
		dispatchMessage();
		
		assertThat(observers.firstResult, isFalse());
		assertThat(observers.secondResult, isFalse());
		assertThat(observers.allResults, isFalse());
		
		SimpleCommand.activeCommand.complete("foo");
		
		assertThat(observers.firstResult, isFalse());
		assertThat(observers.secondResult, isFalse());
		assertThat(observers.allResults, isFalse());
		
		SimpleCommand.activeCommand.complete(new Date());
		
		assertThat(observers.firstResult, isTrue());
		assertThat(observers.secondResult, isTrue());
		assertThat(observers.allResults, isTrue());
		
	}
	
	
	private function createSequence (): Object {
		return Commands
			.asSequence()
			.create(SimpleCommand)
			.create(SimpleCommand)
			.build();
	}
	
	private function dispatchMessage (): void {
		context.scopeManager.dispatchMessage(new TriggerA());
	}
	
	
}
}
