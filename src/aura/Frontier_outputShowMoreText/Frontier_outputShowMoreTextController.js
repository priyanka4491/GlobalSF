({
	doInit : function(component, event, helper) {
		component.set("v.containerId", component.get("v.containerId"))
       // body = component.get("v.body");
       // component.set("v.body",body);
	},
        
    toggleEvent: function(component, event, helper){
        var parentId = component.get("v.containerId");
        var thisId = event.getSource().getLocalId();
        console.log(thisId);
        var thisElement = component.find(thisId);
        var parentElement = component.find(parentId);
        var thisValue = thisElement.get("v.value");
        console.log(thisValue);
        if(thisValue.toUpperCase() === 'SHOW MORE'){
            component.set("v.toggleValue",'Show Less');
            $A.util.toggleClass(parentElement,'full-text');
        }
        else{
            component.set("v.toggleValue",'Show More');
            $A.util.toggleClass(parentElement,'short-text');
        }
    }
})