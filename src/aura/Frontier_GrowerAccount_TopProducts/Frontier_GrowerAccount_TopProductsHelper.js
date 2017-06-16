({
    getTopProducts : function(component, event) {
        console.log("Inside doinit");
        var action = component.get("c.topProducts");
        action.setCallback(this, function(response) {
            var topProdcutsValue = response.getReturnValue();
            console.log("topProdcutsValue" + topProdcutsValue);
            component.set("v.topProducts",topProdcutsValue);
            if (response.getState() === "SUCCESS") {
                console.log("Success");
            } else if (response.getState() === "ERROR") {
                $A.log("Errors", response.getError());            
            }
        });
       $A.enqueueAction(action);
    }
})