({
    afterRender: function (component, helper) {
        this.superAfterRender();
        /*console.log("-------");
        if(component.get("v.renderCount")>=0){
            var cmpEvent = component.getEvent("loadCarosel");
            cmpEvent.fire();
        }
        component.set("v.renderCount",component.get("v.renderCount")+1)*/
    },
    
    rerender: function(component, helper){
        console.log("rerender check::");
    }
})