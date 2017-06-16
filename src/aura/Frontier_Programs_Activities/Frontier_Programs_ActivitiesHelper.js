({
	getProgramEventListHelper : function(component, event,helper) {       
        var acctDetails = component.get("v.growerAcc"),
            acctId = acctDetails.split(',')[0],
            acctProgramId  = acctDetails.split(',')[3],
            acctProgramActivityId = acctDetails.split(',')[4];
        
          component.set("v.selectedProgramId",acctProgramId);       
        
        var action = component.get("c.getProgramsTasksByTask");
        //
        action.setParams({
            acctId : acctId,  
            programId : acctProgramId,
            taskId : acctProgramActivityId    
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var programEventlist = [];
                var retResponse = response.getReturnValue();
                programEventlist = JSON.parse(retResponse);
                console.log("json stringfiy:::" + JSON.stringify(retResponse));
                component.set("v.programEventList", programEventlist);
                component.set("v.programList",programEventlist.accountProgramList);
                component.set("v.programIdActivityMap",programEventlist.activityMap);
                var aMap = component.get("v.programIdActivityMap");
                var listofPrograms = Object.keys(aMap).map(
                    function(key){
                        return{
                            key: key,
                            value : aMap[key]
                        }
                    });
                component.set("v.selectedAtivityMap",listofPrograms);
                //component.set("v.selectedTaskName",programEventlist.selectedName);
                console.log("v.programEventList from PA" + programEventlist);                              
            }
            else if(state === "ERROR"){
                console.log('Error');
            }
        });
        $A.enqueueAction(action);		
	},
    updatePgmStatus : function(component, event,helper,reason){
		var PgmId = component.get("v.modelProgramId");
        var pgmList = component.get("v.programList");
        var accPgmId;
        
        for(var i in pgmList){
            if(pgmList[i].Program__c === PgmId) {
                accPgmId = pgmList[i].Id;
                break;
            }
        }
       	var status = component.get("v.modelProgramStatus");
        if(component.get("v.popupName") === 'Complete Program'){
            status = 'Completed';
        }
        if(component.get("v.popupName") === 'Cancel Program'){
            status = 'Cancelled'
        }
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
                var updatedStatus  = document.getElementById('pgmStatus'+component.get("v.modelProgramId"));
                updatedStatus.innerHTML = ((component.get("v.popupName") === 'Complete Program')?'Completed':'Cancelled');
                if((component.get("v.popupName") === 'Complete Program') || (component.get("v.popupName") === 'Cancel Program')){
                    var comElem =  $('#parentcompleteProgramlink' + component.get("v.modelProgramId"));
                    var cancelElem = $('#parentcancelProgramlink' + component.get("v.modelProgramId"));
                    comElem.css("display","none");
                    comElem.next().css("display","none");
                    cancelElem.css("display","none");
                }
                console.log('Success');
            }
            else if(state === 'ERROR'){
                console.log('Error');
            }
            
        });
        $A.enqueueAction(action); 
    }
})