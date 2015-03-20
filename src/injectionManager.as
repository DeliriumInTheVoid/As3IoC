package
{
    import hxioc.ioc.InjectionConfigsManager;

    public function get injectionManager():InjectionConfigsManager
    {
        return InjectionConfigsManager.getInst();
    }
}