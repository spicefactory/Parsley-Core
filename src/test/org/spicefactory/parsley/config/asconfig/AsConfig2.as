package org.spicefactory.parsley.config.asconfig {
import org.spicefactory.parsley.testmodel.ClassWithSimpleProperties;
import org.spicefactory.parsley.testmodel.LazyTestClass;

/**
 * @author Jens Halm
 */
public class AsConfig2 {
	
	
	[ObjectDefinition(id="foo")]
	public function get overwrittenId () : ClassWithSimpleProperties {
		return new ClassWithSimpleProperties();
	}
	
	[ObjectDefinition(singleton="false")]
	public function get prototypeInstance () : ClassWithSimpleProperties {
		return new ClassWithSimpleProperties();
	}
	
	[ObjectDefinition(lazy="true")]
	public function get lazyInstance () : LazyTestClass {
		return new LazyTestClass();
	}
	
	public function get eagerInstance () : LazyTestClass {
		return new LazyTestClass();
	}
	
	[Internal]
	public function get notIncludedInContext () : Object {
		return null;
	}
	
	
}
}
