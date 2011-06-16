package org.spicefactory.parsley.lifecycle.asyncinit {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.lifecycle.asyncinit.config.AsyncInitConfig;
import org.spicefactory.parsley.lifecycle.asyncinit.config.AsyncInitOrderedConfig;

/**
 * @author Jens Halm
 */
public class AsyncInitMetadataTagTest extends AsyncInitTestBase {
	
	
	[Before]
	public function clearReflectionCache () : void {
		ClassInfo.cache.purgeAll();
	}
	
	protected override function get defaultContext () : Context {
		return ActionScriptContextBuilder.build(AsyncInitConfig);
	}
	
	protected override function get orderedContext () : Context {
		return ActionScriptContextBuilder.build(AsyncInitOrderedConfig);
	}
	
	
}
}
