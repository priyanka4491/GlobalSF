({
	doInit : function(component, event, helper) {
        console.log('Inside dealer chart');
        helper.dealerSalesDetails(component,event,helper);
		
	},
    changeUnits : function(component,event,helper){
      helper.dealerSalesDetails(component,event,helper);  
    }
})