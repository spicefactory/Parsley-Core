package org.spicefactory.parsley.core.registry {
import org.spicefactory.parsley.core.lifecycle.ManagedObject;

/**
 * Represents a value that needs to be resolved before being passed to 
 * another object.
 * 
 * @author Jens Halm
 */
public interface ResolvableValue {
	
	
	/**
	 * Returns the resolved value represented by this instance.
	 * The specified managed object is the target the resolved value will 
	 * be passed to or injected into. The Context the managed object belongs
	 * to may be used to resolve references to other objects and the lifecycle
	 * of those references may be synchronized to the specified managed object.
	 * 
	 * @param target the managed object the value will be passed to
	 * @return the resolved value represented by this instance
	 */
	function resolve (target:ManagedObject) : *;
	
	
}
}
