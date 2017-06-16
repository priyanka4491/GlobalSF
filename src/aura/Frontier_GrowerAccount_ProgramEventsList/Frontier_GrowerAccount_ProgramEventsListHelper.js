({
	programEventListHelper : function(component,event,page,isPageChange,isInitialize) {
        var programId = component.get("v.programId");
        var accountId = component.get("v.accountId");
        var action = component.get("c.getProgramEvents");
        console.log('Program Id' + programId);
        var triggeredField = null;
        if(!isInitialize){
            if(event.currentTarget && event.currentTarget.id != null){
                console.log('Inside Helper Target' + event.currentTarget.id);
                var sortfield=component.get("v.SortByField." +event.currentTarget.id);
                console.log('&&&&&&&&&&&&&'+sortfield);
                triggeredField = component.get("v.SortByField."+event.currentTarget.id);
               // triggeredField =event.currentTarget.id;
                component.set("v.triggeredField",triggeredField);
                console.log('Triggered Field'+triggeredField);
            }
            else if(isPageChange && component.get("v.triggeredField") != ""){
                triggeredField = component.get("v.triggeredField");
            }
        }
        
        action.setParams({
                programId : programId,
                accId :accountId,
                pageNumber : page,
                pageSize : component.get("v.pageSize"),
                triggeredField : triggeredField,
                isInitialize : isInitialize,
                isPageChange : isPageChange,
            });
         action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var programEventlist = [];
                    component.set("v.page",page);
                    var retResponse = response.getReturnValue();
                    console.log("retResponse"+ retResponse);
                    if(retResponse.length>0){
                    component.set("v.total",JSON.parse(retResponse[0]));
                    component.set("v.pages",Math.ceil((JSON.parse(retResponse[0]))/component.get("v.pageSize")));
                    programEventlist = JSON.parse(retResponse[1]);
                    component.set("v.programEventList", programEventlist);
                    component.set("v.SortByField", JSON.parse(retResponse[2]));
                    }
                    else{
                    component.set("v.total",0);
                    component.set("v.pages",1); 
                    component.set("v.page",1); 
                    }
                    
                }else if (state === "ERROR"){
                    console.log('Error');
                }
            });
            $A.enqueueAction(action);
        },
cancelSelectedActivity : function(component,event){
	var accDetail = component.get("v.growerAcc");
    var accountId = accDetail.split(',')[0]; 
	var uniqueId = event.currentTarget.id;
	var taskId = (uniqueId.split('/')[0]);
    var programId = (uniqueId.split('/')[1]);
	//var accountId = component.get("v.accountId");
	//var programId = component.get("v.programId");
	
	var action = component.get("c.getCancelActy");
	action.setParams({
            accountId : accountId,
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
    
    navigateToUpdateTouchPointDetail : function(component,event) {
        console.log("c:Frontier_GrowerAccount_UpdateTouchPoint");
        var currentDateId = event.target.parentNode.id;
        var accId =component.get("v.accountId");
        var programId =component.get("v.programId");
        var isReadOnly = false;
        console.log('currentDateId' + currentDateId);
        //alert(document.getElementById(event.target.id).parentNode.parentNode.parentNode.childNodes[1].innerHTML)
        if(document.getElementById(currentDateId).parentNode.parentNode.parentNode.childNodes[1].innerHTML === 'Completed' 
           || document.getElementById(currentDateId).parentNode.parentNode.parentNode.childNodes[1].innerHTML === 'Cancelled'){
            
            isReadOnly = true;
        }
        $A.createComponent(
            "c:Frontier_GrowerAccount_UpdateTouchPoint",
            {
                currentDateId: currentDateId,
                accountId:accId,
                newUpdateStatus:'update',
                programId:programId,
                growerAcc:event.target.parentNode.id,
                isReadOnly : isReadOnly
            },
            function(newCmp){
                var cmp = component.find("AccountDetail");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );
    },
    
    createAccountDetailsComp : function(component,event){
        $A.createComponent(
            "c:Frontier_Account_AddressInformation",
            {
                accountId : component.get("v.growerAcc").split(',')[0]?component.get("v.growerAcc").split(',')[0]:'',
                accComId: component.get("v.accComId"),
            },
            function(newCmp){
                var cmp = component.find("addrssInfo");
                cmp.set("v.body", newCmp);
            }
        );
    }
		
	
})