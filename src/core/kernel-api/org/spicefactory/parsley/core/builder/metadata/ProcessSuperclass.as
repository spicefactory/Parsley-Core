/*
 * Copyright 2010 the original author or authors.
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

package org.spicefactory.parsley.core.builder.metadata {

[Metadata(types="class")]
/**
 * Metadata tag that can be used on classes where the framework should process metadata on the superclass. 
 * This will only process metadata on the class level. The Flash Player does not automatically inherit metadata tags on class level,
 * and Parsley per default does not process the inheritance tree for a configured object due to the associated performance hit.
 * This tag has no effect on the behaviour for methods and properties though, as the Flash Player applies its own inheritance rules here.
 * 
 * @author Jens Halm
 */
public class ProcessSuperclass {
	
}
}
