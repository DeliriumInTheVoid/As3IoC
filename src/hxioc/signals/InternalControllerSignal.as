package hxioc.signals
{
    import flash.utils.Dictionary;

    import hxioc.ioc.InjectionData;
    import hxioc.ioc.Injector;

    public class InternalControllerSignal extends BaseParamsSignal
    {
        public function InternalControllerSignal():void
        {
            this._controllers = new Vector.<IController>();
            this._injDatas = new Vector.<InjectionData>();
            this._clearControllersHash = new Dictionary(true);
        }

        protected var _controllers:Vector.<IController>;
        protected var _injDatas:Vector.<InjectionData>;
        protected var _clearControllersHash:Dictionary;

        public function bindController(controller:IController, removeAfterExequte:Boolean = false):void
        {
            if (_controllers.indexOf(controller) >= 0) {
                return;
            }
            this._controllers.push(controller);
            if (removeAfterExequte == true) {
                _clearControllersHash[controller] = true;
            }
        }

        public function bindByInjectionData(injData:InjectionData):Boolean
        {
            var hasData:Boolean;

            var l:int;
            l = _injDatas.length;
            while (--l >= 0) {
                if (_injDatas[l].equalsTo(injData) == true) {
                    hasData = true;
                    break;
                }
            }

            if (hasData == false) {
                this._injDatas.push(injData);
            }
            return !hasData;
        }

        public function unbindByInjectionData(injData:InjectionData):void
        {
            var l:int;
            l = this._injDatas.length;
            while (--l >= 0) {
                if (this._injDatas[l].equalsTo(injData)) {
                    this._injDatas.splice(l, 1);
                }
            }
        }

        public function unbindController(controller:IController):void
        {
            var ind:int;
            ind = this._controllers.indexOf(controller);
            if (ind >= 0) {
                this._controllers.splice(ind, 1);
            }
        }

        override public function unbindAll():void
        {
            super.unbindAll();
            _controllers.length = 0;
            this._injDatas.length = 0;
            this._clearControllersHash = new Dictionary(true);
        }

        internal function sendWithData(data:Array):void
        {
            var i:int;
            var l:int;
            var contr:IController;
            var ind:InjectionData;

            l = _controllers.length;
            for (i = 0; i < l; ++i) {
                contr = _controllers[i];
                contr.execute(data);
                if (contr in _clearControllersHash) {
                    delete _clearControllersHash[contr];
                    _controllers.splice(i, 1);
                    --i;
                    --l;
                }
            }

            l = _injDatas.length;
            for (i = 0; i < l; ++i) {
                ind = _injDatas[i];
                contr = Injector.getInst().
                        setInjectOnce(ind.getOnce()).
                        setType(ind.getType()).
                        setReceiverObject(ind.getReceiverObject()).
                        inject(ind.getBeanInterface());

                if (contr != null) {
                    contr.execute(data);
                }

                if (_injDatas[i].getOnce() == true) {
                    _injDatas.splice(i, 1);
                    --i;
                    --l;
                }
            }

            sendSignalWithCustomData(data);
        }

    }
}
