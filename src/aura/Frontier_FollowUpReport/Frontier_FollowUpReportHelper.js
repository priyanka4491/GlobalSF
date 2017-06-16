({
    getsTaskObjectRecords : function(component,event,helper,page,isPageChange,isInitialize,taskId) {        
        
        //var fieldName =  (event.target ? (event.target.id != null ?component.get("v.SortByField."+event.target.id):""):"");
        var triggeredField = null;
        if(!isInitialize){
            if(event.target && event.target.id != null){
                triggeredField = component.get("v.SortByField."+event.target.id);
                component.set("v.triggeredField",triggeredField);
                console.log('Triggered Field'+triggeredField);
            }
            else if(isPageChange && component.get("v.triggeredField") != ""){
                triggeredField = component.get("v.triggeredField");
            }
        }
        
        var followupList = component.find("followupList").get("v.value");
        var action = component.get("c.findActivities");
        console.log('*****************'+page);
        console.log('triggeredField'+triggeredField);
        var page = page || 1;
        var pageSize=component.get("v.pageSize");
        console.log(followupList + 'followupList');
        action.setParams({
            pageNumber : page,
            pageSize : component.get("v.pageSize"),
            followupList : followupList,        
            triggeredField : triggeredField,
            isInitialize : isInitialize,
            isPageChange : isPageChange,
            taskId : taskId
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var followuplist = [];
                //component.set("v.latestRecords",response.getReturnValue());
                
                var retResponse = response.getReturnValue();
                console.log("retResponse"+ retResponse);
                followuplist = JSON.parse(retResponse[1]);
                if(retResponse.length > 0){
                    component.set("v.page",page);
                    component.set("v.total",JSON.parse(retResponse[0]));
                    component.set("v.pages",Math.ceil((JSON.parse(retResponse[0]))/component.get("v.pageSize")));
                    
                    console.log("followuplist length "+ followuplist.length);
                    
                    component.set("v.FollowUpDataList", followuplist);
                    component.set("v.SortByField", JSON.parse(retResponse[2]));
                    console.log('Sort Order'+retResponse[2])
                }
                else if(retResponse.length == 0){
                    component.set("v.FollowUpDataList", followuplist);
                    component.set("v.page",1);
                    component.set("v.total",0);
                                  component.set("v.pages",1);
                }
            }
            else if (state === "ERROR"){
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
    }    
 
 })