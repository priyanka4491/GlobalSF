({
	doInit : function(component, event, helper) {
        console.log('Inside Do Init');
    var page = component.get("v.page") || 1;
	helper.programList(component,event,helper,page);	
	},
    pageChange: function(component,event,helper) {
        var cmpName = event.getParam("compName");
        console.log('cmpName' + cmpName);
        if(cmpName == 'ProgramsList'){
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        
        helper.programList(component,event,helper,page);
        }
    },
    programNavigation : function(component,event,helper){
        var myEvent = $A.get("e.c:Frontier_SelectedProgramEvent");
        var evt = event.currentTarget.id;
        console.log('evt'+evt);
        myEvent.setParams({
            "programId": evt.split(',')[0],
            "dealerId":	evt.split(',')[1],
            "accountTarget": evt.split(',')[2]
        });
        console.log("progId" + evt);
        myEvent.fire();
    
    }
})