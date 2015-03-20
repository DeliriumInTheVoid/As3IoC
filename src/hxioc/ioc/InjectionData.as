package hxioc.ioc
{

    public class InjectionData
    {

        private var _type               :String;
        private var _receiverObj        :*;
        private var _beanInterface      :Class;
        private var _once               :Boolean;

        public function InjectionData()
        {
            _type = null;
            _receiverObj = null;
            _beanInterface = null;
            _once = false;
        }

        public function setType(value:String):InjectionData
        {
            _type = value;
            return this;
        }

        public function setReceiverObject(value:*):InjectionData
        {
            _receiverObj = value;
            return this;
        }

        public function setBeanInterface(beanInterface:Class):InjectionData
        {
            _beanInterface = beanInterface;
            return this;
        }

        public function setOnce(value:Boolean):InjectionData
        {
            _once = value;
            return this;
        }

        public function getType():String
        {
            return _type;
        }

        public function getReceiverObject():*
        {
            return _receiverObj;
        }

        public function getBeanInterface():Class
        {
            return _beanInterface;
        }

        public function getOnce():Boolean
        {
            return _once;
        }

        public function equalsTo(injData:InjectionData):Boolean
        {
            return injData.getType() == _type && injData.getReceiverObject() == _receiverObj && injData.getBeanInterface() == _beanInterface;
        }

    }
}
