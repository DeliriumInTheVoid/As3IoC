package hxioc.ioc
{
    internal class InjectionFunctionsLinker
    {
        public var injectionFunctionsHash:Vector.<Function>;
        public var injectionObjectConfig:InjectionBeanConfig;

        public function InjectionFunctionsLinker():void
        {
            this.injectionFunctionsHash = new Vector.<Function>();
        }
    }
}
