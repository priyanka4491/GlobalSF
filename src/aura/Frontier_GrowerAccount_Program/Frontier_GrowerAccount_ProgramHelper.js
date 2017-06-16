({
    listProgram : function(component,event,helper,page,ispageChange,isInitialize) {
        console.log('Inside list program');
        var triggeredField = null;
        console.log('isInitialize' + isInitialize);
        if(!isInitialize){
              
            if(event.currentTarget && event.currentTarget.id != null){
                console.log("v.SortByField."+event.currentTarget.id);
                triggeredField = component.get("v.SortByField."+event.currentTarget.id);
                //triggeredField = component.get("v.SortByField.ProgramName");
                console.log('Triggered Field get'+ triggeredField);
                component.set("v.triggeredField",triggeredField);
                console.log('Triggered Field'+"v.SortByField."+event.currentTarget.id);
            }
            else if(ispageChange && component.get("v.triggeredField") != ""){
                triggeredField = component.get("v.triggeredField");
            }
        }
        console.log('Inside Program List');
        var action = component.get("c.getProgramList");
        var page = page || 1;
        var pageSize=component.get("v.pageSize");
        console.log('Inside Program List');
        console.log('Page' + page);
        //console.log(eventList + 'eventList');
        var dealerAccount = (component.get("v.growerAcc")).split(',')[0];
        //var dealerAccount = component.get("v.accountId");
        console.log('dealerAccount' + dealerAccount);
        action.setParams({
            accId : dealerAccount,
            //accId : 0012C00000AsKGz,
            pageNumber : page,
            pageSize : component.get("v.pageSize"),
            triggeredField : triggeredField,
            isInitialize : isInitialize,
            isPageChange : ispageChange
        });

        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                console.log('Success');
                var programlist=[];
                component.set("v.page",page);
                console.log('Page after call back' + component.get("v.page"));
                var programlistresponse = response.getReturnValue();
                component.set("v.pages",Math.ceil((JSON.parse(programlistresponse[0]))/component.get("v.pageSize")));
                component.set("v.total",JSON.parse(programlistresponse[0]));
                programlist = JSON.parse(programlistresponse[1]);
                component.set("v.programList" , programlist);
                console.log('programlist' , programlist);
                component.set("v.SortByField", JSON.parse(programlistresponse[2]));
            }
            else if (state === "ERROR"){
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
    },
    navigateToProgramDetail : function(component,event,acctId, acctProgramId) {
        console.log("c:Frontier_GrowerAccount_ProgramEventsList");
        var programId,accountId;
        if(acctId && acctProgramId){
            programId = acctProgramId;
            accountId = acctId;
        }else{
            var uniqueId = event.currentTarget.id;
            programId = (uniqueId.split('/')[0]);
            accountId = (uniqueId.split('/')[1]);
            console.log(programId+accountId);  
        }
        $A.createComponent(
            "c:Frontier_GrowerAccount_ProgramEventsList",
            {
                "growerAcc": component.get("v.growerAcc"),
                programId: programId,
                accountId:accountId
            },
            function(newCmp){
                var cmp = component.find("ProgramDetail");
                //cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );
    },
    cancelPgm : function(component,event,reason){
        //console.log('Inside cancel' +  event.target.id);
        var pgmAccId = component.get("v.programId");
        console.log('pgmAcc' + pgmAccId);
        //var programId = (pgmAccId.split('/')[0]);
        //var accId = (pgmAccId.split('/')[1]);
        var accPgmId = (pgmAccId.split('/')[0]);
        var status = (pgmAccId.split('/')[1]);
        console.log( accPgmId + ' ' + status + ' ' + reason);
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
               
            }
            else if (state === "ERROR"){
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
    },
    navigateToProfileDetails :function(component,event) {	
        var growerAccDetail = component.get("v.growerAcc");
        var growerAccId = growerAccDetail.split(',')[0];  
        var groweraccCommId = growerAccDetail.split(',')[2];
        if(component.get("v.role") === 'Partner'){
            $A.createComponent("c:Frontier_DealerDetail_Profile",
                               {
                                   "dealerId" : growerAccId,
                                   "accCommId": groweraccCommId,
                                   "isProgramView": true
                               },
                               function(newCmp){
                                   //Render the sales order dashboard component to the parent container
                                   var cmp = component.find("profileDetails");
                                   cmp.set("v.body", newCmp);
                               }
                              );
        }else{
            
            $A.createComponent(
                "c:Frontier_GrowerProfileDetails",
                {
                    "GrowerDetailResponse": '',
                    "growerId":growerAccId,
                    "accCommId":groweraccCommId,
                    "isProgramView": true
                },
                function(newCmp){
                    //Render the sales order dashboard component to the parent container
                    var cmp = component.find("profileDetails");
                    cmp.set("v.body", newCmp);
                }
            );
            
        }
    },
    showPopUpAllow: function(component,event,message){
        console.log("Inside showPop" + message);
        
        $A.createComponent("c:Frontier_PopUp",
                           {Message : message
                           },
                           function(newComp){
                               console.log('pop');
                               var comp = component.find("allowpop");
                               comp.set("v.body",newComp);
                           });
    },
    
    showPopUpntAllow: function(component,event,message){
        console.log("Inside showPop" + message);
        
        $A.createComponent("c:Frontier_PopUp",
                           {Message : message
                           },
                           function(newComp){
                               console.log('pop');
                               var comp = component.find("notallowpop");
                               comp.set("v.body",newComp);
                           });
    }
})