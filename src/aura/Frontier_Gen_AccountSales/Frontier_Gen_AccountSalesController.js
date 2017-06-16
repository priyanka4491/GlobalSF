({
	doInit : function(component, event, helper) {
		helper.getAccountSales(component, event, helper, true);		
	},
    callupdateCYTarget : function(component, event, helper){
    	helper.updateCYTarget(component, event, helper);
	}
})