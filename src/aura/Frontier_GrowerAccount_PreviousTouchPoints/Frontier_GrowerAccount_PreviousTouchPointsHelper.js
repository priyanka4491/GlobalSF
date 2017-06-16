({
    TouchPointRecord : function(component){
       // var accountID = component.get("v.accId");
        var accountID = '0012C000002MJtn' ;
        var action = component.get("c.getRecentTouchPoints");
        action.setParams({
            "accId" :accountID
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set("v.touchpoints",response.getReturnValue());
            }else if(state === 'ERROR'){
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
    }
});