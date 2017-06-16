({
	growerProfile : function(component, event, helpe) {
        var seasonVal = 'SUMMER';    
        var selectedSeason = component.find("selectedSeason").get("v.value");
        if(selectedSeason != null)
        {
        	seasonVal = selectedSeason;
        }
        console.log('Inside Grower Profile');        
        var selectedGrower = component.get("v.growerId");
	    var action = component.get("c.growerAccountDetails");
        action.setParams({
            growerAccount : component.get("v.growerId"),
            growerAccComm : component.get("v.accCommId"),
			season :seasonVal            
        });
        action.setCallback(this, function(response) {
            if (action.getState() === "SUCCESS") {
             var growerAccountDetailJson = JSON.parse(response.getReturnValue());
              console.log('growerAccountDetailJson' + JSON.stringify(growerAccountDetailJson));
               console.log('growerAccountDetailJson.growerSeason' + growerAccountDetailJson.growerSeason);
             component.set("v.GrowerProfileDetails",growerAccountDetailJson);
             console.log('growerAccountDetailJson.growerSeason' + growerAccountDetailJson.growerSeason);

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
});