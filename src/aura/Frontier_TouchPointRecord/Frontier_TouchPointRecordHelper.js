({
    createTouchRecord : function(component, touch, accountId) {
        var validItem = true;
        var fieldDate = component.find("date");
        var fieldDateValue = fieldDate.get("v.value");
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
        else {
            fieldDate.set("v.errors", null);
        }
        if(validItem && validFollowUp){
            this.upsertTouchPoint(component, touch, accountId, function(a) {
                var touches = component.get("v.touchpoints");
                touches.push(a.getReturnValue());
                if(a.getState() === "SUCCESS"){
                    document.getElementById("backGroundId").style.display = "block";
                    document.getElementById("newAccountId").style.display = "block";
                }
                component.find("followupdate").set("v.value","");
                component.set("v.touchpoints", touches);
                component.set("v.newTouchpoint",{'sobjectType': 'Event',
                                                 'ActivityDateTime': null,
                                                 'Description': '',
                                                 'Type': 'Call',
                                                 'Subject' : ''});
            });
        }
    },
    upsertTouchPoint : function(component, touch, acId, callback) {
        /* Commented By Priyanka
         var contactId = component.find("contactList").get("v.value"); */
       var contactId = 'None';
        var notes = component.find("notes").get("v.value");
        var touchPointType = component.find("touchPointType").get("v.value");
        var touchPointReason = component.find("touchPointReason").get("v.value");
        var dateVal = component.find("date").get("v.value");
        var followDate1 = component.find("followupdate").get("v.value");;
        console.log("followDate" + followDate1);
         if(followDate1 == ''){
             console.log("Inside null");
             bfollowDate1 = null;
        }
        var action = component.get("c.insertTouchPoint");
        action.setParams({
            "notes" :notes,
            "touchPointType" :touchPointType,
            "touchPointReason" : touchPointReason,
            "StartDate": dateVal,
            "recordType" : 'Event Touch Point',
            "accuID": acId,
            "contactId" : contactId,
            "dueDate" : followDate1
        });
        if (callback) {
            action.setCallback(this, callback);
        }
        $A.enqueueAction(action);
    }
});