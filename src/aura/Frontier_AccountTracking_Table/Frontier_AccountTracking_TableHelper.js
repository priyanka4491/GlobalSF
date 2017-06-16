({
    getsObjectRecords : function(component,page1, productID, sortFieldName) {
        var page = page1 || 1;
        console.log(JSON.stringify(component.get("v.Trackingtabledetails")));
        var action = component.get("c.getAccounts");
        console.log("sort" + sortFieldName);
        console.log("productID" + productID);
        action.setParams({
            result : component.get("v.Trackingtabledetails"),
            pageNumber : page,
            pageSize : component.get("v.pageSize"),
            ProductId : productID,
            sortFieldName: sortFieldName
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var retResponse = response.getReturnValue();
                console.log('Success');
            }else if (state === "ERROR") {
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
    }
});