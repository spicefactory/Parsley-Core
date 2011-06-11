package org.spicefactory.parsley.core.view.util {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.view.ViewConfiguration;

/**
 * Utility for fetching matching ObjectDefinitions from the Context for a particular target instance.
 * 
 * @author Jens Halm
 */
public class ViewDefinitionLookup {
	
	
	/**
	 * Looks for an ObjectDefinition that matches for the specified view configuration.
	 * Can be used by ViewProcessors and other objects in case the definition has not 
	 * been explicitly specified on the view configuration.
	 * 
	 * @param config the view configuration to find the matching definition for
	 * @param context the Context to use for looking up the definition
	 * @return a definition matching the specified view configuration or null if no such definition exists 
	 */
	public static function findMatchingDefinition (config:ViewConfiguration, context:Context) : DynamicObjectDefinition {
		var definition:DynamicObjectDefinition;
		if (config.configId != null) {
			definition = getDefinitionById(config, context);
		}
		if (definition == null) {
			definition = getDefinitionByType(config, context);
		}
		return definition;
	}
	
	private static function getDefinitionById (config:ViewConfiguration, context:Context) : DynamicObjectDefinition {
		if (!context.containsObject(config.configId)) return null;
		var definition:ObjectDefinition = context.getDefinition(config.configId);
		if (definition is DynamicObjectDefinition && config.target is definition.type.getClass()) {
			return definition as DynamicObjectDefinition;
		} else {
			return null;
		}
	}
	
	private static function getDefinitionByType (config:ViewConfiguration, context:Context) : DynamicObjectDefinition {
		var type:Class = ClassInfo.forInstance(config.target, context.domain).getClass();
		
		var ids:Array = context.getObjectIds(type);
		var def:DynamicObjectDefinition = null;
		
		for each (var id:String in ids) {
			var candidate:ObjectDefinition = context.getDefinition(id);
			if (candidate is DynamicObjectDefinition && config.target is candidate.type.getClass()) {
				if (def == null) {
					def = candidate as DynamicObjectDefinition; 
				}
				else {
					throw new ContextError("More than one view definition for type " 
							+ type + " was registered");
				}
			}
		}
		return def;
	}
	
	
}
}
