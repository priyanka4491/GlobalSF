({
	doinit : function(component, event, helper) {
        var action = component.get("c.getAccounts");
        action.setParams({
            "searchKey": '',
            pageNumber : 1,
            pageSize : 10
        })
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS"){
                Component.set('accountList',JSON.parse(response.getReturnValue()));
            }
         }
		
	}
})