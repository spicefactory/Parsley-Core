package org.spicefactory.parsley.lifecycle.factory {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.notNullValue;
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.coretag.inject.model.RequiredMethodInjection;
import org.spicefactory.parsley.lifecycle.factory.model.TestFactory;
import org.spicefactory.parsley.util.ContextTestUtil;
import org.spicefactory.parsley.util.contextInState;
import org.spicefactory.parsley.util.contextWithIds;

/**
 * @author Jens Halm
 */
public class FactoryMethodTestBase {

	
	[Test]
	public function factoryWithDependency () : void {
		var context:Context = context;
		assertThat(context, contextInState());
		assertThat(context, contextWithIds(RequiredMethodInjection, "factoryWithDependency"));
		assertThat(context.getObjectCount(TestFactory), equalTo(1));
		var obj:RequiredMethodInjection = ContextTestUtil.getAndCheckObject(context, 
				"factoryWithDependency", RequiredMethodInjection) as RequiredMethodInjection;
		assertThat(obj.dependency, notNullValue());
	}
	
	public function get context () : Context {
		throw new AbstractMethodError();
	}
	
	
}
}
