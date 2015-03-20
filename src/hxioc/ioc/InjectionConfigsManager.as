package hxioc.ioc
{
	import flash.system.ApplicationDomain;
	import flash.utils.describeType;

    public class InjectionConfigsManager
    {
		private static var _inst		:InjectionConfigsManager;
		
        private var _injConfigs			:Vector.<InjectionConfig>;
		
		static public function getInst():InjectionConfigsManager
		{
			if (_inst == null) {
				_inst = new InjectionConfigsManager(new PrivateBlocker());
			}
			return InjectionConfigsManager._inst;
		}
		
        public function InjectionConfigsManager(blocker:PrivateBlocker):void
        {
			if((blocker is PrivateBlocker) == false){
				throw "InjectionConfigsManager is a singleton";
			}
            _injConfigs = new Vector.<InjectionConfig>();
        }

        public function addInjectionConfig(config:InjectionConfig):void
        {
            var injObjCfgs:Vector.<InjectionBeanConfig>;
            var l:int;
            l = _injConfigs.length;
            while (--l >= 0)
			{
                if (_injConfigs[l].getId() == config.getId()){
                    throw "Injection config with id = " + config.getId() + " already added.";
                }
            }
            injObjCfgs = config.getInjectionObjectConfigs();

            for each(var injObjCfg:InjectionBeanConfig in injObjCfgs) {
                addInjectionBeanConfig(injObjCfg);
            }

            _injConfigs.push(config);
        }

        public function removeInjectionConfigById(id:String, updateReceivers:Boolean = false):void
        {
            var cfg:InjectionConfig;
            var l:int;
            var cfgsL:int;
            var injObjCfgs:Vector.<InjectionBeanConfig>;
            l = _injConfigs.length;
            while(--l >= 0)
            {
                cfg = _injConfigs[l];
                if(cfg.getId() == id)
                {
                    _injConfigs.splice(l, 1);
                    injObjCfgs = cfg.getInjectionObjectConfigs();
                    cfgsL = injObjCfgs.length;
                    while(--cfgsL <= 0){
                        removeInjectionBeanConfig(injObjCfgs[cfgsL], updateReceivers);
                    }
                }
            }
        }

        public function createBeanConfig():IInjectionBeanConfig
        {
            var cfg:InjectionBeanConfig;
            cfg = new InjectionBeanConfig(addInjectionBeanConfig);
            return cfg;
        }

        public function addBean(beanClass:Class):void
        {
			var recClass:Class;
			var beanIterf:Class;
			
			var xml:XML;
			xml = describeType(beanClass);
			
			var f:XML = xml..factory[0];
			
			var injBeans:XMLList = f.metadata.(@name == "InjectionBean");
			
			var injBean:XML;
			
			var type:String = null;
			var updateAll:Boolean;
			var asSingleton:Boolean;
			var receiverClass:String = null;
			var beanInterface:String = null;
			
			var o:XML;

			for each(injBean in injBeans)
			{
				o = injBean.arg.(@key == "type")[0];
				if(o != null){
					type = o.@value;
				}
				o = injBean.arg.(@key == "updateAll")[0];
				if(o != null){
					updateAll = (o.@value == "true");
				}
				
				o = injBean.arg.(@key == "asSingleton")[0];
				if(o != null){
					asSingleton = (o.@value == "true");
				}
				
				o = injBean.arg.(@key == "receiverClass")[0];
				if(o != null){
					receiverClass = o.@value;
				}
				o = injBean.arg.(@key == "beanInterface")[0];
				if(o != null){
					beanInterface = o.@value;
				}
			}
			
			if(ApplicationDomain.currentDomain.hasDefinition(receiverClass)){
				recClass = ApplicationDomain.currentDomain.getDefinition(receiverClass) as Class;
			}
			
			if(ApplicationDomain.currentDomain.hasDefinition(beanInterface)){
				beanIterf = ApplicationDomain.currentDomain.getDefinition(beanInterface) as Class;
			}
			var config:InjectionBeanConfig;
			config = new InjectionBeanConfig();
			config.
				setType(type).
				setUpdateAll(updateAll).
				setClassReceiver(recClass).
				setAsSingleton(asSingleton);

			if(beanIterf == null){
				config.addBean(beanClass);
			}
			else{
				config.mapBean(beanClass, beanIterf);
			}
			addInjectionBeanConfig(config);
		}

        private function addInjectionBeanConfig(config:InjectionBeanConfig):void
        {
            var funcLinker:InjectionFunctionsLinker;
            funcLinker = InjectionWarehouse.getInst().getInjectionLinker(config.getBeanInterface(), config.getReceiverClassName(), config.getType());
            funcLinker.injectionObjectConfig = config;
            config.addWaitingInjectionFunctions(funcLinker.injectionFunctionsHash);
        }

        private function removeInjectionBeanConfig(config:InjectionBeanConfig, updateReceivers:Boolean = false):void
        {
            var funcLinker:InjectionFunctionsLinker;
            var l:int;
            funcLinker = InjectionWarehouse.getInst().getInjectionLinker(config.getBeanInterface(), config.getReceiverClassName(), config.getType());
            if(funcLinker == null) {
                return;
            }
            funcLinker.injectionObjectConfig = null;
            if(updateReceivers == true)
            {
                l = funcLinker.injectionFunctionsHash.length;
                while (--l >= 0) {
                    funcLinker.injectionFunctionsHash[l](null);
                }
            }
            funcLinker.injectionFunctionsHash.splice(0, funcLinker.injectionFunctionsHash.length);
        }

    }
}
class PrivateBlocker{}
