package org.spicefactory.parsley.binding {

import org.flexunit.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.nullValue;
import org.hamcrest.object.sameInstance;
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.binding.model.AnimalHolder;
import org.spicefactory.parsley.binding.model.Cat;
import org.spicefactory.parsley.binding.model.CatHolder;
import org.spicefactory.parsley.binding.model.StringHolder;
import org.spicefactory.parsley.core.binding.PersistenceManager;
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.core.bootstrap.BootstrapManager;
import org.spicefactory.parsley.core.bootstrap.impl.DefaultBootstrapManager;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.processor.DestroyPhase;
import org.spicefactory.parsley.core.scope.ScopeName;
import org.spicefactory.parsley.core.state.GlobalState;
import org.spicefactory.parsley.lifecycle.observer.model.LifecycleObserverDelegate;

/**
 * @author Jens Halm
 */
public class BindingTestBase {
	
	
	private var context:Context;
	
	
	[Before]
	public function createContext () : void {
		context = bindingContext;
	}
	
	protected function get bindingContext () : Context {
		throw new AbstractMethodError();
	}
	
	protected function addConfig (conf:BootstrapConfig) : void {
		throw new AbstractMethodError();
	}
	
	
	[Test]
	public function publish () : void {
		var pub:CatHolder = context.getObject("publish") as CatHolder;
		var sub:CatHolder = context.getObject("subscribe") as CatHolder;
		assertThat(sub.value, nullValue());
		pub.value = new Cat();
		assertThat(sub.value, sameInstance(pub.value));
	}
	
	[Test]
	public function publishSubscribe () : void {
		var pub1:CatHolder = context.getObject("pubsub") as CatHolder;
		var pub2:CatHolder = context.getObject("pubsub") as CatHolder;
		var sub:CatHolder = context.getObject("subscribe") as CatHolder;
		assertThat(sub.value, nullValue());
		var cat1:Cat = new Cat();
		var cat2:Cat = new Cat();
		pub1.value = cat1;
		assertThat(sub.value, sameInstance(cat1));
		assertThat(pub1.value, sameInstance(cat1));
		assertThat(pub2.value, sameInstance(cat1));
		pub2.value = cat2;
		assertThat(sub.value, sameInstance(cat2));
		assertThat(pub1.value, sameInstance(cat2));
		assertThat(pub2.value, sameInstance(cat2));
	}
	
	[Test(expects="Error")]
	public function conflictingPublishers () : void {
		context.getObject("publish");
		context.getObject("subscribe");
		context.getObject("publish");
	}
	
	[Test]
	public function publishId () : void {
		var pub:CatHolder = context.getObject("publish") as CatHolder;
		var pubId:CatHolder = context.getObject("publishId") as CatHolder;
		var sub:CatHolder = context.getObject("subscribe") as CatHolder;
		var subId:CatHolder = context.getObject("subscribeId") as CatHolder;
		assertThat(sub.value, nullValue());
		assertThat(subId.value, nullValue());
		var cat1:Cat = new Cat();
		var cat2:Cat = new Cat();
		pub.value = cat1;
		assertThat(sub.value, sameInstance(cat1));
		assertThat(subId.value, nullValue());
		pubId.value = cat2;
		assertThat(sub.value, sameInstance(cat1));
		assertThat(subId.value, sameInstance(cat2));
	}
	
	[Test]
	public function publishPolymorphically () : void {
		var pub:CatHolder = context.getObject("publish") as CatHolder;
		var sub:AnimalHolder = context.getObject("animalSubscribe") as AnimalHolder;
		assertThat(sub.value, nullValue());
		pub.value = new Cat();
		assertThat(sub.value, sameInstance(pub.value));
	}
	
	[Test]
	public function localScope () : void {
		var pub:CatHolder = context.getObject("publishLocal") as CatHolder;
		var sub:CatHolder = context.getObject("subscribe") as CatHolder;
		var subLocal:CatHolder = context.getObject("subscribeLocal") as CatHolder;
		assertThat(sub.value, nullValue());
		assertThat(subLocal.value, nullValue());
		pub.value = new Cat();
		assertThat(sub.value, nullValue());
		assertThat(subLocal.value, sameInstance(pub.value));
	}
	
	[Test]
	public function contextDestruction () : void {
		var pub:CatHolder = context.getObject("publish") as CatHolder;
		var sub:CatHolder = context.getObject("subscribe") as CatHolder;
		assertThat(sub.value, nullValue());
		pub.value = new Cat();
		assertThat(sub.value, sameInstance(pub.value));
		context.destroy();
		assertThat(sub.value, nullValue());
	}
	
	[Test]
	public function publishManaged () : void {
		var pub:CatHolder = context.getObject("publish") as CatHolder;
		var pubMgd:CatHolder = context.getObject("publishManaged") as CatHolder;
		var added:Array = new Array();
		var listener:Function = function (c:Cat) : void {
			added.push(c);
		};
		var removed:Array = new Array();
		var listener2:Function = function (c:Cat) : void {
			removed.push(c);
		};
		context.scopeManager.getScope(ScopeName.LOCAL)
				.lifecycleObservers.addObserver(new LifecycleObserverDelegate(listener, Cat));
		context.scopeManager.getScope(ScopeName.LOCAL)
				.lifecycleObservers.addObserver(new LifecycleObserverDelegate(listener2, Cat, DestroyPhase.preDestroy()));
		var cat1:Cat = new Cat();
		var cat2:Cat = new Cat();
		pub.value = cat1;
		pubMgd.value = cat2;
		assertThat(added, array(cat2));
		pubMgd.value = null;
		assertThat(removed, array(cat2));
	}
	
	[Test]
	public function publishPersistent () : void {
		var reg:Object = GlobalState.scopes;
		reg.reset();
		DictionaryPersistenceService.reset();
		DictionaryPersistenceService.putStoredValue("local0", "test", "A");
		
		var manager:BootstrapManager = new DefaultBootstrapManager();
		manager.config.scopeExtensions.forType(PersistenceManager).setImplementation(DictionaryPersistenceService);
		addConfig(manager.config);
		var context:Context = manager.createProcessor().process();
		
		var pub1:StringHolder = context.getObject("publishPersistent") as StringHolder;
		var pub2:StringHolder = context.getObject("publishPersistent") as StringHolder;
		assertThat(DictionaryPersistenceService.getStoredValue("local0", "test"), equalTo("A"));
		pub1.value = "B";
		assertThat(pub2.value, equalTo("B"));
		assertThat(DictionaryPersistenceService.changeCount, equalTo(1));
		assertThat(DictionaryPersistenceService.getStoredValue("local0", "test"), equalTo("B"));
		context.destroy();
		assertThat(DictionaryPersistenceService.changeCount, equalTo(1));
		assertThat(DictionaryPersistenceService.getStoredValue("local0", "test"), equalTo("B"));
	}
	
	
}
}
