({
    doInit : function(component, event, helper) {
        var productID = component.get("v.childProductId");
        var page = component.get("v.page") || 1;
        console.log("checking"+productID);
        helper.getsObjectRecords(component,page, productID);
    },
    pageChange: function(component, event, helper) {
        var page = component.get("v.page") || 1;
        var productID = component.get("v.childProductId");
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        helper.getsObjectRecords(component,page, productID);
    },
    navigatetoAccount: function(component, event){
        console.log("Hello=>"+event.target.id);
        var accId = event.target.id;
        var cmpEvent = component.getEvent("AccountNavigationEvent");
        cmpEvent.setParams({"accId" :  accId.split(',')[0],"sapId" :accId.split(',')[1]});
        cmpEvent.fire();
        console.log("Finished");
    }
});