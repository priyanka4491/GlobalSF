({
    programListHelper : function(component,event,page,isPageChange,isInitialize) {
        var programId = component.get("v.programId");
        
        var accId =component.get("v.accountId");
        var action = component.get("c.getPgmAccounts");
        console.log('Program Id' + programId);
        var triggeredField = null;
        if(!isInitialize){
            if(event.currentTarget && event.currentTarget.id != null){
                console.log('Inside Helper Target' + event.currentTarget.id);
                var sortfield=component.get("v.SortByField." + event.currentTarget.id);
                console.log('&&&&&&&&&&&&&'+sortfield);
                triggeredField = component.get("v.SortByField."+event.currentTarget.id);
                // triggeredField =event.currentTarget.id;
                component.set("v.triggeredField",sortfield);
                console.log('Triggered Field'+triggeredField);
            }
            else if(isPageChange && component.get("v.triggeredField") != ""){
                triggeredField = component.get("v.triggeredField");
            }
        }
        console.log(programId+component.get("v.pageSize")+page+triggeredField+isInitialize+isPageChange);
        action.setParams({
            programId : programId,
            pageSize : component.get("v.pageSize"),
            pageNumber : page,
            triggeredField : triggeredField,
            isInitialize : isInitialize,
            isPageChange : isPageChange
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var programEventlist = [];
                var accountList = [];
                component.set("v.page",page);
                var retResponse = response.getReturnValue();
                console.log("retResponse"+ retResponse);
                component.set("v.total",JSON.parse(retResponse[0]));
                component.set("v.pages",Math.ceil((JSON.parse(retResponse[0]))/component.get("v.pageSize")));
                programEventlist = JSON.parse(retResponse[1]);
                accountList = JSON.parse(retResponse[2]);
                component.set("v.accountProgramList", programEventlist);
                component.set("v.accountList",accountList);
                component.set("v.SortByField", JSON.parse(retResponse[3]));
                component.set("v.accountProductList", JSON.parse(retResponse[4]));

            }else if (state === "ERROR"){
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
    },    
    cancelPgm : function(component,event,reason){
        var pgmAccId = component.get("v.cancelUniqueId");
        console.log('pgmAcc' + pgmAccId);
        //var programId = (pgmAccId.split('/')[0]);
        //var accId = (pgmAccId.split('/')[1]);
        var accPgmId = (pgmAccId.split('/')[0]);
        var status = (pgmAccId.split('/')[1]);
        console.log( accPgmId + ' ' + status);
        var action = component.get("c.getCancelPgm");
        
        action.setParams({
            status : status,
            accPgmId : accPgmId,
            reason : reason
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                console.log('Success');
           var comp = 'AllDealers';
            var myEvent = $A.get("e.c:Frontier_RefreshProgramChart");
            myEvent.setParams({ "compName":comp });
            myEvent.fire();
            }
            else if(state === 'ERROR'){
                console.log('Error');
            }
            
        });
       $A.enqueueAction(action); 
    },
    completePgm : function(component,event){
        console.log('Inside complete');
        var pgmAccId = event.currentTarget.id;
        console.log('pgmAcc' + pgmAccId);
        //var programId = (pgmAccId.split('/')[0]);
        //var accId = (pgmAccId.split('/')[1]);
        var accPgmId = (pgmAccId.split('/')[0]);
        var status = (pgmAccId.split('/')[1]);
        console.log( accPgmId + ' ' + status);
        var action = component.get("c.getCompletePgm");
        action.setParams({
            status : status,
            accPgmId : accPgmId
        });
       action.setCallback(this,function(response){
            var state = response.getState();
           var message;
            if(state === 'SUCCESS'){
                console.log('Success');
                
                var popUpFlag = response.getReturnValue();
                console.log('popUpFlag' + popUpFlag);
                if(popUpFlag=='Allow'){
                   message='Program Completed'; 
                     this.showPopUpAllow(component,event,message); 
                }
                if(popUpFlag=='Not Allow'){
                   message='Program Not Completed'; 
                    this.showPopUpntAllow(component,event,message);
                }
             var comp = 'AllDealers';
            var myEvent = $A.get("e.c:Frontier_RefreshProgramChart");
            myEvent.setParams({ "compName":comp });
            myEvent.fire();
            
               
            }
            else if (state === "ERROR"){
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
    },
    cancelSelectedActivity : function(component,event){
        //var uniqueId = event.currentTarget.id;
        var taskId = event.currentTarget.id;
        var accountId = component.get("v.accountId");
        var programId = component.get("v.programId");
        
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
    navigateToActivityDetail : function(component, event, helper){
        var handlerName,roleDesc,accId,pgmId,accComId,myprogramDetails;
        if(event.target.id){
            handlerName = event.target.id.split(',')[0];
            roleDesc = event.target.id.split(',')[1];
            accId = event.target.id.split(',')[2];
            pgmId = event.target.id.split(',')[3];
            accComId = event.target.id.split(',')[4];
        }
        if(roleDesc){
            if(roleDesc === 'Partner'){
                myprogramDetails = handlerName+'-'+roleDesc+'-'+accId+'-'+pgmId+'-'+accComId;
                var url = '/one/one.app#/n/Dealer_List?myprogramDetails='+myprogramDetails;
                var viewRecord = document.getElementById(event.target.id);
                viewRecord.setAttribute("href", url);                  
            }
            if(roleDesc === 'Customer'){
                myprogramDetails = handlerName+'-'+roleDesc+'-'+accId+'-'+pgmId+'-'+accComId;
                var url = '/one/one.app#/n/Grower_List?myprogramDetails='+myprogramDetails;
                var viewRecord = document.getElementById(event.target.id);
                viewRecord.setAttribute("href", url);                  
            }
        } 
    }
    
})