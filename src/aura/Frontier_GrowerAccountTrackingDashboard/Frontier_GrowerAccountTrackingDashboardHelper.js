({
    getLastData : function(component, nDay) {
        var action = component.get("c.getLastData");
        action.setParams({
            "nDay": nDay
        });
        action.setCallback(this, function(a) {
            var perRadlClass = JSON.parse(a.getReturnValue());
            component.set("v.Grower_AcquireAvg", perRadlClass.Aquire);
            component.set("v.Grower_DevelopAvg", perRadlClass.Develop);
            component.set("v.Grower_LightTouchAvg", perRadlClass.LightTouch);
            component.set("v.Grower_RetainAvg", perRadlClass.Retain);
        });
        $A.enqueueAction(action);
    }
});