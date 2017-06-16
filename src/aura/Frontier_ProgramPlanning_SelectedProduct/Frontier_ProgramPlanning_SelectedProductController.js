({
	doInit : function(component, event, helper) {
		var appEvent = $A.get("e.c:Frontier_ProgramPlanningSelectProduct");
        var selectProduct = component.get("v.selectedProducts");
        console.log("Selected" +selectProduct);        
        appEvent.setParams({"selectedProducts" : selectProduct});
		    appEvent.fire();
            

	}
})