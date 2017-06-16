({
	doInit : function(component, event, helper) {
        $A.createComponent("c:Frontier_Touchpoint_Planning_Calender",
                           {
                           },
                           function(touchPoint){
                               var comp = component.find("calendarMaster");
                               comp.set("v.body",touchPoint);
                           });		
	},
    handleCompNavigation : function(component, event, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "#/n/Sales_Rep_Touchpoint_Calendar"
        });
        urlEvent.fire();
        var ids = ''+'/'+'0012C00000AsKGzQAN'+','+'a0g2C000000UynxQAC'+'/';
        $A.createComponent("c:Frontier_GrowerAccount_UpdateTouchPoint",
                           {
                               "clickdate":'2017-05-10',
                               "newUpdateStatus":'new',
                               "growerAcc": ids,
                               "isFromCalendar":true,
                               "isReadOnly":false
                           },
                           function(touchPoint){
                               var comp = component.find("calendarMaster");
                               comp.set("v.body",touchPoint);
                           });
    }
})