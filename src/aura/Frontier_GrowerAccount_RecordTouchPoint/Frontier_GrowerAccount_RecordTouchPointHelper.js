({
    createTouchRecord : function(component, touch, accountId){
        console.log("Inside Helper");
        var fieldDate = component.find("date");
        var fieldDateValue = fieldDate.get("v.value");
        console.log(fieldDateValue + "fieldDateValue");
        var validItem;
        if ($A.util.isEmpty(fieldDateValue)){
            validItem = false;
            fieldDate.set("v.errors", [{message:"Value can't be blank."}]);
        }
        else{
            validItem = true;
            fieldDate.set("v.errors", null);
        }
        if(validItem){
            this.upsertTouchPoint(component, touch, accountId, function(a) {
                var touches = component.get("v.touchpoints");
                touches.push(a.getReturnValue());
                if(a.getState() === "SUCCESS"){
                    var message = "visitrecord";
                   /* var comments = component.get("v.comments");
                    console.log(message);
                    console.log('comments' + comments);*/
                    //component.set("v.message" , message);
                    console.log("message" + message);
                    //component.find("notes").set("v.value","");
                    component.find("touchPointType").set("v.value","");
                    component.find("date").set("v.value","");
                    //component.set("v.message", message);
                    var appEvent = $A.get("e.c:Frontier_TouchPointCount");
                    appEvent.setParams({"message" : "" });
                    appEvent.fire();
                    this.showPopUp(component,event,accountId,message);
                }
                component.set("v.touchpoints", touches);
                component.set("v.newTouchpoint",{'sobjectType': 'Event',
                                                 'ActivityDateTime': null,
                                                 'Description': '',
                                                 'Type': 'Call'});
            });
        }
    },
    upsertTouchPoint : function(component, touch, acId, callback){
        // Commented By Priyanka
        var contactId = component.find("contactList").get("v.value");
        //var contactId = 'None';
        //var notes = component.find("notes").get("v.value");
        var touchPointType = component.find("touchPointType").get("v.value");
        var dateVal = component.find("date").get("v.value");
        var action = component.get("c.insertTouchPoint");
       // component.set("v.comments",notes);
        
        action.setParams({
            "notes" : '',
            "touchPointType" :touchPointType,
            "StartDate": dateVal,
            "accuID": acId,
            "contactId" : contactId
        });
        if (callback) {
            action.setCallback(this, callback);
        }
        $A.enqueueAction(action);
    },
  
    showPopUp: function(component,event,accId,message){
        console.log("Inside showPop" + message);
        console.log("Inside showPop" + accId);
        //console.log("Inside showPop" + comments);
        $A.createComponent("c:Frontier_PopUp",
                           {Message : message,
                            accId : accId
                            },
                           function(newComp){
                               console.log('pop');
                               var comp = component.find("visitpopup");
                               comp.set("v.body",newComp);
                           }
                          );    
    }
});