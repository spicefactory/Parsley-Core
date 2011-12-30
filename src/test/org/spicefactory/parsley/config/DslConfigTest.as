package org.spicefactory.parsley.config {

import org.hamcrest.assertThat;
import org.hamcrest.core.isA;
import org.hamcrest.core.not;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.sameInstance;
import org.spicefactory.parsley.context.ContextBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.coretag.inject.model.InjectedDependency;
import org.spicefactory.parsley.inject.Inject;
import org.spicefactory.parsley.messaging.model.SimpleMessageHandlersMetadata;
import org.spicefactory.parsley.testmodel.SimpleInjectionTarget;

/**
 * @author Jens Halm
 */
public class DslConfigTest {
	
	
	[Test]
	public function messageRouterDelegate () : void {
		MessageRouterDecorator.initCount = 0;
		MessageRouterDecorator.messageCount = 0;
		var context:Context = ContextBuilder.newSetup()
				.services().messageRouter().addDecorator(MessageRouterDecorator)
				.newBuilder()
				.object(new SimpleMessageHandlersMetadata())
				.build();	
		context.scopeManager.dispatchMessage(7);
		context.scopeManager.dispatchMessage(new Date());
		assertThat(MessageRouterDecorator.initCount, equalTo(1));
		assertThat(MessageRouterDecorator.messageCount, equalTo(1));
	}
	
	[Test]
	public function injectFromDefinition () : void {
		var builder:ContextBuilder = ContextBuilder.newBuilder();
		
		var target:ObjectDefinitionBuilder = builder.objectDefinition().forClass(SimpleInjectionTarget);
		var dependency:DynamicObjectDefinition = builder.objectDefinition()
			.forClass(InjectedDependency)
				.asDynamicObject()
					.build();
					
		target.constructorArgs(Inject.fromDefinition(dependency));
		target.property("fromProperty").value(Inject.fromDefinition(dependency));
		target.method("init").invoke(Inject.fromDefinition(dependency));
		
		target.asSingleton().register();
		
		var context:Context = builder.build();
		var targetInstance:SimpleInjectionTarget = context.getObjectByType(SimpleInjectionTarget) as SimpleInjectionTarget;
		
		assertThat(targetInstance.fromConstructor, isA(InjectedDependency));
		assertThat(targetInstance.fromProperty, isA(InjectedDependency));
		assertThat(targetInstance.fromMethod, isA(InjectedDependency));
		assertThat(targetInstance.fromConstructor, not(sameInstance(targetInstance.fromProperty)));
		assertThat(targetInstance.fromConstructor, not(sameInstance(targetInstance.fromMethod)));
	}
}
}

import org.spicefactory.parsley.core.bootstrap.BootstrapInfo;
import org.spicefactory.parsley.core.bootstrap.InitializingService;
import org.spicefactory.parsley.core.command.ObservableCommand;
import org.spicefactory.parsley.core.messaging.Message;
import org.spicefactory.parsley.core.messaging.MessageReceiverCache;
import org.spicefactory.parsley.core.messaging.MessageRouter;

class MessageRouterDecorator implements MessageRouter, InitializingService {
	
	public static var initCount:int;
	public static var messageCount:int;
	
	private var delegate:MessageRouter;
	
	
	function MessageRouterDecorator (delegate:MessageRouter) {
		this.delegate = delegate;
	}
	
	public function init (info:BootstrapInfo) : void {
		initCount++;
	}
	
	public function dispatchMessage (message:Message, cache:MessageReceiverCache) : void {
		messageCount++;
		delegate.dispatchMessage(message, cache);
	}

	public function observeCommand (command:ObservableCommand, 
			typeCache:MessageReceiverCache, triggerCache:MessageReceiverCache) : void {
		delegate.observeCommand(command, typeCache, triggerCache);
	}

}
