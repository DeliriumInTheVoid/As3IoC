package hxioc.ioc
{
    import flash.utils.getQualifiedClassName;

    internal class InjectionBeanConfig implements IInjectionBeanConfig
    {
        private var _type                   :String;
        private var _receiverClassName      :String;
        private var _beanInterface          :Class;
        private var _beanClass              :Class;
        private var _asSingleton            :Boolean;
        private var _isLocked               :Boolean;
        private var _updateAll              :Boolean;
        private var _traceException         :Boolean;
        private var _throwException         :Boolean;
        private var _dispatchFacade         :Boolean;
        private var _instance               :*;

        private var _endCfgCallback         :Function;

        public function InjectionBeanConfig(endConfigurationCallback:Function = null):void
        {
            this._asSingleton = false;
            this._isLocked = false;
            this._updateAll = false;
            this._traceException = false;
            this._throwException = false;
            this._dispatchFacade = false;
            this._type = InjectorUtils.getNormalizedType(null);
            this._receiverClassName = InjectorUtils.getNormalizedType(null);
            _endCfgCallback = endConfigurationCallback;
        }

        public function getReceiverClassName():String
        {
            return this._receiverClassName;
        }

        public function getBeanInterface():Class
        {
            return this._beanInterface;
        }

        public function getType():String
        {
            return this._type;
        }

        public function setAsSingleton(value:Boolean):IInjectionBeanConfig
        {
            this._asSingleton = value;
            return this;
        }

        public function setUpdateAll(value:Boolean):IInjectionBeanConfig
        {
            this._updateAll = value;
            return this;
        }

        public function setType(value:String):IInjectionBeanConfig
        {
            this._type = value;
            return this;
        }

        public function setClassReceiver(value:Class):IInjectionBeanConfig
        {
            if (value == null) {
                return this;
            }
            this._receiverClassName = getQualifiedClassName(value);
            return this;
        }

        public function mapBean(beanClass:Class, beanInterface:Class):void
        {
            this._beanClass = beanClass;
            this._beanInterface = beanInterface;
            endConfiguration();
        }

        public function addBean(beanClass:Class):void
        {
            this._beanClass = beanClass;
            this._beanInterface = beanClass;
            endConfiguration();
        }

        public function mapSingleton(instance:Object, beanInterface:Class):void
        {
            this._asSingleton = true;
            this._instance = instance;
            this._beanInterface = beanInterface;
            endConfiguration();
        }

        public function addSingleton(instance:Object):void
        {
            this._asSingleton = true;
            this._instance = instance;
            this._beanInterface = Object(this._instance).constructor;
            endConfiguration();
        }

        public function addWaitingInjectionFunctions(injFunctions:Vector.<Function>):void
        {
            var i:int;
            var l:int;
            l = injFunctions.length;
            for(i = 0; i < l; ++i){
                addInjectionFunction(injFunctions[i], this._updateAll);
            }
        }

        public function addInjection(lambda:Function):void
        {
            this.addInjectionFunction(lambda);
            endConfiguration();
        }

        public function getBean():*
        {
            return this.getInjectionBean();
        }

        private function addInjectionFunction(lambda:Function, inject:Boolean = true):void
        {
            if (inject == true) {
                lambda(this.getInjectionBean());
            }
        }

        private function getInjectionBean():*
        {
            var injBean:*;
            injBean = null;
            if (this._asSingleton == true)
            {
                if (this._instance == null)
                {
                    if (this._beanClass != null)
                    {
                        this._instance = new this._beanClass();
                        injBean = this._instance;
                    }
                }
                else {
                    injBean = this._instance;
                }
            }
            else if (this._beanClass != null) {
                injBean = new this._beanClass;
            }
            return injBean;
        }

        private function endConfiguration():void
        {
            if(_endCfgCallback != null){
                _endCfgCallback(this);
            }
        }

    }
}
