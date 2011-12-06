package org.spicefactory.parsley.binding {

import org.spicefactory.parsley.flex.binding.FlexPropertyWatcher;
import org.spicefactory.parsley.binding.impl.PropertyPublisher;
import org.flexunit.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.nullValue;
import org.hamcrest.object.sameInstance;
import org.spicefactory.parsley.binding.model.AnimalSubscribeMetadata;
import org.spicefactory.parsley.binding.model.Cat;
import org.spicefactory.parsley.binding.model.CatPubSubMetadata;
import org.spicefactory.parsley.binding.model.CatPublishCustomMetadata;
import org.spicefactory.parsley.binding.model.CatPublishIdMetadata;
import org.spicefactory.parsley.binding.model.CatPublishLocalMetadata;
import org.spicefactory.parsley.binding.model.CatPublishManagedMetadata;
import org.spicefactory.parsley.binding.model.CatPublishMetadata;
import org.spicefactory.parsley.binding.model.CatSubscribeCustomMetadata;
import org.spicefactory.parsley.binding.model.CatSubscribeIdMetadata;
import org.spicefactory.parsley.binding.model.CatSubscribeLocalMetadata;
import org.spicefactory.parsley.binding.model.CatSubscribeMetadata;
import org.spicefactory.parsley.binding.model.StringPublishPersistentMetadata;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;
import org.spicefactory.parsley.core.scope.ScopeName;
import org.spicefactory.parsley.core.state.GlobalState;
import org.spicefactory.parsley.dsl.context.ContextBuilder;
import org.spicefactory.parsley.lifecycle.observer.model.LifecycleObserverDelegate;
import org.spicefactory.parsley.runtime.RuntimeContextBuilder;

/**
 * @author Jens Halm
 */
public class BindingMetadataTagTest {
	
	
	[BeforeClass]
	public static function setPropertyWatcherType (): void {
		PropertyPublisher.propertyWatcherType = FlexPropertyWatcher;
	}
	
	[Test]
	public function publish () : void {
		var pub:CatPublishMetadata = new CatPublishMetadata();
		var sub:CatSubscribeMetadata = new CatSubscribeMetadata();
		RuntimeContextBuilder.build([pub,sub]);
		assertThat(sub.value, nullValue());
		pub.value = new Cat();
		assertThat(sub.value, sameInstance(pub.value));
	}
	
	[Test]
	public function publishSubscribe () : void {
		var pub1:CatPubSubMetadata = new CatPubSubMetadata();
		var pub2:CatPubSubMetadata = new CatPubSubMetadata();
		var sub:CatSubscribeMetadata = new CatSubscribeMetadata();
		RuntimeContextBuilder.build([pub1, pub2, sub]);
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
	
	[Test]
	public function publishSubscribeLifecycle () : void {
		var pub1:CatPubSubMetadata = new CatPubSubMetadata();
		var pub2:CatPubSubMetadata = new CatPubSubMetadata();
		var sub:CatSubscribeMetadata = new CatSubscribeMetadata();
		var context:Context = RuntimeContextBuilder.build([sub]);
		assertThat(sub.value, nullValue());
		var cat1:Cat = new Cat();
		var cat2:Cat = new Cat();
		pub1.value = cat1;
		var dyn1:DynamicObject = context.addDynamicObject(pub1);
		assertThat(sub.value, sameInstance(cat1));
		assertThat(pub1.value, sameInstance(cat1));
		assertThat(pub2.value, nullValue());
		pub2.value = cat2;
		var dyn2:DynamicObject = context.addDynamicObject(pub2);
		assertThat(sub.value, sameInstance(cat1));
		assertThat(pub1.value, sameInstance(cat1));
		assertThat(pub2.value, sameInstance(cat1));
		pub2.value = cat2;
		assertThat(sub.value, sameInstance(cat2));
		assertThat(pub1.value, sameInstance(cat2));
		assertThat(pub2.value, sameInstance(cat2));
		dyn1.remove();
		assertThat(sub.value, sameInstance(cat2));
		assertThat(pub1.value, nullValue());
		assertThat(pub2.value, sameInstance(cat2));
		dyn2.remove();
		assertThat(sub.value, nullValue());
		assertThat(pub1.value, nullValue());
		assertThat(pub2.value, nullValue());
	}
	
	[Test(expects="org.spicefactory.parsley.core.errors.ContextBuilderError")]
	public function conflictingPublishers () : void {
		var pub1:CatPublishMetadata = new CatPublishMetadata();
		var pub2:CatPublishMetadata = new CatPublishMetadata();
		var sub:CatSubscribeMetadata = new CatSubscribeMetadata();
		RuntimeContextBuilder.build([pub1, pub2, sub]);
	}
	
	[Test]
	public function publishId () : void {
		var pub:CatPublishMetadata = new CatPublishMetadata();
		var pubId:CatPublishIdMetadata = new CatPublishIdMetadata();
		var sub:CatSubscribeMetadata = new CatSubscribeMetadata();
		var subId:CatSubscribeIdMetadata = new CatSubscribeIdMetadata();
		RuntimeContextBuilder.build([pub, pubId, sub, subId]);
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
		var pub:CatPublishMetadata = new CatPublishMetadata();
		var sub:AnimalSubscribeMetadata = new AnimalSubscribeMetadata();
		RuntimeContextBuilder.build([pub,sub]);
		assertThat(sub.value, nullValue());
		pub.value = new Cat();
		assertThat(sub.value, sameInstance(pub.value));
	}
	
	[Test]
	public function localScope () : void {
		var pub:CatPublishLocalMetadata = new CatPublishLocalMetadata();
		var sub:CatSubscribeMetadata = new CatSubscribeMetadata();
		var subLocal:CatSubscribeLocalMetadata = new CatSubscribeLocalMetadata();
		RuntimeContextBuilder.build([pub, sub, subLocal]);
		assertThat(sub.value, nullValue());
		assertThat(subLocal.value, nullValue());
		pub.value = new Cat();
		assertThat(sub.value, nullValue());
		assertThat(subLocal.value, sameInstance(pub.value));
	}
	
	[Test]
	public function customScope () : void {
		var pub:CatPublishCustomMetadata = new CatPublishCustomMetadata();
		var sub:CatSubscribeMetadata = new CatSubscribeMetadata();
		var subCustom:CatSubscribeCustomMetadata = new CatSubscribeCustomMetadata();
		ContextBuilder.newSetup()
			.scope("custom")
			.newBuilder()
				.object(pub)
				.object(sub)
				.object(subCustom)
				.build();
		assertThat(sub.value, nullValue());
		assertThat(subCustom.value, nullValue());
		pub.value = new Cat();
		assertThat(sub.value, nullValue());
		assertThat(subCustom.value, sameInstance(pub.value));
	}
	
	[Test]
	public function contextDestruction () : void {
		var pub:CatPublishMetadata = new CatPublishMetadata();
		var sub:CatSubscribeMetadata = new CatSubscribeMetadata();
		var context:Context = RuntimeContextBuilder.build([pub,sub]);
		assertThat(sub.value, nullValue());
		pub.value = new Cat();
		assertThat(sub.value, sameInstance(pub.value));
		context.destroy();
		assertThat(sub.value, nullValue());
	}
	
	[Test]
	public function publishManaged () : void {
		var pub:CatPublishMetadata = new CatPublishMetadata();
		var pubMgd:CatPublishManagedMetadata = new CatPublishManagedMetadata();
		var context:Context = RuntimeContextBuilder.build([pub, pubMgd]);
		var added:Array = new Array();
		var listener:Function = function (c:Cat) : void {
			added.push(c);
		};
		var removed:Array = new Array();
		var listener2:Function = function (c:Cat) : void {
			removed.push(c);
		};
		context.scopeManager.getScope(ScopeName.LOCAL)
				.lifecycleObservers.addObserver(new LifecycleObserverDelegate(listener, Cat, ObjectLifecycle.POST_INIT));
		context.scopeManager.getScope(ScopeName.LOCAL)
				.lifecycleObservers.addObserver(new LifecycleObserverDelegate(listener2, Cat, ObjectLifecycle.PRE_DESTROY));
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
		DictionaryPersistenceService.putStoredValue("local0", String, "test", "A");
		
		var pub1:StringPublishPersistentMetadata = new StringPublishPersistentMetadata();
		var pub2:StringPublishPersistentMetadata = new StringPublishPersistentMetadata();
		
		var context:Context = ContextBuilder
			.newSetup()
				.scopeExtensions()
					.forType(PersistenceManager)
					.setImplementation(DictionaryPersistenceService)
				.newBuilder()
					.object(pub1)
					.object(pub2)
					.build();
		
		assertThat(DictionaryPersistenceService.getStoredValue("local0", String, "test"), equalTo("A"));
		pub1.value = "B";
		assertThat(pub2.value, equalTo("B"));
		assertThat(DictionaryPersistenceService.changeCount, equalTo(1));
		assertThat(DictionaryPersistenceService.getStoredValue("local0", String, "test"), equalTo("B"));
		context.destroy();
		assertThat(DictionaryPersistenceService.changeCount, equalTo(1));
		assertThat(DictionaryPersistenceService.getStoredValue("local0", String, "test"), equalTo("B"));
	}
}
}
