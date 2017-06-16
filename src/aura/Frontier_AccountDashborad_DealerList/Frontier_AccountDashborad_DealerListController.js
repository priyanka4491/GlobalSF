({
    doInit : function(component, event, helper) {
        var page = component.get("v.page") || 1;
        helper.getdealerdetails(component,event,helper,page)	
    },
    PageChange: function(component,event,helper) {
        var cmpName = event.getParam("compName");
        if(cmpName == 'DealerDashboardList'){
            var page = component.get("v.page") || 1;
            var direction = event.getParam("direction");
            page = direction === "previous" ? (page - 1) : (page + 1);
            helper.getdealerdetails(component,event,helper,page);
        }
    },
     visitSelectChange : function(component,event,helper){
       var page = component.get("v.page") || 1;  
       helper.getdealerdetails(component,event,helper,page); 
    }
})