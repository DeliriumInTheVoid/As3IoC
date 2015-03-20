package
{
    import hxioc.ioc.Injector;

    public function inject(beanInterface:Class, type:String = null):*
    {
        return Injector.
                getInst().
                setType(type).
                inject(beanInterface);
    }
}
