package org.spicefactory.parsley.context {

import org.flexunit.assertThat;
import org.hamcrest.collection.arrayWithSize;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.runtime.RuntimeContextBuilder;
import org.spicefactory.parsley.testmodel.InterfaceFactory;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IEventDispatcher;

/**
 * @author Jens Halm
 */
public class ContextTest {
	
	
	[Test]
	public function getAllObjectsByTypeWithInterface () : void {
		var context:Context = RuntimeContextBuilder.build([new InterfaceFactory(), new Object(), new Date()]);
		assertThat(context.getAllObjectsByType(IEventDispatcher), arrayWithSize(1));
		assertThat(context.getAllObjectsByType(Object), arrayWithSize(4));
	}
	
	[Test]
	public function findAllDefinitionsByInterfaceType () : void {
		var context:Context = RuntimeContextBuilder.build([new InterfaceFactory(), new Object(), new Date()]);
		assertThat(context.findAllDefinitionsByType(IEventDispatcher), arrayWithSize(1));
		assertThat(context.findAllDefinitionsByType(Object), arrayWithSize(4));
	}
	
	[Test]
	public function getObjectCountForInterface () : void {
		var context:Context = RuntimeContextBuilder.build([new InterfaceFactory(), new Object(), new Date()]);
		assertThat(context.getObjectCount(IEventDispatcher), equalTo(1));
		assertThat(context.getObjectCount(Object), equalTo(4));
	}
	
	[Test]
	public function syncCompleteHandler () : void {
		var callbacks: BuilderCallbacks = new BuilderCallbacks();
		ContextBuilder.newBuilder().complete(callbacks.completeHandler).error(callbacks.errorHandler).build();
		assertThat(callbacks.complete, isTrue());
		assertThat(callbacks.error, isFalse());
	}
	
	[Test]
	public function asyncCompleteHandler () : void {
		var asyncProc: AsyncProcessor = new AsyncProcessor();
		var callbacks: BuilderCallbacks = new BuilderCallbacks();
		ContextBuilder.newBuilder().config(asyncProc).complete(callbacks.completeHandler).error(callbacks.errorHandler).build();
		assertThat(callbacks.complete, isFalse());
		assertThat(callbacks.error, isFalse());
		asyncProc.dispatchEvent(new Event(Event.COMPLETE));
		assertThat(callbacks.complete, isTrue());
		assertThat(callbacks.error, isFalse());
	}
	
	[Test]
	public function syncErrorHandler () : void {
		var proc: FaultyProcessor = new FaultyProcessor();
		var callbacks: BuilderCallbacks = new BuilderCallbacks();
		ContextBuilder.newBuilder().config(proc).complete(callbacks.completeHandler).error(callbacks.errorHandler).build();
		assertThat(callbacks.complete, isFalse());
		assertThat(callbacks.error, isTrue());
	}
	
	[Test]
	public function asyncErrorHandler () : void {
		var asyncProc: AsyncProcessor = new AsyncProcessor();
		var callbacks: BuilderCallbacks = new BuilderCallbacks();
		ContextBuilder.newBuilder().config(asyncProc).complete(callbacks.completeHandler).error(callbacks.errorHandler).build();
		assertThat(callbacks.complete, isFalse());
		assertThat(callbacks.error, isFalse());
		asyncProc.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		assertThat(callbacks.complete, isFalse());
		assertThat(callbacks.error, isTrue());
	}
	
	
}
}

import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.parsley.core.bootstrap.AsyncConfigurationProcessor;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;

import flash.events.EventDispatcher;

class BuilderCallbacks {
	
	public var complete: Boolean;
	public var error: Boolean;
	
	public function completeHandler (context: Context): void {
		if (context) complete = true;
		else throw new IllegalArgumentError("Context is null");
	}
	
	public function errorHandler (cause: Object): void {
		if (cause) error = true;
		else throw new IllegalArgumentError("Cause is null");
	}
	
	
}

class FaultyProcessor implements ConfigurationProcessor {

	public function processConfiguration (registry: ObjectDefinitionRegistry): void {
		throw new Error("This error is expected");
	}
	
}

class AsyncProcessor extends EventDispatcher implements AsyncConfigurationProcessor {

	public function cancel (): void {
	}

	public function processConfiguration (registry: ObjectDefinitionRegistry): void {
	}

}
