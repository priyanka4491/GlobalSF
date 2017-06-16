({
	navigateToDealerDetails : function(component,event) {
        var dealerAccDetail = component.get("v.growerAcc");
        var dealerAccId = dealerAccDetail.split(',')[0];  
        var dealeraccCommId = dealerAccDetail.split(',')[2];
        var action = component.get("c.getGrowerAccs");        
        /*action.setCallback(this, function(response){	
            var state = response.getState();
            if (state === "SUCCESS" && !(response.getReturnValue() === 'CalloutError')){
                component.set("v.GrowerDetails" ,response.getReturnValue());              
                console.log('Response------------>' + response.getReturnValue());
                $A.createComponent("c:Frontier_DealerDetail_Profile",
                    {
                        "dealerAccId" : dealerAccId,
                        "dealerAccCmmId" : dealeraccCommId
                    },
                    function(newCmp){
                        //Render the sales order dashboard component to the parent container
                        alert();
                        var cmp = component.find("DealerProfileSection");
                        cmp.set("v.body", newCmp);
                    }
                );
               }  
        });
         $A.enqueueAction(action);*/
        $A.createComponent("c:Frontier_DealerDetail_Profile",
                    {
                        "dealerId" : (component.get("v.growerAcc")).split(',')[0],
                        "accCommId" : (component.get("v.growerAcc")).split(',')[2]
                    },
                    function(newCmp){
                        //Render the sales order dashboard component to the parent container
                        var cmp = component.find("DealerProfileSection");
                        cmp.set("v.body", newCmp);
                    }
                );
        
     
	},
    
    toGrowerCount : function(component,event){
        component.set("v.setHeader" , false);
        $A.createComponent("c:Frontier_GrowerAccountList",
                           {label : ""},
                           function(GrowerList){
                               var comp = component.find("growerList");
                               comp.set("v.body",GrowerList);
                           }
    );
    },
    getGrowerCount : function(component,event){
        var action = component.get("c.getGrowerCount");
         action.setParams({
            dealerId : (component.get("v.growerAcc")).split(',')[0]
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.growerCount",response.getReturnValue());
            }
        })
         $A.enqueueAction(action);
    }
})