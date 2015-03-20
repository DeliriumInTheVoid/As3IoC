package hxioc.signals
{

    public class BaseTypedSignal
    {
        public function BaseTypedSignal():void
        {
            this._bindedFunc = new Vector.<Function>();
        }

        private var _bindedFunc:Vector.<Function>;

        public function bind(func:Function):void
        {
            if (this._bindedFunc.indexOf(func) < 0) {
                this._bindedFunc.push(func);
            }
        }

        public function unbind(func:Function):void
        {
            var index:int = this._bindedFunc.indexOf(func);

            if (index != -1) {
                this._bindedFunc.splice(index, 1);
            }
        }

        public function unbindAll():void
        {
            _bindedFunc.length = 0;
        }

        protected function sendSignal(value:Object):void
        {
            for each (var func:Function in _bindedFunc) {
                func(value);
            }
        }

    }
}
