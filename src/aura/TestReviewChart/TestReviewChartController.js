({
	doInit : function(component, event, helper) {
        var page = component.get("v.page") || 1;
		helper.getAllProgram(component,event,helper, page); 
	},
    pageChange: function(component,event,helper) {
        var page;
        var direction;
        page = component.get("v.page") || 1;
        direction = event.getParam("direction");
        
        page = direction === "previous" ? (page - 1) : (page + 1);
        console.log('page---' +page);
        helper.getAllProgram(component,event,helper,page);
         
    }
})