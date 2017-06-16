({
	doInit : function(component, event, helper) {
        helper.getProgramEventListHelper(component, event, helper);
	},
    backToTouchpoint : function(component, event, helper){
		helper.redirectToselectedActivity(component, event, helper);
    },
    cancelActivity : function(component, event, helper){
        var  acctDetails = event.getSource().getLocalId(),
            acctId = acctDetails.split(',')[0],
            acctProgramId  = acctDetails.split(',')[3],
            acctProgramActivityId = acctDetails.split(',')[6]; 
        helper.cancelSelectedActivity(component, event, helper, acctId, acctProgramId, acctProgramActivityId);
    },
    completeProgram :function(component, event, helper){
        var cmpEvent = component.getEvent("loadCarosel");
        cmpEvent.setParams({
            "activityCount":component.get("v.activityCount"),
            "isPopup" :true,
            "modalParameters":event.getSource().getLocalId()
        });
        cmpEvent.fire();
        console.log("complete Program");     
    },
    closeModal :function (component, event, helper){
        var model = component.find('addnewActivity');
        $A.util.removeClass(model, 'slds-show');
        $A.util.addClass(model, 'slds-hide');
        var backDrop = component.find('addCancelbackgrnd');
        $A.util.removeClass(backDrop, 'slds-show');
        $A.util.addClass(backDrop, 'slds-hide'); 
    },
    showAddNewActivity:function(component, event, helper){
        var model = component.find('addnewActivity');
        $A.util.removeClass(model, 'slds-hide');
        $A.util.addClass(model, 'slds-show');
        var backDrop = component.find('addCancelbackgrnd');
        $A.util.removeClass(backDrop, 'slds-hide');
        $A.util.addClass(backDrop, 'slds-show'); 
        
        var selectedActivity = component.get("v.selectedAtivityMap");
        var opts = [];
        var previousValue = '', optObj;
        if(selectedActivity){
            for(var i in selectedActivity){
                if(!(selectedActivity[i].Status === 'Not Scheduled') && !(previousValue === selectedActivity[i].Subject)){
                    optObj={class:"",label:"",value:""};
                    optObj.class = "optionClass";
                    optObj.label = selectedActivity[i].Subject;
                    optObj.value = selectedActivity[i].Id;
                    opts.push(optObj); 
                	previousValue = selectedActivity[i].Subject;
                }              
            }
        }
        component.find("addinputSelect").set("v.options", opts);
    },
    copyTask:function(component, event, helper){
        var selectedTaskId = component.find("addinputSelect").get("v.value");
        var action = component.get("c.cloneTask");
        action.setParams({
            taskId : selectedTaskId,   
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var retResponse = response.getReturnValue();
                var clonedTask = JSON.parse(retResponse);
                $('#tableRPA'+component.get("v.PgmListId") +'> tbody:last-child').append('<tr class="tablerow"><td>'+replaceEmptyString(clonedTask.Subject)
                 +'</td><td>'+replaceEmptyString(clonedTask.Status)+'</td><td>'+replaceEmptyString(clonedTask.Phase__c)+'</td></tr>');
                console.log('state' +state);
            }
            
            function replaceEmptyString(value){
                if(!value && value === undefined && value !== 0){
                    return ''; 
                }
                else{
                    return value;
                }
            }
            var model = component.find('addnewActivity');
            $A.util.removeClass(model, 'slds-show');
            $A.util.addClass(model, 'slds-hide');
            var backDrop = component.find('addCancelbackgrnd');
            $A.util.removeClass(backDrop, 'slds-show');
            $A.util.addClass(backDrop, 'slds-hide'); 
        });
        $A.enqueueAction(action);		
        console.log("selectedTaskId" +selectedTaskId);
        
    },
    saveComments : function(component, event, helper){
        var uniqueIds =  event.getSource().getLocalId();
        var actAccId = uniqueIds.split(',')[0];
        var activityId = uniqueIds.split(',')[6];
        var textAreaValue = document.getElementById('textArea'+uniqueIds.split(',')[3]).value;
        console.log("I am in saveComments" + textAreaValue);
        helper.saveActivityComments(component, event, helper, actAccId, activityId, textAreaValue);
    }
})