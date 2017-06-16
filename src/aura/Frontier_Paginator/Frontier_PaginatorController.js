({
    previousPage : function(component,event,helper){
        var comp = component.get("v.compName");
        var myEvent = $A.get("e.c:Frontier_PageChange");
        myEvent.setParams({ "direction": "previous"});
        myEvent.setParams({ "direct": "previous"});
         myEvent.setParams({ "compName":comp });
        myEvent.fire();
    },
    nextPage : function(component,event,helper){
        var comp = component.get("v.compName");
        var myEvent = $A.get("e.c:Frontier_PageChange");
        myEvent.setParams({ "direction": "next"});
        myEvent.setParams({ "direct": "next"});
         myEvent.setParams({ "compName":comp });
        myEvent.fire();
    }
});