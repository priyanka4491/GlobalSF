({
	doInit : function(component, event, helper) {
    var page = component.get("v.page") || 1;
    var ispageChange = false;
    var isInitialize = true;
    component.set("v.usersInitialLoad",true);
    var accComId = component.get("v.growerAcc").split(',')[2] ? component.get("v.growerAcc").split(',')[2] :'';
    component.set("v.accComId",accComId);
	helper.programEventListHelper(component,event,page,ispageChange,isInitialize);
    helper.createAccountDetailsComp(component, event);
	},
    pageChange: function(component,event,helper) {
        var cmpName = event.getParam("compName");
        console.log('cmpName' + cmpName);
        if(cmpName == 'PgmActivityList'){
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        var ispageChange = true;        
        var isInitialize = false;
        component.set("v.usersInitialLoad",false);
        helper.programEventListHelper(component,event,page,ispageChange,isInitialize);
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
    scheduleTouchpoint : function(component,event,helper){
        var programId='';
        var activitiesIds='';
        var accountId = '';
        var touchpointId = '';
        var touchpointDate = '';
        var orginComponent = '';
        var newTouchpoint = event.currentTarget.id;
		programId = newTouchpoint.split('/')[0];    
        accountId = newTouchpoint.split('/')[1];
        activitiesIds = newTouchpoint.split('/')[2];
        touchpointId = newTouchpoint.split('/')[3];
        touchpointDate = newTouchpoint.split('/')[4];
        orginComponent = newTouchpoint.split('/')[5];
        //alert(programId+'/'+accountId+'/'+activitiesIds+'/'+touchpointId+'/'+touchpointDate+'/'+orginComponent);
        var cmpEvent = component.getEvent("redirectToDealerDetail");
        cmpEvent.setParams({
            "accIdSapIdAccCommId" : programId+'/'+accountId+'/'+activitiesIds+'/'+touchpointId+'/'+touchpointDate+'/'+orginComponent,
            "tabScopeNo" : '4',
            "componentName":"c:Frontier_GrowerAccount_UpdateTouchPoint",
            "newUpdateStatus":'New'
        });
        cmpEvent.fire();

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
        var programEventId = event.target.id.split(',')[0];
        cmpEvent.setParams({
            "accIdSapIdAccCommId" :accId +","+","+accCommId+","+programId+","+programEventId,
            "tabScopeNo" : '4',
            "componentName":"c:Frontier_Programs_Activities"
        });
        cmpEvent.fire();
    }
});