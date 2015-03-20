package hxioc.signals
{

    public class SimpleSignal
    {
        private var _bindedFunc:Vector.<Function>;

        public function SimpleSignal():void
        {
            this._bindedFunc = new Vector.<Function>();
        }

        public function bind(func:Function):void
        {
            if (this._bindedFunc.indexOf(func) == -1) {
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

        public function send():void
        {
			var func:Function
            for each (func in _bindedFunc) {
                func();
            }
        }

        public function unbinAll():void
        {
            _bindedFunc.length = 0;
        }

    }
}
