package org.spicefactory.parsley.coretag.metadata {
import org.hamcrest.assertThat;
import org.hamcrest.collection.arrayWithSize;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.builder.metadata.MetadataDecoratorAssembler;
import org.spicefactory.parsley.coretag.metadata.model.ImplementationNoInheritance;
import org.spicefactory.parsley.coretag.metadata.model.ImplementationWithInheritance;
import org.spicefactory.parsley.coretag.metadata.model.SubclassNoInheritance;
import org.spicefactory.parsley.coretag.metadata.model.SubclassWithInheritance;

/**
 * @author Jens Halm
 */
public class MetadataInheritanceTest {
	
	
	private var assembler:MetadataDecoratorAssembler = new MetadataDecoratorAssembler();
	
	
	[Test]
	public function subclassWithoutInheritance () : void {
		var decorators:Array = assembler.assemble(ClassInfo.forClass(SubclassNoInheritance));
		assertThat(decorators, arrayWithSize(6));
	}
	
	[Test]
	public function subclassWithInheritance () : void {
		var decorators:Array = assembler.assemble(ClassInfo.forClass(SubclassWithInheritance));
		assertThat(decorators, arrayWithSize(7));
	}
	
	[Test]
	public function implementationWithoutInheritance () : void {
		var decorators:Array = assembler.assemble(ClassInfo.forClass(ImplementationNoInheritance));
		assertThat(decorators, arrayWithSize(2));
	}
	
	[Test]
	public function implementationWithInheritance () : void {
		var decorators:Array = assembler.assemble(ClassInfo.forClass(ImplementationWithInheritance));
		assertThat(decorators, arrayWithSize(2));
	}
	
	
	
}
}
