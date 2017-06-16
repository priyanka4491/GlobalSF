({
    listProgram : function(component,event,helper,page,ispageChange,isInitialize) {
        console.log('Inside list program');
        var triggeredField = null;
      
        if(!isInitialize){
              console.log('event.target.id' + event.currentTarget.id);
            if(event.target && event.currentTarget.id != null){
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
        var action = component.get("c.getProgramList");
        var page = page || 1;
        var pageSize=component.get("v.pageSize");
        //console.log(eventList + 'eventList');
        var dealerAccount = (component.get("v.growerAcc")).split(',')[0];
        console.log('dealerAccount' + dealerAccount);
        action.setParams({
            accId : dealerAccount,
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
    navigateToProgramDetail : function(component,event) {
        console.log("c:Frontier_GrowerAccount_ProgramEventsList");
        var uniqueId = event.currentTarget.id;
        var programId = (uniqueId.split('/')[0]);
        var accountId = (uniqueId.split('/')[1]);
        console.log(programId+accountId);
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
        var pgmAccId = component.get("v.programId");
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
            }
            else if(state === 'ERROR'){
                console.log('Error');
            }
            
        });
       $A.enqueueAction(action); 
    },
    navigateToProfileDetails :function(component,event) {	
		var action = component.get("c.getProgramProfileDetails");
        var growerAccDetail = component.get("v.growerAcc");
        var growerAccId = growerAccDetail.split(',')[0];  
        var groweraccCommId = growerAccDetail.split(',')[2];
        if(component.get("v.role") === 'Partner'){
                  $A.createComponent("c:Frontier_DealerDetail_Profile",
                    {
                        "dealerId" : growerAccId,
                        "accCommId": groweraccCommId
                    },
                    function(newCmp){
                        //Render the sales order dashboard component to the parent container
                        var cmp = component.find("profileDetails");
                        cmp.set("v.body", newCmp);
                    }
                );
        }
        else{
            action.setCallback(this,function(response){
                var state = response.getState();
                if (state === "SUCCESS" && !(response.getReturnValue() === 'CalloutError')){
                    //component.set("v.GrowerDetails" ,response.getReturnValue());
                    $A.createComponent(
                        "c:Frontier_GrowerProfileDetails",
                        {
                            "GrowerDetailResponse": response.getReturnValue(),
                            "growerId":growerAccId,
                            "accCommId":groweraccCommId
                        },
                        function(newCmp){
                            //Render the sales order dashboard component to the parent container
                            var cmp = component.find("profileDetails");
                            cmp.set("v.body", newCmp);
                        }
                    );
                }
            });
            $A.enqueueAction(action);  
        }
    }
})