({
    addPgm : function(component,event){
        document.getElementById("newSectionId").style.display = "block";
        document.getElementById("backSectionId").style.display = "block";
        //component.set("v.depntPicValue" , '');
        var action = component.get("c.getPicklistValue");
        //var programsel = component.find("programName");
        var programs=[];
        var depProg = ['None'];
        var result;
        var value= 'None';
        action.setCallback(this, function(a){
            var state = a.getState();
            result = a.getReturnValue();
            for(var i=0;i< result.length;i++){
                programs.push({"class": "optionClass", label: result[i], value: result[i]});
            }
            //programsel.set("v.options",programs);
            component.set("v.picValue" , result);
            component.set("v.depntPicValue" , depProg);
            component.set("v.selectedCntrlValue", '');
            component.set("v.highlghtDepValue", '');
        });
        $A.enqueueAction(action); 
    },    
    addNonPgm : function(component,event){
        document.getElementById("newSectionnonId").style.display = "block";
        document.getElementById("backSectionnonId").style.display = "block";
        var action = component.get("c.getNonPicklistValue");
        var nonprograms=[];
        var result;
        action.setCallback(this, function(a){
            var state = a.getState();
            result = a.getReturnValue();
            //programsel.set("v.options",programs);
            component.set("v.nonActivityValue" , result);
            component.set("v.nonProgram" , 'Non-Program');
            component.set("v.selectedNonactv", '');
        });
        $A.enqueueAction(action); 
    },    
    selectChangeHandler : function(component,event){
        var controlPick = event.currentTarget.id;
        var previousValue;
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
            result = a.getReturnValue();
            for(var i=0;i< result.length;i++){
                activities.push({"class": "optionClass", label: result[i], value: result[i]});
            }
            
            component.set("v.depntPicValue" , result);
            if(controlPick != previousValue){
                component.set("v.highlghtDepValue", ''); 
            }
            
            component.set("v.selectedCntrlValue", controlPick);  
            previousValue = component.get("v.selectedCntrlValue");
        });
        $A.enqueueAction(action); 
    },
    selectNonactiv : function(component,event){
        var nonActiveValue = event.currentTarget.id;
        component.set("v.selectedNonactv", nonActiveValue);
    },    
    selectDependent : function(component,event){
        //var controlField = component.get("v.selectedCntrlValue");
        var selectedDepValue = event.currentTarget.id;
        component.set("v.highlghtDepValue", selectedDepValue);
    },
    getDone : function(){
        document.getElementById("newSectionId").style.display = "none";
        document.getElementById("backSectionId").style.display = "none";
    },
    getnonPgmDone : function(){
        document.getElementById("newSectionnonId").style.display = "none";
        document.getElementById("backSectionnonId").style.display = "none";
    },
    clearData : function(component,event){
        var action = component.get("c.getPicklistValue");
        //var programsel = component.find("programName");
        // component.set("v.depntPicValue" , '');
        //var programs=[];
        var result;
        //var value= "None";
        action.setCallback(this, function(a){
            var state = a.getState();
            result = a.getReturnValue();
            /* for(var i=0;i< result.length;i++){
                programs.push({"class": "optionClass", label: result[i], value: result[i]});
            }*/
            //programsel.set("v.options",programs);
            component.set("v.picValue" , result);
            component.set("v.depntPicValue" , 'None');
            component.set("v.selectedCntrlValue", '');
            component.set("v.highlghtDepValue", '');
        });
        $A.enqueueAction(action); 
    },   
    addPgmActivity : function(component,event){
        var pgmValue = component.get("v.highlghtDepValue");
        var activityValue= component.get("v.selectedCntrlValue");
        if(pgmValue && activityValue != null){
            component.set("v.addProgramValue" , pgmValue + ' - '+activityValue);
            document.getElementById("newSectionId").style.display = "none";
            document.getElementById("backSectionId").style.display = "none";
        }                
    },
    addnonPgmActivity : function(component,event){
        var nonActive = component.get("v.selectedNonactv");
        var nonPgm = component.get("v.nonProgram");
        if(nonActive && nonPgm != null){
            component.set("v.addProgramValue" , nonActive + ' - '+nonPgm);
            document.getElementById("newSectionnonId").style.display = "none";
            document.getElementById("backSectionnonId").style.display = "none";
        }  
    }
   
})