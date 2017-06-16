({
    getLastData : function(component, nDay) {
        var action = component.get("c.getLastData");
        action.setParams({
            "nDay": nDay
        });
        action.setCallback(this, function(a) {
            var perRadlClass = JSON.parse(a.getReturnValue());
            component.set("v.Accountdevelopavg", perRadlClass.develop);
            component.set("v.Accountacquireavg", perRadlClass.aquire);
            component.set("v.Accountretainavg", perRadlClass.retain);
            component.set("v.Accountlighttouchavg", perRadlClass.lighttouch);
        });
        $A.enqueueAction(action);
    }
});