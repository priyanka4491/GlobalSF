({
	doInit : function(component, event, helper) {
    var page = component.get("v.page") || 1;
	helper.programList(component,event,helper,page);	
	},
    pageChange: function(component,event,helper) {
        var cmpName = event.getParam("compName");
        console.log('cmpName' + cmpName);
        if(cmpName == 'AllDealerProgramsList'){
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        
        helper.programList(component,event,helper,page);
        }
    },
    programNavigation : function(component,event,helper){
        var myEvent = $A.get("e.c:Frontier_SelectedProgramEvent");
        var programId = event.target.id;
        myEvent.setParams({
            "programId": programId
            
        });
        console.log("progId" + event.target.value);
        myEvent.fire();
    
    }
})