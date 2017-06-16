({
    doInit : function(component, event, helper) {
        helper.getAccountDetailResponse(component,event);
        var formFactor = $A.get("$Browser.formFactor");
        var accountGrid = component.find("accountGrid");
        if(formFactor === 'PHONE'){
            $A.util.addClass(accountGrid, 'slds-wrap');
            $A.util.removeClass(component.find("touchPoint"), 'slds-p-horizontal--small');
            $A.util.removeClass(component.find("recentTouchPoint"), 'slds-p-horizontal--small');
        }
        else {
            $A.util.removeClass(accountGrid, 'slds-wrap');
        }
    }
});