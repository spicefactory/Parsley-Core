package org.spicefactory.parsley.util {
import org.spicefactory.parsley.util.matcher.ContextStateMatcher;
import org.hamcrest.Matcher;
/**
 * @author Jens Halm
 */
public function contextInState (configured:Boolean = true, initialized:Boolean = true, destroyed:Boolean = false) : Matcher {
	return new ContextStateMatcher(configured, initialized, destroyed);
}
}
