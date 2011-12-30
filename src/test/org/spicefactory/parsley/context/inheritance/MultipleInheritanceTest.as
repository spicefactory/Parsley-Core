package org.spicefactory.parsley.context.inheritance {
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import org.hamcrest.assertThat;
import org.hamcrest.collection.arrayWithSize;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.spicefactory.parsley.context.ContextBuilder;
import org.spicefactory.parsley.context.inheritance.model.InjectionTarget;
import org.spicefactory.parsley.context.inheritance.model.StringHolder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.scope.ScopeName;
import org.spicefactory.parsley.lifecycle.asyncinit.model.AsyncInitModelMetadata;


/**
 * @author Jens Halm
 */
public class MultipleInheritanceTest {
	
	
	[Test]
	public function contextAPI () : void {
		var root:Context = ContextBuilder.newBuilder().build();
		var parentA:Context = ContextBuilder.newSetup().parent(root)
				.newBuilder().object("foo").object(new Date()).build();
		var parentB:Context = ContextBuilder.newSetup().parent(root)
				.newBuilder().object("bar").object(new Sprite()).build();
		var context:Context = ContextBuilder.newSetup().parent(parentA).parent(parentB)
				.newBuilder().object(new Rectangle()).build();
				
		assertThat(root.getObjectCount(), equalTo(0));
		assertThat(parentA.getObjectCount(), equalTo(2));
		assertThat(parentB.getObjectCount(), equalTo(2));
		assertThat(context.getObjectCount(), equalTo(5));
		assertThat(context.getObjectCount(String), equalTo(2));
		assertThat(context.getObjectCount(Rectangle), equalTo(1));
		assertThat(context.getObjectCount(Date), equalTo(1));
		assertThat(context.getObjectCount(Sprite), equalTo(1));
		
		assertThat(context.getObjectByType(String), equalTo("foo"));
		assertThat(context.getAllObjectsByType(String), arrayWithSize(2));
	}
	
	[Test]
	public function injections () : void {
		var root:Context = ContextBuilder
				.newBuilder().object(new StringHolder("byId1"), "id1").build();
		var parentA:Context = ContextBuilder.newSetup().parent(root)
				.newBuilder().object(new StringHolder("byType")).build();
		var parentB:Context = ContextBuilder.newSetup().parent(root)
				.newBuilder().object(new StringHolder("byId2"), "id2").build();
		var target:InjectionTarget = new InjectionTarget();
		ContextBuilder.newSetup().parent(parentA).parent(parentB)
				.newBuilder().object(target).build();
			
		assertThat(target.byType.value, equalTo("byType"));
		assertThat(target.byId1.value, equalTo("byId1"));
		assertThat(target.byId2.value, equalTo("byId2"));
	}

	[Test]
	public function inheritedServices () : void {
		var tracker:InvocationTracker = new InvocationTracker();
		var root:Context = ContextBuilder
				.newBuilder().build();
		var parentA:Context = ContextBuilder.newSetup().parent(root)
				.services().viewManager().setImplementation(MockViewManager, "1")
				.services().viewManager().addDecorator(MockViewManagerDecorator, "1", tracker)
				.newBuilder().build();
		var parentB:Context = ContextBuilder.newSetup().parent(root)
				.services().viewManager().setImplementation(MockViewManager, "2")
				.services().viewManager().addDecorator(MockViewManagerDecorator, "2", tracker)
				.newBuilder().build();
		var context:Context = ContextBuilder.newSetup().parent(parentA).parent(parentB)
				.newBuilder().build();
				
		assertThat("" + parentA.viewManager, equalTo("1")); 
		assertThat("" + parentB.viewManager, equalTo("2")); 
		assertThat("" + context.viewManager, equalTo("1")); 
		
		assertThat(tracker.invocations, equalTo("1212")); 
	}
	
	[Test]
	public function inheritedScopeExtensions () : void {
		var tracker:InvocationTracker = new InvocationTracker();
		var root:Context = ContextBuilder
				.newBuilder().build();
		var parentA:Context = ContextBuilder.newSetup().parent(root)
				.scopeExtensions().forType(ScopeExtension).setImplementation(MockScopeExtension, "1")
				.scopeExtensions().forType(ScopeExtension).addDecorator(MockScopeExtensionDecorator, "1", tracker)
				.newBuilder().build();
		var parentB:Context = ContextBuilder.newSetup().parent(root)
				.scopeExtensions().forType(ScopeExtension).setImplementation(MockScopeExtension, "2")
				.scopeExtensions().forType(ScopeExtension).addDecorator(MockScopeExtensionDecorator, "2", tracker)
				.newBuilder().build();
		var context:Context = ContextBuilder.newSetup().parent(parentA).parent(parentB)
				.newBuilder().build();
				
		assertThat("" + parentA.scopeManager.getScope(ScopeName.LOCAL).extensions.forType(ScopeExtension), equalTo("1")); 
		assertThat("" + parentB.scopeManager.getScope(ScopeName.LOCAL).extensions.forType(ScopeExtension), equalTo("2")); 
		assertThat("" + context.scopeManager.getScope(ScopeName.LOCAL).extensions.forType(ScopeExtension), equalTo("1")); 
		
		assertThat(tracker.invocations, equalTo("1212")); 
	}
	
	[Test]
	public function asyncInit () : void {
		var asyncA:AsyncInitModelMetadata = new AsyncInitModelMetadata();
		var asyncB:AsyncInitModelMetadata = new AsyncInitModelMetadata();
		var root:Context = ContextBuilder.newBuilder().build();
		var parentA:Context = ContextBuilder.newSetup().parent(root).newBuilder().object(asyncA).build();
		var parentB:Context = ContextBuilder.newSetup().parent(root).newBuilder().object(asyncB).build();
		var parentSync:Context = ContextBuilder.newSetup().parent(root).newBuilder().build();
		var context:Context = ContextBuilder.newSetup()
				.parent(parentA)
				.parent(parentSync)
				.parent(parentB)
				.newBuilder().build();
		
		assertThat(context.initialized, isFalse());
		asyncA.dispatchEvent(new Event(Event.COMPLETE));
		assertThat(context.initialized, isFalse());
		asyncB.dispatchEvent(new Event(Event.COMPLETE));
		assertThat(context.initialized, isTrue());
	}
	
}
}

