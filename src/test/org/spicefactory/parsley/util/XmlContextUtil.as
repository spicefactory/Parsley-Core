package org.spicefactory.parsley.util {
import org.spicefactory.parsley.context.ContextBuilder;
import org.spicefactory.parsley.context.ContextBuilderSetup;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.xml.XmlConfig;

/**
 * @author Jens Halm
 */
public class XmlContextUtil {
	
	
	public static function newContext (xml:XML, parent:Context = null, 
			customScope:String = null, inherited:Boolean = true) : Context {
		
		var setup:ContextBuilderSetup = ContextBuilder.newSetup();
		if (parent) {
			setup.parent(parent);
		}
		if (customScope) {
			setup.scope(customScope, inherited);
		}
		return setup.newBuilder().config(XmlConfig.forInstance(xml)).build();
	}
	
	
}
}
