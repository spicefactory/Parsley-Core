/*
 * Copyright 2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.spicefactory.parsley.core.processor {
	
/**
 * Represents a phase during object destruction (the time when an object gets removed from a Context).
 * 
 * @author Jens Halm
 */
public class DestroyPhase implements Phase {
	
	
	private static const PRE_DESTROY: int = -1;
	private static const DESTROY: int = 0;
	private static const POST_DESTROY: int = 1;
	
	
	/**
	 * Represents the phase before the Destroy method on the target
	 * instance gets invoked.
	 * 
	 * @param order additional ordering within the phase (processed in ascending order)
	 * @return a new DestroyPhase instance representing the pre-destroy phase and specified order
	 */
	public static function preDestroy (order:int = 0): DestroyPhase {
		return new DestroyPhase(PRE_DESTROY, order);
	}
	
	/**
	 * Represents the phase during which the Destroy method on the target
	 * instance gets invoked in.
	 * 
	 * @param order additional ordering within the phase (processed in ascending order)
	 * @return a new DestroyPhase instance representing the destroy phase and specified order
	 */
	public static function destroy (order:int = 0): DestroyPhase {
		return new DestroyPhase(DESTROY, order);
	}
	
	/**
	 * Represents the phase after the Destroy method on the target
	 * instance gets invoked.
	 * 
	 * @param order additional ordering within the phase (processed in ascending order)
	 * @return a new DestroyPhase instance representing the post-destroy phase and specified order
	 */
	public static function postDestroy (order:int = 0): DestroyPhase {
		return new DestroyPhase(POST_DESTROY, order);
	}
	
	
	private var phase: int;
	private var order: int;
	
	
	/**
	 * @private
	 */
	function DestroyPhase (phase: int, order: int) {
		this.phase = phase;
		this.order = order;
	}
	
	
	/**
	 * Compares this phase value to the specified other phase value.
	 * Returns -1 if this phase is before the other one, 1 if it comes
	 * after the other phase and 0 if both are equal. This method
	 * can conveniently be used in sort methods.
	 * 
	 * @param other the other phase instance to compare this instance to
	 * @return an integer indicating whether this phase comes before or after the other
	 */
	public function compareTo (other: DestroyPhase): int {
		return (phase < other.phase) ? -1
			: (phase > other.phase) ? 1
			: order - other.order;
	}

	public function get typeKey (): String {
		return "destroy";
	}
	
	
}
}
