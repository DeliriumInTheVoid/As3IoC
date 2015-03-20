package hxioc.ioc
{
    import flash.utils.getQualifiedClassName;

    public class Injector
    {

        static private var _inst:Injector;

        private var _type:String;
        private var _receiverObjType:String;
        private var _once:Boolean;

        static public function getInst():Injector
        {
            if (Injector._inst == null) {
                Injector._inst = new Injector(new SingletonBlocker);
            }
            return Injector._inst;
        }

        public function Injector(singletonBlocker:SingletonBlocker)
        {
            if (!(singletonBlocker is SingletonBlocker)) {
                throw new Error("Injector is singleton class");
            }

            setDefaultValues();
        }

        private function setDefaultValues():void
        {
            this._type = null;
            this._receiverObjType = InjectorUtils.getNormalizedType(null);
            this._once = true;
        }

        public function setType(value:String):Injector
        {
            this._type = InjectorUtils.getNormalizedType(value);
            return this;
        }

        public function setReceiverObject(value:Object):Injector
        {
            if (value == null) {
                this._receiverObjType = InjectorUtils.getNormalizedType(null);
            }
            else {
                this._receiverObjType = getQualifiedClassName(value);
            }
            return this;
        }

        public function setInjectOnce(value:Boolean):Injector
        {
            this._once = value;
            return this;
        }

        public function addInjectionLambda(lambda:Function, beanInterface:Class):void
        {
            var funcLinker:InjectionFunctionsLinker;
            funcLinker = InjectionWarehouse.getInst().getInjectionLinker(beanInterface, this._receiverObjType, this._type);
            if (this._once == false) {
                funcLinker.injectionFunctionsHash.push(lambda);
            }

            setDefaultValues();
            if (funcLinker.injectionObjectConfig != null) {
                funcLinker.injectionObjectConfig.addInjection(lambda);
            }
        }

        public function removeInjectionLamda(lambda:*, beanInterface:Class):void
        {
            var funcLinker:InjectionFunctionsLinker;
            var ind:int;
            funcLinker = InjectionWarehouse.getInst().getInjectionLinker(beanInterface, this._receiverObjType, this._type);
            ind = funcLinker.injectionFunctionsHash.indexOf(lambda);
            if (ind >= 0) {
                funcLinker.injectionFunctionsHash.splice(ind, 1);
            }
        }

        public function inject(beanInterface:Class):*
        {
            var funcLinker:InjectionFunctionsLinker;
            var injObj:*;
            injObj = null;
            funcLinker = InjectionWarehouse.getInst().getInjectionLinker(beanInterface, this._receiverObjType, this._type);
            setDefaultValues();
            if (funcLinker.injectionObjectConfig != null) {
                injObj = funcLinker.injectionObjectConfig.getBean();
            }
            return injObj;
        }
    }
}
internal class SingletonBlocker{}
