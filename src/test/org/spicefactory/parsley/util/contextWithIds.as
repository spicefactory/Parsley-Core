package org.spicefactory.parsley.util {
import org.hamcrest.Matcher;
import org.spicefactory.parsley.util.matcher.ContextIdMatcher;
/**
 * @author Jens Halm
 */
public function contextWithIds (type:Class, ...ids) : Matcher {
	return new ContextIdMatcher(type, ids);
}
}
