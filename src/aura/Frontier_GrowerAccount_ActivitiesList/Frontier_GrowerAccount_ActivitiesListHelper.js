({
	getProgramActivitiesList : function(component,event,page,isPageChange,isInitialize) {
        var triggeredField = null;
       if(!isInitialize){
            if(event.currentTarget && event.currentTarget.id != null){
                console.log('Inside Helper Target' + event.currentTarget.id);
                var sortfield=component.get("v.SortByField." +event.currentTarget.id);
                triggeredField = component.get("v.SortByField."+event.currentTarget.id);
                component.set("v.triggeredField",triggeredField);
                console.log('Triggered Field'+triggeredField);
            }
            else if(isPageChange && component.get("v.triggeredField") != ""){
                triggeredField = component.get("v.triggeredField");
            }
        }
        var action = component.get("c.getProgramActivities");
        var accDetail = component.get("v.growerAcc");
        var accId = accDetail.split(',')[0];  
        var accCommId = accDetail.split(',')[2];
        action.setParams({
                pageNumber : page,
                pageSize : component.get("v.pageSize"),
                accountId : accId,
                triggeredField : triggeredField,
                isInitialize : isInitialize,
                isPageChange : isPageChange
            });
         action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var programEventlist = [];
                    component.set("v.page",page);
                    var retResponse = response.getReturnValue();
                    console.log("retResponse"+ JSON.stringify(retResponse));
                    component.set("v.total",JSON.parse(retResponse[0]));
                    component.set("v.pages",Math.ceil((JSON.parse(retResponse[0]))/component.get("v.pageSize")));
                    programEventlist = JSON.parse(retResponse[1]);
                    console.log(JSON.stringify(programEventlist));
                    
                    
                    component.set("v.programEventList", programEventlist);
                    component.set("v.SortByField", JSON.parse(retResponse[2]));
                    //component.set("v.programActivityList",JSON.parse(retResponse[3]));
                    //component.set("v.taskCount",parseInt(retResponse[4]));
                    //alert(component.get("v.taskCount"));
                }else if (state === "ERROR"){
                    console.log('Error');
                }
            });
            $A.enqueueAction(action);
        },
     navigateToProgramDetail : function(component,event) {
        console.log("c:Frontier_GrowerAccount_ProgramEventsList");
        var programId = event.currentTarget.id;
        var accDetail = component.get("v.growerAcc");
        var accId = accDetail.split(',')[0];  
        $A.createComponent(
            "c:Frontier_GrowerAccount_ProgramEventsList",
            {
                "programId": programId,
                "accountId" :accId,
                "growerAcc":component.get("v.growerAcc")
                
            },
            function(newCmp){
                var cmp = component.find("ProgramDetail");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );
    },
    cancelSelectedActivity : function(component,event){
     console.log('Inside cancel Activity');
    var accDetail = component.get("v.growerAcc");
    var accId = accDetail.split(',')[0];     
    
	var uniqueId = event.currentTarget.id;
	var taskId = (uniqueId.split('/')[0]);
    var programId = (uniqueId.split('/')[1]);
    //var accId = (uniqueId.split('/')[2]);
	console.log('----'+accId+taskId+programId);
	var action = component.get("c.getCancelActy");
	action.setParams({
            accountId : accId,
			programId : programId,
			taskId : taskId    
        });
		
	action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                console.log('Success');
            }
            else if (state === "ERROR"){
                console.log('Error');
            }
        });
        $A.enqueueAction(action);		
     },
    
    
    createAccountDetailsComp : function(component,event){
        $A.createComponent(
            "c:Frontier_Account_AddressInformation",
            {
                accountId: component.get("v.growerAcc").split(',')[0]?component.get("v.growerAcc").split(',')[0]:'',
                accComId: component.get("v.accComId"),
            },
            function(newCmp){
                var cmp = component.find("addrssInfo");
                cmp.set("v.body", newCmp);
            }
        );
    }
    
		
	
})