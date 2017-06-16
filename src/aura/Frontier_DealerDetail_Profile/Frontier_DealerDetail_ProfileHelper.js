({
	dealerProfile : function(component, event, helpe) {
        var seasonVal = '2017 Safra';    
        var selectedSeason = component.find("selectedSeason").get("v.value");
        if(selectedSeason != null)
        {
        	seasonVal = selectedSeason;
        }
        var selecteddealer = component.get("v.dealerId");
	    var action = component.get("c.dealerAccountDetails");
        console.log('selecteddealer'+selecteddealer+'action'+action+'seasonVal'+seasonVal);
        action.setParams({
            dealerAccount : component.get("v.dealerId"),
            dealerAccComm : component.get("v.accCommId"),
			season :seasonVal            
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
             var dealerAccountDetailJson = JSON.parse(response.getReturnValue());
                console.log('Inside Profile' +JSON.stringify(dealerAccountDetailJson ));
            component.set("v.dealerProfileDetails",dealerAccountDetailJson);
               //this.getSeasonDetails(component,event,helper);
            } else if (response.getState() === "ERROR") {
                $A.log("Errors", response.getError());
                component.set("v.isCallBackError",false);
            }
        });
                           
       $A.enqueueAction(action);                    
	}
});