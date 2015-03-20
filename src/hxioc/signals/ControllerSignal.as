package hxioc.signals
{
    public class ControllerSignal extends InternalControllerSignal
    {
        public function ControllerSignal()
        {
            super();
        }

        public function send():void
        {
            sendWithData(null);
        }

    }
}