({
	getAllAccounts : function(component,page,event,isPageChange,isInitialize) {
        console.log('Inside AccountList Helper');
       

        var programId = component.get("v.programId");
        var action1 = component.get("c.getProgramAccounts");
        var triggeredField = null;
        //alert(JSON.stringify(component.get("v.SortByField")));
       if(!isInitialize){
            //alert('event.currentTarget.id=>'+event.currentTarget.id);
            if(event.currentTarget && event.currentTarget.id != null){
                console.log('Inside Helper Target' + event.currentTarget.id);
                var sortfield=component.get("v.SortByField."+event.currentTarget.id);
                triggeredField = component.get("v.SortByField."+event.currentTarget.id);
                component.set("v.triggeredField",triggeredField);
                console.log('Triggered Field'+triggeredField);
            }
            else if(isPageChange && component.get("v.triggeredField") != ""){
                triggeredField = component.get("v.triggeredField");
            }
        }
        //alert(triggeredField);
        console.log('programId'+programId);
        
        // var page = page || 1;
        action1.setParams({
             programId: programId,
             pageSize : component.get("v.pageSize"),
             pageNumber : page,
             triggeredField : triggeredField,
             isInitialize : isInitialize,
             isPageChange : isPageChange
        });
        console.log('programId CLLBCK'+programId);
        window.setTimeout(
            $A.getCallback(function() {
                if (component.isValid()) {
                    action1.setCallback(this,function(response1) {
                        
                        console.log('programId RESPONSE'+programId);
                        
                        if( response1.getState() == 'SUCCESS'){
                            var accounts = [];
                            component.set("v.page",page);
                            var retResponse = response1.getReturnValue();
                            console.log("retResponse"+ JSON.stringify(retResponse[1]));
                            if(retResponse.length>0){
                                
                                component.set("v.total",JSON.parse(retResponse[0]));
                                component.set("v.pages",Math.ceil((JSON.parse(retResponse[0]))/component.get("v.pageSize")));
                                accounts = JSON.parse(retResponse[1]);
                                component.set("v.accounts", accounts);
                                component.set("v.SortByField", JSON.parse(retResponse[2]));
                                
                                
                                
                                
                            }
                            else{
                                component.set("v.total",0);
                                component.set("v.pages",1); 
                                component.set("v.page",1); 
                            }
                            
                            
                        }
                        else if (state === "ERROR"){
                            console.log('Error');
                        }      
                        
                    });
                    $A.enqueueAction(action1);

                }
            })
        );
	}
});