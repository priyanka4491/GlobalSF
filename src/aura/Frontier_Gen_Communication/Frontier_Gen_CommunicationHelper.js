({
    findCommunication : function(component, event, helper, isInitialize) {
        // get the current record id
        debugger;
        var currentrecordId = component.get("v.recordId");
        var action = component.get("c.getCommunicationDetails");        
        action.setStorable();
        action.setParams({
            recordId : currentrecordId
        });
        action.setCallback(this, function(response) {
            if (action.getState() === "SUCCESS") {
                var communicationDetailsJson = JSON.parse(response.getReturnValue());
                console.log('communicationDetailsJson' + JSON.stringify(communicationDetailsJson));
                component.set("v.communicationDetail",communicationDetailsJson); 
                var startTime = performance.now();

                //this.getSeasonDetails(component,event,helper);
            } else if (response.getState() === "ERROR") { 
                component.set("v.isCallBackError",false);
                component.set("v.ServerError",response);
                $A.log("Errors", response.getError());
                console.log("Errors", response.getError());
            }
        });        
        $A.enqueueAction(action);                    
    }
})