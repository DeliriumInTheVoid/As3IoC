package hxioc.ioc
{

    internal class InjectorUtils
    {
        static public function getNormalizedType(type:String):String
        {
            if (type == null) {
                return "___NULL_TYPE___";
            }
            if (type.length == 0) {
                return "___EMPTY_TYPE___";
            }
            return type;
        }

    }
}
