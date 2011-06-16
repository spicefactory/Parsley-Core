package org.spicefactory.parsley.context.scope {
import org.spicefactory.parsley.core.scope.Scope;
import org.spicefactory.parsley.core.scope.InitializingExtension;

/**
 * @author Jens Halm
 */
public class InitializingTestExtension implements InitializingExtension {

	public var scope:Scope;

	public function init (scope:Scope) : void {
		this.scope = scope;
	}
	
}
}
