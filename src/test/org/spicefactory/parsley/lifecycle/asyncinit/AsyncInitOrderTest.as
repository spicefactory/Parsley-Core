package org.spicefactory.parsley.lifecycle.asyncinit {

import org.flexunit.async.Async;
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.spicefactory.parsley.context.ContextBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.lifecycle.asyncinit.model.AsyncClass;
import org.spicefactory.parsley.lifecycle.asyncinit.model.InitSequenceRecorder;
import org.spicefactory.parsley.lifecycle.asyncinit.model.SyncClass;

import flash.events.Event;

/**
 * @author Jens Halm
 */
public class AsyncInitOrderTest {


	[Test(async)]
	public function asyncOrder (): void {
		var recorder: InitSequenceRecorder = new InitSequenceRecorder();
		var builder: ContextBuilder = ContextBuilder.newBuilder();

		addDefinition(builder, 1);
		addDefinition(builder, 2);
		addDefinition(builder, 2, true);
		addDefinition(builder, 2, true);
		addDefinition(builder, 3);
		addDefinition(builder, 3, true);
		addDefinition(builder, 3, true);
		addDefinition(builder, 4);
		addDefinition(builder, 5, true);

		var context: Context = builder.object(recorder).build();

		var f: Function = Async.asyncHandler(this, asyncOrderInitialized, 10000, recorder);
		context.addEventListener(ContextEvent.INITIALIZED, f);
	}

	private function asyncOrderInitialized (event: Event, initSequence: InitSequenceRecorder): void {
		assertThat(initSequence.value, equalTo("1C 2C 2C 2R 2R 2C 3C 3C 3R 3R 3C 4C 5C 5R"));
	}

	private function addDefinition (builder: ContextBuilder, order: int, async: Boolean = false): void {
		var type: Class = (async) ? AsyncClass : SyncClass;
		var defBuilder: ObjectDefinitionBuilder = builder.objectDefinition().forClass(type);
		defBuilder.constructorArgs(order);
		if (async) {
			defBuilder.asyncInit();
		}
		defBuilder.asSingleton().order(order).register();
	}
	
	
}
}