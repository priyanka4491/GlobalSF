({
    navigateToGrowerProfile : function(component,event){
        console.log('Inside Helper');
        //var action = component.get("c.getGrowerAccFarmingDatas");
        var growerAccDetail = component.get("v.growerAcc");
        var growerAccId = growerAccDetail.split(',')[0];  
        var groweraccCommId = growerAccDetail.split(',')[2];
        //action.setCallback(this, function(response){
            //var state = response.getState();
            //if (state === "SUCCESS" && !(response.getReturnValue() === 'CalloutError')){
                //component.set("v.GrowerDetails" ,response.getReturnValue());
                //console.log('Response------------>' + response.getReturnValue());
                $A.createComponent(
                    "c:Frontier_GrowerProfileDetails",
                    {
                        "GrowerDetailResponse": '',
                        "growerId":growerAccId,
                        "accCommId":groweraccCommId
                    },
                    function(newCmp){
                        //Render the sales order dashboard component to the parent container
                        var cmp = component.find("GrowerProfileSection");
                        cmp.set("v.body", newCmp);
                    }
                );
               /* $A.createComponent(
                    "c:Frontier_GrowerAccount_RecordTouchPoint",
                    {
                        "GrowerDetailResponse": response.getReturnValue(),
                        "growerId":growerAccId

                        
                    },
                    function(newCmp){
                        //Render the sales order dashboard component to the parent container
                        var cmp = component.find("GrowerRecordTouchPointSection");
                        cmp.set("v.body", newCmp);
                    }
                );*/
            //}  
            /* else if(response.getReturnValue() === 'CalloutError'){
                    console.log('CalloutError');
                }
                else{
                    console.log('Call Back Error');
                }*/
            
        //});
        
        // $A.enqueueAction(action);
     },
    navigateToPreviousTouchPoint : function(component,event){
        var growerAccDetail = component.get("v.growerAcc");
        var growerAccId = growerAccDetail.split(',')[0];  
        var groweraccCommId = growerAccDetail.split(',')[2];
        $A.createComponent("c:Frontier_GrowerAccount_PreviousTouchPoints",
                           {label : "",
                            "growerId":growerAccId
							},
                           function(PreviousTouchPoint){
                               console.log('AccountList');
                               var comp = component.find("previousTouch");
                               comp.set("v.body",PreviousTouchPoint);
                           }
                          );
    },
    navigateToGrowerFarmSize : function(component,event){
        var growerAccDetail = component.get("v.growerAcc");
        var growerAccId = growerAccDetail.split(',')[0];  
        var groweraccCommId = growerAccDetail.split(',')[2];
        console.log('Frontier_GrowerAccount_FarmSize');
                $A.createComponent("c:Frontier_GrowerAccount_FarmSize",
                                   {
                                     "growerAccId":growerAccId
									},
                                   function(GrowerFarmSize){
                                       console.log('growerFarmSize');
                                       var comp = component.find("growerFarmSize");
                                       comp.set("v.body",GrowerFarmSize);
                                   }
                                  ); 
    },
    
    navigateToGrowerAccountSales : function(component,event){
        var growerAccDetail = component.get("v.growerAcc");
        var growerAccId = growerAccDetail.split(',')[0];  
        var groweraccCommId = growerAccDetail.split(',')[2];
        
                $A.createComponent("c:Frontier_GrowerAccount_Sales_Master",
                                   {
                                    "growerAccId":growerAccId
									},
                                   function(GrowerAccountSales){
                                       console.log('growerSales');
                                       var comp = component.find("growerSales");
                                       comp.set("v.body",GrowerAccountSales);
                                   }
                                  );
            }
        
        
       
    
})