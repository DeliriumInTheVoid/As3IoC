package hxioc.signals
{

    public class BaseParamsSignal
    {
        public function BaseParamsSignal():void
        {
            this._values = new Array();
            this._bindedFunc = new Vector.<Function>;
        }

        private var _bindedFunc:Vector.<Function>;
        protected var _values:Array;

        public function bind(func:Function):void
        {
            if (this._bindedFunc.indexOf(func) < 0) {
                this._bindedFunc.push(func);
            }
        }

        public function unbind(func:Function):void
        {
            var ind:int;
            ind = this._bindedFunc.indexOf(func);
            if (ind >= 0) {
                this._bindedFunc.splice(ind, 1);
            }
        }

        public function unbindAll():void
        {
            _bindedFunc.length = 0;
            _values.length = 0;
        }

        protected function sendSignal():void
        {
			try{
				sendSignalWithCustomData(_values);
			}
            catch(error:Error)
			{
				this._values.length = 0;
				throw error;
			}
			finally{
				this._values.length = 0;
			}
        }

        protected function sendSignalWithCustomData(data:Array):void
        {
            var f:Function;
            for each(f in _bindedFunc) {
                f.apply(null, data);
            }
        }

        protected function pushValue(value:Object):void
        {
            this._values.push(value);
        }

    }
}
