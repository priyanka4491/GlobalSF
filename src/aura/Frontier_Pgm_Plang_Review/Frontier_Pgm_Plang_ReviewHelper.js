({
    getAllProgram : function(component, event, helper, page) {
        var program = component.get("v.programName");
        
        var page = page || 1;
        var pageSize=component.get("v.pageSize");
        var progIds = component.get("v.programIdSet");
        var action = component.get("c.getPrograms");
        action.setParams({
            pageNumber : page,
            pageSize : component.get("v.pageSize")
        });
        console.log('Get All Programs');
        
        action.setCallback(this, function(response) {
            var state = response.getState();
           
            if(state == 'SUCCESS'){
            var pgmList = []; 
            var pgmIdset =[];
            var pgmId =[];
            component.set("v.page",page);
            var programList = response.getReturnValue();
            component.set("v.pages",Math.ceil((JSON.parse(programList[0]))/component.get("v.pageSize")));
            component.set("v.total",JSON.parse(programList[0]));
            console.log('programList' + programList);
            pgmList = JSON.parse(programList[1]);
             pgmId= JSON.parse(programList[2]); 
            component.set("v.programDetails", pgmList);
                console.log('pgmList' +JSON.stringify(pgmList));
                for(var i=0;i<pgmId.length;i++){
              pgmIdset.push(pgmId[i]);
                }
                console.log('pgmIdset' +pgmIdset);
                component.set("v.programIdSet",pgmIdset);
                console.log('ProgramIdSet' + component.get("v.programIdSet"));
                /* $A.createComponent(
            "c:Frontier_ProgramPlanning_Radl",
            {
               
            },
            function(radl){
                var radlcmp = component.find("radlDiv");
                //cmp.set("v.body", []);
                radlcmp.set("v.body", radl);	
            }
        );*/   
            }
            else if (state === "ERROR"){
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
        
    },
    submitProgram :function(component,event,helper){
        console.log('Inside submit helper');
        var action = component.get("c.submitProgram");
       
        action.setParams({
            
            programIds : JSON.stringify(component.get("v.programIdSet"))
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == 'SUCCESS'){
                                     this.showPopUp(component,event,'Submitted Successfully');

                    
                    // alert('THE CHANGES HAS BEEN SAVED SUCCESSFULLY !!');
                     
                 
		   
            }
            else if (state === "ERROR"){
                console.log('Error');
            }
             });
        $A.enqueueAction(action);
    },
    
    showPopUp: function(component,event,message){
       component.set("v.isSubmitted",true);
    console.log("Inside showPop" + message);        
    $A.createComponent("c:Frontier_PopUp",
                       {Message : message,
                        ComponentName : 'Frontier_Pgm_Plang_Review'
                       },
                       function(newComp){
                           console.log('pop');
                           var comp = component.find("userpopup");
                           if(comp != undefined){
                           comp.set("v.body",newComp);
                           }
                       });
} ,  
   /* handleSubmitProgramAction : function(component,event,helper){
        console.log('Event Handled');
	         component.set("v.isSubmitted",true);
        var isSubmitted = component.get("v.isSubmitted");
                  if (component.isValid() && isSubmitted) {
             $A.createComponent(
            "c:Frontier_ProgramPlanning",
            {
                
            },
            function(newCmp){
                var cmp = component.find("programDetail");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );
                      
                      
                } */
    }
})