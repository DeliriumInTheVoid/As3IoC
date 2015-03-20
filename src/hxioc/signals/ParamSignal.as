package hxioc.signals
{

    public class ParamSignal extends BaseTypedSignal
    {
        public function ParamSignal()
        {
            super();
        }

        public function send(value:Object):void
        {
            sendSignal(value);
        }

    }
}
