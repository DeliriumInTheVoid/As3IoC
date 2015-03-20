package hxioc.ioc
{
    public class InjectionConfig
    {
        private var _id             :String;
        private var _injObjCfgs     :Vector.<InjectionBeanConfig>;

        public function InjectionConfig(id:String = null):void
        {
            this._id = id;
            this._injObjCfgs = new Vector.<InjectionBeanConfig>();
        }

        public function getId():String
        {
            return this._id;
        }

        public function getInjectionObjectConfigs():Vector.<InjectionBeanConfig>
        {
            return this._injObjCfgs;
        }

        protected function getNewInjectionBeanConfig():IInjectionBeanConfig
        {
            var injObjCfg:InjectionBeanConfig;
            injObjCfg = new InjectionBeanConfig();
            this._injObjCfgs.push(injObjCfg);
            return injObjCfg;
        }
    }
}
