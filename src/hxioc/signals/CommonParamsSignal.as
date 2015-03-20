package hxioc.signals
{
    import hxioc.signals.BaseParamsSignal;

    public class CommonParamsSignal extends BaseParamsSignal
    {
        public function CommonParamsSignal():void
        {
            super();
        }

        public function addNextValue(value:Object):CommonParamsSignal
        {
            this.pushValue(value);
            return this;
        }

    }
}
