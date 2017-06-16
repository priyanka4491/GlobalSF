({
	addPgm : function(component,event){
        alert('Inside addpgm');
        document.getElementById("newSectionId").style.display = "block";
        document.getElementById("backSectionId").style.display = "block";
        var action = component.get("c.getPicklistValue");
        //var programsel = component.find("programName");
        var programs=[];
        var result;
        var value= "None";
        action.setCallback(this, function(a){
            var state = a.getState();
            console.log("state" + state);
            result = a.getReturnValue();
            for(var i=0;i< result.length;i++){
                programs.push({"class": "optionClass", label: result[i], value: result[i]});
            }
            //programsel.set("v.options",programs);
            component.set("v.picValue" , result);
            component.set("v.depntPicValue" , value);
            component.set("v.selectedCntrlValue", '');
            component.set("v.highlghtDepValue", '');
        });
        $A.enqueueAction(action); 
    },    
    selectChangeHandler : function(component,event){
        var controlPick = event.currentTarget.id;
        console.log('controlPick' + controlPick);
        //var controlPick = component.find("programName").get("v.value");
        var action = component.get("c.getDependentValue");
        var activitysel = component.find("activityName");
        var activities=[];
        var result;
        action.setParams({
            Controlvalue: controlPick
         });
        action.setCallback(this, function(a){
            var state = a.getState();
            console.log("state" + state);
            result = a.getReturnValue();
            for(var i=0;i< result.length;i++){
                activities.push({"class": "optionClass", label: result[i], value: result[i]});
            }
            //activitysel.set("v.options",activities);
            component.set("v.depntPicValue" , result);
            component.set("v.selectedCntrlValue", controlPick);
        });
        $A.enqueueAction(action); 
    },
    selectDependent : function(component,event){
        var selectedDepValue = event.currentTarget.id;
        console.log('selectedDepValue' + selectedDepValue);
        component.set("v.highlghtDepValue", selectedDepValue);
    },
    getDone : function(){
        document.getElementById("newSectionId").style.display = "none";
        document.getElementById("backSectionId").style.display = "none";
    }

})