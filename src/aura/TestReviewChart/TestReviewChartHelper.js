({
    getAllProgram : function(component, event, helper, page) {
        var program = component.get("v.programName");
        var action = component.get("c.getPrograms");
        var page = page || 1;
        var pageSize=component.get("v.pageSize");
        action.setParams({
            pageNumber : page,
            pageSize : component.get("v.pageSize")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
           
            if(state == 'SUCCESS'){
            var pgmList = []; 
            component.set("v.page",page);
            var programList = response.getReturnValue();
            component.set("v.pages",Math.ceil((JSON.parse(programList[0]))/component.get("v.pageSize")));
            component.set("v.total",JSON.parse(programList[0]));
            console.log('programList' + programList);
            pgmList = JSON.parse(programList[1]);
                
            component.set("v.programDetails", pgmList);
            }
            else if (state === "ERROR"){
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
    }
})