({
	doInit : function(component, event, helper) {
          
	helper.getAllPrograms(component,event,helper);	
	},
    selectedProgram : function(component,event,helper){
        helper.navigateToProgramDetails(component,event,helper);
    }
})