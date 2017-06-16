({
    getsObjectRecords : function(component,page1, productID) {
        var page = page1 || 1;
        console.log('page' + page);
        var action = component.get("c.getGrowerRecords");
        var fields = component.get("v.fields");
        var sortFieldName = "";
        console.log('sortFieldName' + component.get("v.object"));
        console.log('sortFieldName' + component.get("v.pageSize"));
        action.setParams({
            ObjectName : component.get("v.object"),
            fieldstoget : fields.join(),
            pageNumber : page,
            pageSize : component.get("v.pageSize"),
            ProductId : productID
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log("State" + state);
            if(state === 'SUCCESS'){
                var retRecords=[];
                console.log("State" + state);
                console.log('retRecords=>'+ response.getReturnValue());
                retRecords = response.getReturnValue();
                 //component.set("v.accountrec", retRecords);
                  component.set("v.accountrec", retRecords);

               
            }else if (state === "ERROR") {
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
    }
});