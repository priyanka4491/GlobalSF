({
    doInit : function(component, event, helper)
    {         
        var message = component.get("v.Message");
        console.log("message init" + message);
        if(message != null && message =="visitrecord"){
            component.set("v.Message", "Visit Recorded"); 
        }  
        else if(message != null && message =="followuprecord")
            component.set("v.Message", "Follow-Up Scheduled"); 
        else if(message != null && message =="E-Mail has been sent")
            component.set("v.Message", "E-Mail has been sent");
        else if(message != null && message =="Program Completed")
            component.set("v.Message", "Program is successfully completed");
        else if(message != null && message =="Program Not Completed")
            component.set("v.Message", "Program cannot be completed since related activities are not in completed  status");
    },
    showModalBox : function(component, event, helper){
        event.preventDefault();
        console.log('Page Refresh123');       
        
        $A.util.addClass(component.find("backGroundSecId1"), 'slds-hide'); 
        $A.util.addClass(component.find("newAccountSecId1"), 'slds-hide');
       
        
        if(component.get("v.Message") == "Program is successfully completed"){
            var popEvent = $A.get("e.c:Frontier_RefreshProgram");
        //popEvent.setParams({"searchKey": event.target.value});
        console.log("ist event value" );
        popEvent.fire();
        }
        //document.getElementById("backGroundSecId1").style.display = "none";
       // document.getElementById("newAccountSecId1").style.display = "none";
    },
    hideModalBox : function(component, event, helper){
        event.preventDefault();
        console.log('hideModalBox');       
        
        $A.util.addClass(component.find("backGroundSecId1"), 'slds-hide'); 
        $A.util.addClass(component.find("newAccountSecId1"), 'slds-hide');
        console.log('&&&&&&&Hide=='+component.get("v.ComponentName"));
        var compName = component.get("v.ComponentName");
        if(compName == 'Frontier_Pgm_Plang_Review'){ 
            console.log('Event Fired above========');
                        var popUpEvent = $A.get("e.c:Frontier_PopUpCloseEvent");
						popUpEvent.fire();
            console.log('Event Fired below========');
        }
        
        
        else if(component.get("v.Message") == "Program is successfully completed"){
            var popEvent = $A.get("e.c:Frontier_RefreshProgram");
        //popEvent.setParams({"searchKey": event.target.value});
        console.log("ist event value" );
        popEvent.fire();
        }
        //document.getElementById("backGroundSecId1").style.display = "none";
       // document.getElementById("newAccountSecId1").style.display = "none";
    }
})