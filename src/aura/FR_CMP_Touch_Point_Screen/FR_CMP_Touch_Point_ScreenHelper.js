({
    createTouchRecord : function(component, touch, accountId){
        console.log("Inside create touch");
        var fieldDate = component.find("date");
        var fieldDateValue = fieldDate.get("v.value");
        var validItem;
        var validFollowUp;
        var followUpDate = component.find("followupdate");
        var startDateTime = new Date(followUpDate.get("v.value"));
        startDateTime.setDate(startDateTime.getDate() + 1);
        var endDateTime = new Date();
        if( $A.localizationService.isBefore(startDateTime,endDateTime) && startDateTime != endDateTime) {
            followUpDate.set("v.errors", [{message:"Follow up date must be future date"}]);
            validFollowUp = false;
            console.log('Timezone based Error'+startDateTime+'End date'+endDateTime);
        }
        else{
            validFollowUp = true;
            followUpDate.set("v.errors", null);
        }
       if ($A.util.isEmpty(fieldDateValue)){
            validItem = false;
            fieldDate.set("v.errors", [{message:"Value can't be blank."}]);
        }
        else{
            validItem = true;
            fieldDate.set("v.errors", null);
        }
        if(validItem && validFollowUp){
            this.upsertTouchPoint(component, touch, accountId, function(a) {
                var touches = component.get("v.touchpoints");
                touches.push(a.getReturnValue());
                if(a.getState() === "SUCCESS"){
                    var message = "visitrecord";
                    console.log(message);
                    console.log("message" + message);
                    component.find("notes").set("v.value","");
                    component.find("touchPointType").set("v.value","");
                    component.find("date").set("v.value","");
                    component.find("followupdate").set("v.value","");
                    var appEvent = $A.get("e.c:Frontier_TouchPointCount");
                    appEvent.setParams({"message" : "" });
                    appEvent.fire();
                    this.showPopUp(component,event,accountId,message);
                }
                component.set("v.touchpoints", touches);
                component.set("v.newTouchpoint",{'sobjectType': 'Event',
                                                 'ActivityDateTime': null,
                                                 'Description': '',
                                                 'Type': 'Call',
                                                 'Subject' : ''});
            });
        }
    },
    upsertTouchPoint : function(component, touch, acId, callback){
        /* Commented By Priyanka
        var contactId = component.find("contactList").get("v.value");*/
        var contactId = 'None';
        var notes = component.find("notes").get("v.value");
        var touchPointType = component.find("touchPointType").get("v.value");
        var touchPointReason = component.find("touchPointReason").get("v.value");
        var dateVal = component.find("date").get("v.value");
        var followDate1 = component.find("followupdate").get("v.value");
        console.log("followDate" + followDate1);
        if(followDate1 == ''){
            console.log("Inside null");
            followDate1 = null;
        }
        var action = component.get("c.insertTouchPoint");
        console.log("touchPointReason" + touchPointReason);
        action.setParams({
            "notes" :notes,
            "touchPointType" :touchPointType,
            "touchPointReason" : touchPointReason,
            "recordType" : 'Event Touch Point',
            "StartDate": dateVal,
            "accuID": acId,
            "contactId" : contactId,
            "dueDate" : followDate1
        });
        if (callback) {
            action.setCallback(this, callback);
        }
        $A.enqueueAction(action);
    },
    showPopUp: function(component,event,accId,message){
        console.log("Inside showPop" + message);
        console.log("Inside showPop" + accId);
        $A.createComponent("c:Frontier_PopUp",
                           {Message : message,
                            accId : accId},
                           function(newComp){
                               console.log('pop');
                               var comp = component.find("visitpopup");
                               comp.set("v.body",newComp);
                           });
    }
});