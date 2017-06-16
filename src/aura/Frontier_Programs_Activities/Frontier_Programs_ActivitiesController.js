({
	doInit : function(component, event, helper) {        
        var partameters = component.get("v.growerAcc");
        console.log("partameters:" +partameters);        
        helper.getProgramEventListHelper(component, event, helper); 
	},
    loadCaroselDom : function(component, event, helper){
        var parameters = event.getParam("modalParameters");
        component.set("v.modelProgramId",parameters.split(',')[3]);
        component.set("v.modelProgramStatus",parameters.split(',')[5]);
        if(event.getParam("isPopup")){
            if(parameters.split(',')[4] === 'completeProgramlink'){
                component.set("v.popupName", 'Complete Program')
            }
            if(parameters.split(',')[4] === 'cancelProgramlink'){
                 component.set("v.popupName", 'Cancel Program')
            }
            var model = component.find('newCancel');
            $A.util.removeClass(model, 'slds-hide');
            $A.util.addClass(model, 'slds-show');
            var backDrop = component.find('cancelbackgrnd');
            $A.util.removeClass(backDrop, 'slds-hide');
            $A.util.addClass(backDrop, 'slds-show');   
        }else{
            var count = event.getParam("programCount");
            component.set("v.programCount",count);
        }

    },
    closeModal :function (component, event, helper){
        var model = component.find('newCancel');
        $A.util.removeClass(model, 'slds-show');
        $A.util.addClass(model, 'slds-hide');
        var backDrop = component.find('cancelbackgrnd');
        $A.util.removeClass(backDrop, 'slds-show');
        $A.util.addClass(backDrop, 'slds-hide'); 
    },
    updateProgramStatus : function(component, event, helper){
        var model = component.find('newCancel');
        $A.util.removeClass(model, 'slds-show');
        $A.util.addClass(model, 'slds-hide');
        var backDrop = component.find('cancelbackgrnd');
        $A.util.removeClass(backDrop, 'slds-show');
        $A.util.addClass(backDrop, 'slds-hide');
        var reason = component.find("comments").get("v.value");
        console.log("reason" + reason);
        component.find("comments").set("v.value", ' ');
        helper.updatePgmStatus(component, event, helper,reason);
    }
}