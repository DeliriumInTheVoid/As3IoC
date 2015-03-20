package hxioc.ioc
{
    import flash.utils.getQualifiedClassName;

    internal class InjectionWarehouse
    {
        private var _injInterfHash:Object;

        public function InjectionWarehouse():void
        {
            this._injInterfHash = {};
        }

        public function getInjectionLinker(beanInterface:Class, receiverClassName:String, type:String):InjectionFunctionsLinker
        {
            var injClassHash:Object;
            injClassHash = this._injInterfHash[getQualifiedClassName(beanInterface)];
            if (injClassHash == null) {
                injClassHash = {};
                this._injInterfHash[getQualifiedClassName(beanInterface)] = injClassHash;
            }
            var injTypeHash:Object;
            injTypeHash = injClassHash[receiverClassName];
            if (injTypeHash == null) {
                injTypeHash = {};
                injClassHash[receiverClassName] = injTypeHash;
            }
            var linker:InjectionFunctionsLinker;
            linker = injTypeHash[InjectorUtils.getNormalizedType(type)];
            if (linker == null) {
                linker = new InjectionFunctionsLinker();
                injTypeHash[InjectorUtils.getNormalizedType(type)] = linker;
            }
            return linker;
        }

        static private var _inst:InjectionWarehouse;

        static public function getInst():InjectionWarehouse
        {
            if (InjectionWarehouse._inst == null) {
                InjectionWarehouse._inst = new InjectionWarehouse();
            }
            return InjectionWarehouse._inst;
        }

    }
}
