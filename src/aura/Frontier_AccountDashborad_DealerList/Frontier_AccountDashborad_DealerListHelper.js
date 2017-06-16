({
	getdealerdetails : function(component,event,helper,page) {
		var action = component.get("c.getDealersList");
        var crop = component.get("v.crop");
        var season = component.get("v.season");
        var visit = component.find("visit").get("v.value");
        action.setParams({
        		pageNumber :page,
                pageSize : component.get("v.pageSize"),
            	crop : crop,
            	season : season,
                accType : component.get("v.accType"),
                visit : (visit=='None'?'null':visit)
            });
        action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var retResponse =JSON.parse(response.getReturnValue());
                   
                     if(retResponse.length > 0){
                component.set("v.total",retResponse[0].Count);
                component.set("v.pages",Math.ceil((retResponse[0].Count)/component.get("v.pageSize")));
                component.set("v.page",page);
                }
                else if(retResponse.length == 0){
                    component.set("v.total",0);
                    component.set("v.pages",1);
                    component.set("v.page",1);
                }
                     component.set("v.accountsList", retResponse); 
                }
            else{
                console.log('Error');
            }
             });
        $A.enqueueAction(action);
		
	}
})