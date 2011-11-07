package org.spicefactory.parsley.lifecycle.asyncinit {

import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.lifecycle.asyncinit.model.AsyncInitModel;
import org.spicefactory.parsley.lifecycle.asyncinit.model.SyncModel;
import org.spicefactory.parsley.util.contextInState;

import flash.events.Event;

/**
 * @author Jens Halm
 */
public class AsyncInitTestBase {
	
	
	[Test]
	public function defaultAsyncInit () : void {
		var context:Context = defaultContext;
		assertThat(context, contextInState(true, false));
		var model:AsyncInitModel = context.getObject("asyncInitModel") as AsyncInitModel;
		model.dispatchEvent(new Event(Event.COMPLETE));
		assertThat(context, contextInState(true, true));
	}
	
	
	[Test]
	public function orderedAsyncInit () : void {
		AsyncInitModel.instances = 0;
		SyncModel.instanceCount = 0;
		var context:Context = orderedContext;
		assertThat(context, contextInState(true, false));
		assertThat(AsyncInitModel.instances, equalTo(1));
		assertThat(SyncModel.instanceCount, equalTo(0));
		
		var model1:AsyncInitModel = context.getObject("asyncInitModel1") as AsyncInitModel;	
		model1.dispatchEvent(new Event(Event.COMPLETE));
		assertThat(context, contextInState(true, false));
		assertThat(AsyncInitModel.instances, equalTo(2));
		assertThat(SyncModel.instanceCount, equalTo(0));
		
		var model2:AsyncInitModel = context.getObject("asyncInitModel2") as AsyncInitModel;
		model2.dispatchEvent(new Event("customComplete"));
		assertThat(context, contextInState(true, false));
		assertThat(AsyncInitModel.instances, equalTo(3));
		assertThat(SyncModel.instanceCount, equalTo(0));
		
		var model3:AsyncInitModel = context.getObject("asyncInitModel3") as AsyncInitModel;	
		model3.dispatchEvent(new Event(Event.COMPLETE));
		assertThat(context, contextInState(true, true));
		assertThat(AsyncInitModel.instances, equalTo(3));
		assertThat(SyncModel.instanceCount, equalTo(1));
	}
	
	
	protected function get defaultContext () : Context {
		throw new AbstractMethodError();
	}
	
	protected function get orderedContext () : Context {
		throw new AbstractMethodError();
	}
	
	
}
}
