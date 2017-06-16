({
	doInit : function(component, event, helper) {
        var page = component.get("v.page") || 1;
        component.set("v.isSubmitted",false);
        console.log('Get Programs on Do init');
		helper.getAllProgram(component,event,helper, page); 
	},
    reviewPageChange: function(component,event,helper) {
        var cmpName = event.getParam("compName");
        console.log('cmpName' + cmpName);
        if(cmpName == 'PgmPlngReview'){
        var page;
        var direction;
        page = component.get("v.page") || 1;
        direction = event.getParam("direction");
        
        page = direction === "previous" ? (page - 1) : (page + 1);
        console.log('page---' +page);
        helper.getAllProgram(component,event,helper,page);
        }     
    },
    backToProgramPlanning : function(component, event, helper) {
        var programEvent = $A.get("e.c:Frontier_ProgramPlanningEvent");
		 programEvent.setParams({"progId": component.get("v.progId") }).fire();
       /* $A.createComponent(
            "c:Frontier_ProgramPlanning",
            {
                progId : component.get("v.progId")
            },
            function(newCmp){
                var cmp = component.find("programDetail");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );*/
		
	},
    submitProgramPlanning : function(component, event, helper) {
        console.log('Inside submit Controller');
     helper.submitProgram(component,event,helper);
    },
   /* handleSubmitAction  : function(component,event,helper) {
        helper.handleSubmitProgramAction(component,event,helper);
    },*/
    handleAccountLoad :  function(component,event,helper){
        var pgmId = event.getParam("programId");
        
        component.set("v.loadProgramId",pgmId);
    }
})