import flash.display.DisplayObject;

import org.spicefactory.parsley.core.view.ViewManager;


class MockViewManager implements ViewManager {

	private var id:String;
	
	function MockViewManager (id:String) {
		this.id = id;
	}

	public function addViewRoot (view:DisplayObject) : void {
	}
	
	public function removeViewRoot (view:DisplayObject) : void {
	}
	
	public function toString () : String {
		return id;
	}
	
}

class MockViewManagerDecorator implements ViewManager {

	private var delegate:ViewManager;
	
	function MockViewManagerDecorator (delegate:ViewManager, id:String, tracker:InvocationTracker) {
		this.delegate = delegate;
		tracker.track(id);
	}

	public function addViewRoot (view:DisplayObject) : void {
		delegate.addViewRoot(view);
	}
	
	public function removeViewRoot (view:DisplayObject) : void {
		delegate.removeViewRoot(view);
	}
	
	public function toString () : String {
		return (delegate as Object).toString();
	}
	
	
}

class InvocationTracker {
	
	private var _invocations:String = "";
	
	public function track (id:String) : void {
		_invocations += id;
	}
	
	public function get invocations () : String {
		return _invocations;
	}
	
}

interface ScopeExtension {
	
}

class MockScopeExtension implements ScopeExtension {
	
	private var id:String;
	
	function MockScopeExtension (id:String) {
		this.id = id;
	}

	public function toString () : String {
		return id;
	}
}

class MockScopeExtensionDecorator implements ScopeExtension {

	private var delegate:ScopeExtension;
	
	function MockScopeExtensionDecorator (delegate:ScopeExtension, id:String, tracker:InvocationTracker) {
		this.delegate = delegate;
		tracker.track(id);
	}

	public function toString () : String {
		return (delegate as Object).toString();
	}
	
	
}

