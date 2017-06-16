({
    loadCalender : function(component, event, helper) { 
        helper.loadCalendarData(component, event, helper);
    },
    openTouchPoint : function(component, event){
    },
    showSpinner : function (component) {
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, "xc-hidden");
    },
    hideSpinner : function (component) {
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, "xc-hidden");
    },
    handleRedirectToCalendar :function(component, event){
        if(event.getParam("handlerName") && event.getParam("handlerName") === 'calendar'){
            $A.createComponent("c:Frontier_Touchpoint_Planning_Calender",
                               {
                               },
                               function(touchPoint){
                                   var comp = component.find("calenderBody");
                                   comp.set("v.body",touchPoint);
                               });
        }
    }
})