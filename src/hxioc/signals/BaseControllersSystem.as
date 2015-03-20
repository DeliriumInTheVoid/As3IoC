package hxioc.signals
{

    public class BaseControllersSystem
    {
        public function BaseControllersSystem()
        {
        }

        protected function sendSinalWithData(controller:InternalControllerSignal, data:Array):void
        {
            controller.sendWithData(data);
        }

    }
}
