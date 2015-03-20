package hxioc.ioc
{

    public interface IInjectionBeanConfig
    {
        function setAsSingleton(value:Boolean):IInjectionBeanConfig;

        function setUpdateAll(value:Boolean):IInjectionBeanConfig;

        function setType(value:String):IInjectionBeanConfig;

        function setClassReceiver(value:Class):IInjectionBeanConfig;

        function mapBean(beanClass:Class, beanInterface:Class):void;

        function addBean(beanClass:Class):void;

        function mapSingleton(instance:Object, beanInterface:Class):void;

        function addSingleton(instance:Object):void;

        function addInjection(lambda:Function):void;
    }
}
