({
    getAccountDetailResponse : function(component){
        try
        {
            var action = component.get("c.getAccDetails");
            //Pass the Sap ID to server side so that the response would be obtained based on the sap Id
            console.log('component.get("v.sapId")=>'+component.get("v.sapId"));
            console.log('component.get("v.accCommunicationId")=>'+component.get("v.accCommunicationId"));
            action.setParams({"sapId": component.get("v.sapId")});
            action.setCallback(this, function(response){
            var state = response.getState();
                if (state === "SUCCESS" && !(response.getReturnValue() === 'CalloutError')){
                    console.log('accId================>'+response.getReturnValue());
                        $A.createComponent(
                            "c:Frontier_AccountDetails",
                            {
                                "accId": component.get("v.accId"),
                                "accCommunicationId": component.get("v.accCommunicationId"),
                                "accountDetailResponse":response.getReturnValue()
                            },
                            function(newCmp){
                                //Render the sales order dashboard component to the parent container
                                var cmp = component.find("AccountDetailSection");
                                cmp.set("v.body", newCmp);
                            }
                        );
                            $A.createComponent(
                            "c:FrontierSalesOrderDashboard",
                            {
                                "SalesDetailResponse": response.getReturnValue(),
                                "accId": component.get("v.accId")
                            },
                            function(newCmp){
                                //Render the sales order dashboard component to the parent container
                                var cmp = component.find("SalesOrderDashboard");
                                cmp.set("v.body", newCmp);
                            }
                        );
                    }
                else if(response.getReturnValue() === 'CalloutError'){
                    console.log('CalloutError');
                }
                else{
                    console.log('Call Back Error');
                }
            });
            $A.enqueueAction(action);
        }
        catch(e){
            console.log('Exception Occured'+e);
        }
    }
});