({
	getProgramActivityTouchpoints : function(component,event,page,isInitialize,index) {
        //var accountId = component.get("v.accountId");
         var accDetail = component.get("v.growerAcc");
        var accountId = accDetail.split(',')[0]; 
        
        console.log('button pressed'+index);
        console.log('Account Id' + accountId);
        var action = component.get("c.getProgramActivityTouchpoints");
        action.setParams({
                pageNumber : page,
                pageSize : component.get("v.pageSize"),
                accountId : accountId,
            	filterTask : index
            });
         action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var touchpointsList = [];
                    component.set("v.page",page);
                    var retResponse = response.getReturnValue();
                    console.log("retResponse"+ JSON.stringify(retResponse));
                    component.set("v.total",JSON.parse(retResponse[0]));
                    component.set("v.pages",Math.ceil((JSON.parse(retResponse[0]))/component.get("v.pageSize")));
                    touchpointsList = JSON.parse(retResponse[1]);
                    component.set("v.touchpointsList",touchpointsList);
                    console.log('Keyyyyyyyyytouchhh'+component.get("v.touchpointsList"));
                    var touchPointKeys = [];
                    for(var touchpointkey in touchpointsList){
                        touchPointKeys.push(touchpointkey);
                       
                    }
                    
                    //component.set("v.touchpointKeys",touchPointKeys);
                    
                     console.log('Keyyyyyyyyy'+touchPointKeys);
                    
                    component.set("v.touchpointKeys",touchPointKeys);
                    
                    
                    
                }else if (state === "ERROR"){
                    console.log('Error');
                }
            });
            $A.enqueueAction(action);
        },
    
    createAccountDetailsComp : function(component,event){
        $A.createComponent(
            "c:Frontier_Account_AddressInformation",
            {
                accountId:component.get("v.growerAcc").split(',')[0]?component.get("v.growerAcc").split(',')[0]:'',
                accComId: component.get("v.accComId"),
            },
            function(newCmp){
                var cmp = component.find("addrssInfo");
                cmp.set("v.body", newCmp);
            }
        );
    }
   
})