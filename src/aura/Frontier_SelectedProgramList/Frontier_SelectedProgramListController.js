({
    doInit : function(component, event, helper) {
    component.set("v.isInitialize",true);
        component.set("v.highlightPanel",'background:#D3D3D3;width:100%;text-align: initial;');
        console.log('isInitialize'+component.get("v.isInitialize"));
        console.log('component.get("v.programList")'+component.get("v.programList"));
component.set("v.isInitialLoad",false);
        helper.applyPaginationToTable(component,event,component.get("v.programList"));
},
	
    
    
    highlightProgram : function(component, event, helper) {
        var progId;
        var isInitialLoad = component.get("v.isInitialLoad");
        if(event.target != undefined){
            progId = event.target.id;
            var myEvent = $A.get("e.c:Frontier_SelectedProgramEvent");
        myEvent.setParams({"progId": progId});
        myEvent.fire();
            console.log('clicked from child'+event.target.id);
            component.set("v.isInitialize",false);
        } 
        else{
            console.log('Last Event from Child'+event.getParam("programId"));
            
            progId = event.getParam("programId");
           
        }
         component.set("v.progId",progId);
        if(!isInitialLoad){
            component.set("v.isInitialLoad",true);
        }
            
           // var triggeredProgram = document.getElementById(progId);
           // $A.util.addClass(document.getElementById(progId), 'changeMe');
           /* if(component.get("v.btnPrevious") != null){
            	var prevTriggeredProgram = document.getElementById(component.get("v.btnPrevious"));
            $A.util.removeClass(prevTriggeredProgram,'changeMe');
            }
            component.set("v.btnPrevious",event.target.id);*/
       /* if(component.get("v.isInitialLoad")){
            
        }*/

	},
     tableChange: function(component,event,helper) {
         var cmpName = event.getParam("compName");
        console.log('cmpName' + cmpName);
        if(cmpName == 'ProgramList'){
        //component.set("v.isInitialize",false); 
        helper.applyPaginationToTable(component,event,component.get("v.programList"));
        }
     }
   
   
})