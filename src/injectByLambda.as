package {
    import hxioc.ioc.Injector;

    public function injectByLambda(beanInterface:*, lambda:Function, type:String = null):void
    {
        Injector.
            getInst().
            setType(type).
            addInjectionLambda(lambda, beanInterface);
    }
}
