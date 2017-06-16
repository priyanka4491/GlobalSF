({
	doInit : function(component, event, helper) {
        var crop='Corn';
        var season='SUMMER';
        
       helper.getPicklistValues(component,event);
        helper.getchartdetails(component,event,crop,season);
	},
    changeseasonCrop : function(component,event,helper){
       var crop= component.find("cropDetailsGrower").get("v.value");
        var season=component.find("sellingSeasonGrower").get("v.value");
         helper.getchartdetails(component,event,crop,season);
    }
})