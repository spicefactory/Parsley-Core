package org.spicefactory.parsley.lifecycle.observer {
import mx.containers.Box;
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.lifecycle.observer.model.LifecycleEventCounter;
import org.spicefactory.parsley.util.XmlContextUtil;


/**
 * @author Jens Halm
 */
public class ObserveXmlTagTest extends ObserveMethodTestBase {

	
	
	public override function get observeContext () : Context {
		var contextA:Context = XmlContextUtil.newContext(boxConfig);
  		var contextB:Context = XmlContextUtil.newContext(boxConfig, contextA, "custom");
  		return XmlContextUtil.newContext(listenerConfig, contextB);
	}
	
	public static const boxConfig:XML = <objects xmlns="http://www.spicefactory.org/parsley">
		<object type="mx.containers.HBox" lazy="true"/>
		<object type="mx.containers.VBox" lazy="true"/>
		<object type="mx.containers.Box" lazy="true"/>
		<object type="mx.controls.Text" lazy="true" id="text"/>
		<object type="mx.controls.Text" lazy="true" id="text2"/>
	</objects>;
	
	public static const listenerConfig:XML = <objects xmlns="http://www.spicefactory.org/parsley">
		<object type="mx.containers.HBox" lazy="true"/>
		<object type="mx.containers.VBox" lazy="true"/>
		<object type="mx.containers.Box" lazy="true"/>
		<object type="mx.controls.Text" lazy="true" id="text"/>
		<object type="mx.controls.Text" lazy="true" id="text2"/>
		<object type="org.spicefactory.parsley.lifecycle.observer.model.LifecycleEventCounter">
			<observe method="globalListener"/>
			<observe method="globalVListener"/>
			<observe method="globalHListener"/>
			<observe method="localListener" scope="local"/>
			<observe method="localVListener" scope="local"/>
			<observe method="localHListener" scope="local"/>
			<observe method="customListener" scope="custom"/>
			<observe method="customVListener" scope="custom"/>
			<observe method="customHListener" scope="custom"/>
			<observe method="globalIdListener" object-id="text"/>
			<observe method="globalDestroyListener" phase="postDestroy"/>
		</object>
	</objects>;
	
	
	[Test]
	public function testObserverProxy () : void {
		var config:XML = <objects xmlns="http://www.spicefactory.org/parsley">
			<object type="mx.containers.Box" order="1"/>
			<object type="org.spicefactory.parsley.lifecycle.observer.model.LifecycleEventCounter" order="2">
				<observe method="globalListener"/>
			</object>
		</objects>;
		var context:Context = XmlContextUtil.newContext(config); 
		var counter:LifecycleEventCounter = context.getObjectByType(LifecycleEventCounter) as LifecycleEventCounter;
		assertThat(counter.getCount(), equalTo(1));
		assertThat(counter.getCount(Box), equalTo(1));
	}
	
	
}
}
