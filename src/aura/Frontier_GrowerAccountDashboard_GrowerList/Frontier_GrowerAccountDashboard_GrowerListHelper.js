({
	getdealerdetails : function(component,event,helper,page) {
		var action = component.get("c.getDealersList");
        var crop = component.get("v.crop");
        var season = component.get("v.season");
        action.setParams({
        		pageNumber :page,
                pageSize : component.get("v.pageSize"),
            	crop : crop,
            	season : season,
            	accType : 'Customer'
            });
        action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var retResponse =JSON.parse(response.getReturnValue());
                   
                     console.log("retResponse"+ JSON.stringify(retResponse));
                    if(retResponse.length > 0){
                console.log(retResponse[0].Count + 'Total');
                
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