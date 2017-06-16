({
	getAddressdetails : function(component, event) {
        var acccomId = component.get("v.accComId");
        var acctId =  component.get("v.accountId");
        var action = component.get("c.getAccountCommunicationDetails");        
        action.setParams({
            accId : acctId,
            accComId : acccomId,
            
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var retResponse = JSON.parse(response.getReturnValue());
                console.log("accountCommResult::" + retResponse);
                component.set("v.acctDetails",JSON.parse(retResponse[0]));
                component.set("v.accountCommList",JSON.parse(retResponse[1]));
            }
            else{
                console.log("Error Occured");
            }
        });
        $A.enqueueAction(action);
	}
})