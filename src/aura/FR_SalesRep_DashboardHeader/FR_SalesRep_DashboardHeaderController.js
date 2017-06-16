({
	loadHeaderSeasonCrop : function(component, event, helper) {
		helper.loadFilterValues(component,event);   
	},
    fireFilterEvent : function(cmp, event) {
        var cmpEvent = cmp.getEvent("cmpEvent");
        cmpEvent.setParams({
            "season" : component.find("season").get("v.value"), 
            "crop"	 : component.find("crop").get("v.value")
        });
        cmpEvent.fire();
    }
})