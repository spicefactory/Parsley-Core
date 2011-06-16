package org.spicefactory.parsley.lifecycle.asyncinit {
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.lifecycle.asyncinit.config.AsyncInitMxmlConfig;
import org.spicefactory.parsley.lifecycle.asyncinit.config.AsyncInitOrderedMxmlConfig;

/**
 * @author Jens Halm
 */
public class AsyncInitMxmlTagTest extends AsyncInitTestBase {
	
	
	protected override function get defaultContext () : Context {
		return ActionScriptContextBuilder.build(AsyncInitMxmlConfig);
	}
	
	protected override function get orderedContext () : Context {
		return ActionScriptContextBuilder.build(AsyncInitOrderedMxmlConfig);
	}
	
	
}
}
