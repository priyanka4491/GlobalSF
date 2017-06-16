({
    doInit : function(component){
        var today = new Date();
        component.set('v.today', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        var action = component.get("c.getActivityDetail");
        action.setParams({
            "accId" :component.get("v.accId")
        });
        var inputsel = component.find("touchPointType");
        /*Commented by Priyanka S
        var contactSelectList = component.find("contactList");*/
        var reasonSelectList = component.find("touchPointReason");
        var opts=[];
        var contacts = [];
        var reasonval =[];
        var result;
        action.setCallback(this, function(a){
            result = JSON.parse(a.getReturnValue());
            for(var i=0;i< result.Tasktypes.length;i++){
                opts.push({"class": "optionClass", label: result.Tasktypes[i], value: result.Tasktypes[i]});
            }
            console.log('**************'+component.get("v.accId"));
            if(result.contactList.length > 0){
                contacts.push({"class": "optionClass", label: "-- None --", value: "None"});
                for(var j=0;j< result.contactList.length;j++){
                    contacts.push({"class": "optionClass", label: result.contactList[j].Name, value: result.contactList[j].Id});
                }
                /*Commented by priyanka
                 contactSelectList.set("v.options",contacts); */
                }
            else{
                  contacts.push({"class": "optionClass", label: "-- None --", value: "None"});
                /*Commented by priyanka
                  contactSelectList.set("v.options",contacts); */
                }
                for(var k=0;k< result.VisitReason.length;k++){
                    reasonval.push({"class": "optionClass", label: result.VisitReason[k], value: result.VisitReason[k]});
                }
            reasonSelectList.set("v.options",reasonval);
            inputsel.set("v.options",opts);
        });
        $A.enqueueAction(action);
    },
    createRecord : function (component, event, helper){
        var newTouchPoint = component.get("v.newTouchpoint");
        var accountId = component.get("v.accId");
        console.log(accountId);
        console.log('**************'+component.get("v.accId"));
        helper.createTouchRecord(component,newTouchPoint, accountId);
    },
    showModalBox : function(){
        console.log('Page Refresh');
        document.getElementById("backGroundSecId").style.display = "none";
        document.getElementById("newAccountSecId").style.display = "none";
    }
});