({
	programList : function(component,event,helper,page) {
	var page=page||1;
        var dealerId;
        
        var action = component.get("c.getAllPrograms");	
         
        dealerId = null;
        var isAllDealer = 'true';
        var isMyProgram = 'false';
      action.setParams({
                dealerId : dealerId,
                isAllDealer :isAllDealer,
                pageNumber : page,
                pageSize : component.get("v.pageSize"),
                isMyProgram :isMyProgram
                
            });
     action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var programlist = [];
                    component.set("v.page",page);
                    var retResponse = response.getReturnValue();
                    console.log("retResponse"+ retResponse);
                    if(retResponse.length > 0){
                    component.set("v.total",JSON.parse(retResponse[0]));
                    component.set("v.pages",Math.ceil((JSON.parse(retResponse[0]))/component.get("v.pageSize")));
                    programlist = JSON.parse(retResponse[1]);
                    component.set("v.programList", programlist);
                    }
                     else {
                    component.set("v.total",0);
                    component.set("v.pages",1);
                    component.set("v.page",1);
                }
                }else if (state === "ERROR"){
                    console.log('Error');
                }
            });
            $A.enqueueAction(action);
        
	}
})