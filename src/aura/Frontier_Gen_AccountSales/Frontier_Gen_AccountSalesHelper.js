({
    getAccountSales : function(component, event, helper, isInitialize) {
        // get the current record id
        debugger;
        var currentrecordId = component.get("v.recordId");       
        var action = component.get("c.getAccountSalesDetails");
      	action.setStorable();
        action.setParams({
            recordId : currentrecordId,
            accountType : "Dealer"
        });
        action.setCallback(this, function(response) {
            if (action.getState() === "SUCCESS") {
                var accountsSalesDetailsJson = JSON.parse(response.getReturnValue());
                console.log('accountsSalesDetailsJson' + JSON.stringify(accountsSalesDetailsJson));
                component.set("v.accountSalesDetails",accountsSalesDetailsJson);                
                //this.getSeasonDetails(component,event,helper);
            } else if (response.getState() === "ERROR") { 
                component.set("v.isCallBackError",false);
                component.set("v.ServerError",response);
                $A.log("Errors", response.getError());
                console.log("Errors", response.getError());
            }
        });        
        $A.enqueueAction(action);                    
    },
    updateCYTarget : function (component, event, helper){
        var CYTargetValue = component.find('CYTargetValue').get('v.value');
        var action = component.get("c.updateCYTarget");
        action.setParams({
            CYTarget : CYTargetValue
        });
        action.setCallback(this, function(response) {
            if (action.getState() === "SUCCESS") {
                alert("update success");
                //var accountsSalesDetailsJson = JSON.parse(response.getReturnValue());
                //console.log('accountsSalesDetailsJson' + JSON.stringify(accountsSalesDetailsJson));
                //component.set("v.accountSalesDetails",accountsSalesDetailsJson);                
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