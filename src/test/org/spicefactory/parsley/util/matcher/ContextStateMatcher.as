package org.spicefactory.parsley.util.matcher {
import org.hamcrest.BaseMatcher;
import org.hamcrest.Description;
import org.spicefactory.parsley.core.context.Context;

/**
 * @author Jens Halm
 */
public class ContextStateMatcher extends BaseMatcher {
	
	private var configured:Boolean;
	private var initialized:Boolean;
	private var destroyed:Boolean;
	
	public function ContextStateMatcher (configured:Boolean, initialized:Boolean, destroyed:Boolean) {
		super();
		this.configured = configured;
		this.initialized = initialized;
		this.destroyed = destroyed;
	}
	
	/**
	 * @inheritDoc
	 */
    public override function matches (item:Object) : Boolean {
    	if (!(item is Context)) return false;
    	var context:Context = Context(item);
        return context.configured == configured
        	&& context.initialized == initialized
        	&& context.destroyed == destroyed;
	}
        
    /**
	 * @inheritDoc
	 */
    public override function describeTo (description:Description) : void {
        description.appendValue("Context with state: configured=" + configured
        	+ ", initialized=" + initialized
        	+ ", destroyed=" + destroyed);
	}
        
	
}
}

