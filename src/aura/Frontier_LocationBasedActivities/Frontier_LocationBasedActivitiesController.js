({
    doinit : function(component, event, helper) {
        if(navigator.geolocation){
            navigator.geolocation.getCurrentPosition(function(position){ 
                console.log(position.coords.longitude);
                component.set("v.comLat",position.coords.latitude);
                component.set("v.comLong",position.coords.longitude);
            });	
        }
    },
    handleValueChange : function(component, event, helper) {
	    helper.getTasks(component);
    },
    toggleCard : function(component, event, helper){
         if(navigator.geolocation){
            navigator.geolocation.getCurrentPosition(function(position){ 
                console.log(position.coords.longitude);
                component.set("v.comLat",position.coords.latitude);
                component.set("v.comLong",position.coords.longitude);
            });	
        }
        var targetObject = component.find("geoCard");
        $A.util.removeClass(targetObject,"slds-hide");
        $A.util.addClass(targetObject,"slds-show");
        helper.getTasks(component);
    }
})