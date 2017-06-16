({
    doInit : function(component, event, helper) {
        var uniqueId =  component.get("v.uniqueId");
        console.log("uniqueAuraId:" + uniqueId);
        $A.createComponent(
            "c:Frontier_DynamicAruaIdMarkup",
            {
             "aura:id":uniqueId,
            },
            function(newCmp){
                var cmp = component.find('root');
                cmp.set("v.body", newCmp);
            }
        );
        
        var elem =  component.find(uniqueId);
    }
})