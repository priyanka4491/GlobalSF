({
    doInit : function(component){
        /*var today = new Date();
        component.set('v.today', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        var action = component.get("c.getActivityDetail");
        action.setParams({
            // Commented to hardcode account id
            //"accId" :component.get("v.accId")
            "accId" : '0012C000002MJtn'
        });
        var inputsel = component.find("touchPointType");
        //Commented by Priyanka S
        var contactSelectList = component.find("contactList");
        var opts=[];
        var contacts = [];
        var result;
        action.setCallback(this, function(a){
            result = JSON.parse(a.getReturnValue());
            for(var i=0;i< result.Tasktypes.length;i++){
                opts.push({"class": "optionClass", label: result.Tasktypes[i], value: result.Tasktypes[i]});
            }
            //console.log('**************'+component.get("v.accId"));
            if(result.contactList.length > 0){
                contacts.push({"class": "optionClass", label: "-- None --", value: "None"});
                for(var i=0;i< result.contactList.length;i++){
                    contacts.push({"class": "optionClass", label: result.contactList[i].Name, value: result.contactList[i].Id});
                }
                 contactSelectList.set("v.options",contacts);
                }
            else{
                  contacts.push({"class": "optionClass", label: "-- None --", value: "None"});               
                 contactSelectList.set("v.options",contacts);
                }
            inputsel.set("v.options",opts);
        });
        $A.enqueueAction(action);*/
    },
   createRecord : function (component, event, helper){
      /*  var newTouchPoint = component.get("v.newTouchpoint");
       // commented to hardcode account id
        //var accountId = component.get("v.accId");
        var accountId = '0012C000002MJtn';
        console.log(accountId);
        helper.createTouchRecord(component,newTouchPoint, accountId);*/
    }, 
    showModalBox : function(component, event, helper){
       /* event.preventDefault();
        console.log('Page Refresh');
        document.getElementById("backGroundSecId").style.display = "none";
        document.getElementById("newAccountSecId").style.display = "none";*/
    } ,
    seasonKeyChange : function(component, event, helper){
        var seasonKey = event.getParam("seasonKey");
        component.set("v.seasonDetail",seasonKey);
        console.log('Record Touch Point Season' + seasonKey);
    }
});