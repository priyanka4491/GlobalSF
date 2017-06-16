({
    doInit : function(component,event,helper){
        helper.TouchPointRecord(component);
    },
    handleTouchPoints : function(component,event,helper){
        helper.TouchPointRecord(component);
    },
   /* showModal : function(){
        document.getElementById("backGroundSectionId").style.display = "block";
        document.getElementById("newAccountSectionId").style.display = "block";
        var appEvent = $A.get("e.c:Frontier_ActivityRefresh");
        appEvent.fire();
     }*/
});