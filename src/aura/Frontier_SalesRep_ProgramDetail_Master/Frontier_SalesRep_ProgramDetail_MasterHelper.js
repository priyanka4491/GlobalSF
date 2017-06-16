({
	programEventListHelper : function(component,event,page,isPageChange,isInitialize) {
        var programId = component.get("v.programId");
        var accId =component.get("v.accountId");
        var action = component.get("c.getMyProgramAccounts");
        var groweAcc = component.get("v.growerAcc");
        if(groweAcc == 'undefined' || groweAcc=='' || groweAcc==null){
            groweAcc = null;
        }
        console.log('groweAcc' + groweAcc);
        console.log('Program Id' + programId);
        var triggeredField = null;
        if(!isInitialize){
            if(event.currentTarget && event.currentTarget.id != null){
                console.log('Inside Helper Target' + event.currentTarget.id);
                var sortfield=component.get("v.SortByField." +event.currentTarget.id);
                console.log('Sort Field'+sortfield);
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
                pageSize : component.get("v.pageSize"),
                pageNumber : page,
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
                    component.set("v.total",JSON.parse(retResponse[0]));
                    component.set("v.pages",Math.ceil((JSON.parse(retResponse[0]))/component.get("v.pageSize")));
                    programEventlist = JSON.parse(retResponse[1]);
                   
                    component.set("v.accountProgramList", programEventlist);
                    component.set("v.SortByField", JSON.parse(retResponse[2]));
                    
                }else if (state === "ERROR"){
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
    
    navigateToUpdateTouchPointDetail : function(component,event) {
        console.log("c:Frontier_GrowerAccount_UpdateTouchPoint");
        var currentDateId = event.currentTarget.id;
        var accId =component.get("v.accountId");
        var programId =component.get("v.programId");
        console.log('currentDateId' + currentDateId);
        $A.createComponent(
            "c:Frontier_GrowerAccount_UpdateTouchPoint",
            {
                currentDateId: currentDateId,
                accountId:accId,
                newUpdateStatus:'update',
                programId:programId
            },
            function(newCmp){
                var cmp = component.find("AccountDetail");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );
},
	getAllPrograms : function(component,event,helper) {
         var programId =component.get("v.programId");
        var dealerId;
        var isMyProgram;
        console.log('programId' +programId);
        var dealerId = component.get("v.growerAcc");
        console.log('dealerId' +dealerId);
       if(dealerId != null){
            
            isMyProgram = 'false';
           component.set("v.dealerId",dealerId);
           console.log('dealerId' +dealerId + isMyProgram);
        }
        
         if(dealerId == 'undefined' || dealerId =='' || dealerId == null){
            dealerId = null;
            isMyProgram = 'true';
        }
        var isAllDealer = 'false';
		 var action = component.get("c.getMyProgramsChart");	
        
          action.setParams({
			programId : programId,
            dealerId:dealerId,
            isAllDealer:isAllDealer,
            isMyProgram:isMyProgram
              
        });
     action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var retResponse = (JSON.parse(response.getReturnValue()));
                    console.log("retResponse"+ JSON.stringify(retResponse));                    
                    component.set("v.programList", retResponse);
                    component.set("v.loadchart1" , true);
                    component.set("v.loadchart2" , true);
                    component.set("v.loadchart3" , true);
                    component.set("v.loadchart4" , true);
                   // var inputsel = component.find("sellingSeason");
      var cropsel = component.find("cropDetails");
        var opts=[];
        var crops=[];
                     for(var i=0;i< retResponse.sellingSeasontypes.length;i++){
                opts.push({"class": "optionClass", label: retResponse.sellingSeasontypes[i], value:retResponse.sellingSeasontypes[i]});
            }
                for(var i=0;i< retResponse.croptypes.length;i++){
                crops.push({"class": "optionClass", label: retResponse.croptypes[i], value:retResponse.croptypes[i]});
            }
            // inputsel.set("v.options",opts); 
              cropsel.set("v.options",crops);
                
                     var Acquire = retResponse.acquirecount;
                var Develop = retResponse.developcount;
                var LightTouch = retResponse.ltcount;
                var Retain = retResponse.retaincount;
               console.log('Acquire' + Acquire + 'Develop' + Develop + 'LightTouch' +LightTouch +'Retain'+Retain);
                     $A.createComponent(
            "c:Frontier_ProgramPlanning_Radl",
            {
                acqcount:Acquire,
                dcount :Develop,
                lcount :LightTouch,
                rcount :Retain
            },
            function(newCmp){
                var cmp = component.find("radlDiv1");
                //cmp.set("v.body", []);
                cmp.set("v.body", newCmp);	
            }
        );   
                }else if (state === "ERROR"){
                    console.log('Error');
                }
            });
            $A.enqueueAction(action);
},
    getSeason : function(component, event, helpe) {
        var seasonVal = '2017 Safra';    
        var selectedSeason = component.find("selectedSeason").get("v.value");
        if(selectedSeason != null)
        {
        	seasonVal = selectedSeason;
        }
        console.log('Inside Grower Profile');        
        var selectedGrower = component.get("v.growerId");
	    var action = component.get("c.getSeasonData");
        action.setParams({
			season :seasonVal            
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
             var seasonDetailsJson = JSON.parse(response.getReturnValue());
             console.log('growerAccountDetailJson' + seasonDetailsJson);
			 console.log('growerAccountDetailJson.growerSeason' + seasonDetailsJson.growerSeason);
             component.set("v.seasonList",seasonDetailsJson);
             console.log('seasonDetailsJson.growerSeason' + seasonDetailsJson.growerSeason);

               //this.getSeasonDetails(component,event,helper);
            } else if (response.getState() === "ERROR") {
                $A.log("Errors", response.getError());
                console.log("Errors", response.getError());
            }
        });
                           
       $A.enqueueAction(action);                    
	}
})