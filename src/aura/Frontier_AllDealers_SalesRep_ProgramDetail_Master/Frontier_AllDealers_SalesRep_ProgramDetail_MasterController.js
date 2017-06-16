({
	doInit : function(component, event, helper) {
    var page = component.get("v.page") || 1;
    var ispageChange = false;
    var isInitialize = true;
    helper.programEventListHelper(component,event,page,ispageChange,isInitialize);	
    helper.getAllPrograms(component,event,helper);
	},
    pageChange: function(component,event,helper) {
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        var ispageChange = true;        
        var isInitialize = false;
        component.set("v.usersInitialLoad",false);
        helper.programEventListHelper(component,event,page,ispageChange,isInitialize);
    },
     refreshProgram : function(component,event,helper){
        console.log('Inside refresh Event');
         var cmpName = event.getParam("compName");
        console.log('cmpName' + cmpName);
        if(cmpName == 'AllDealers'){
         component.set("v.loadchart1" , false);
         component.set("v.loadchart2" , false);
         component.set("v.loadchart3" , false);
         component.set("v.loadchart4" , false);
       helper.getAllPrograms(component,event,helper);
        }
    
    },
    sortDirection : function(component,event,helper){
        if(event.currentTarget.id != '' && component.get("v.prevId") != '' && component.get("v.prevId") != event.currentTarget.id){
            component.set("v.SortBy"+component.get("v.prevId"),"onMouseOut");
        }
        var page = 1;
        console.log("Event Target"+event.currentTarget.id)
        if(event.currentTarget.id != ''){
            component.set("v.SortBy"+event.currentTarget.id,"onClick");
        }
        var ispageChange = false;
        var isInitialize = false;       
        component.set("v.prevId",event.currentTarget.id); 
        component.set("v.usersInitialLoad",false);
        helper.programEventListHelper(component,event,page,ispageChange,isInitialize); 
    },
    updateTouchPointNavigation: function(component,event,helper){
        helper.navigateToUpdateTouchPointDetail(component, event);
    },
    cancelActivity : function(component,event,helper){

        console.log('cancel');
		helper.cancelSelectedActivity(component,event);
        var page = component.get("v.page") || 1;
    	var ispageChange = false;
    	var isInitialize = true;
    	component.set("v.usersInitialLoad",true);
		helper.programEventListHelper(component,event,page,ispageChange,isInitialize);  
    },
    navigateToTouchPoints : function(component,event,helper){
        var cmpEvent = component.getEvent("redirectToDealerDetail");
        var accId = component.get("v.accountId");
        var programId = component.get("v.programId");
        var accCommId = component.get("v.growerAcc").split(',')[2];
        var programEventId = event.target.id;
        cmpEvent.setParams({
            "accIdSapIdAccCommId" :accId +","+","+accCommId+","+programId+","+programEventId,
            "tabScopeNo" : '4',
            "componentName":"c:Frontier_Programs_Activities"
        });
        cmpEvent.fire();
    },
    fetchSeasonData : function(component, event, helper) {
		helper.getSeason(component, event, helper);
	}
});