({
    doInit : function(cmp, event,helper){
        helper.getAccounts(cmp, event);
    },
    showModal : function(){
        document.getElementById("backGroundSectionId").style.display = "block";
        document.getElementById("newAccountSectionId").style.display = "block";
        var appEvent = $A.get("e.c:Frontier_ActivityRefresh");
        appEvent.fire();
    },
    handleTouchPoints:function(cmp,event,helper){
        helper.getAccounts(cmp,event);
    }
});