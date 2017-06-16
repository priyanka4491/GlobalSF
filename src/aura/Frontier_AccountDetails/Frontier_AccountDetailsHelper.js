({
    getAccounts:function(cmp){
        console.log('accountDetailResponse=>'+cmp.get("v.accountDetailResponse"));
        cmp.set("v.accountDetail",JSON.parse(cmp.get("v.accountDetailResponse")));
        console.log('accId=>'+ cmp.get("v.accId"));
        console.log('accCommunicationId=>'+ cmp.get("v.accCommunicationId"));
        var action = cmp.get("c.getAccountDetails");
        action.setParams({ accId : cmp.get("v.accId"),accCommunicationId : cmp.get("v.accCommunicationId"),result : cmp.get("v.accountDetailResponse")});
        // Create a callback that is executed after
        // the server-side action returns
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                console.log('accountResponse=>'+response.getReturnValue());
                var salesDetailJson = JSON.parse(response.getReturnValue());
                cmp.set("v.account", salesDetailJson);
            }
            else if (state === "ERROR"){
                var errors = response.getError();
                if (errors){
                    if (errors[0] && errors[0].message){
                        console.log("Error message: "+errors[0].message);
                    }
                } else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
});