package org.spicefactory.parsley.lifecycle.asyncinit.model {

/**
* @author Jens Halm
*/
public class InitSequenceRecorder
{
    
    private var _values:Array = new Array();
    
    public function addValue(value:String):void
    {
        _values.push(value);
    }
    
    public function get value():String
    {
        return _values.join(" ");
    }


}
}