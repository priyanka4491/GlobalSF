({
	doInit : function(component, event, helper) {
        var page = component.get("v.page") || 1;
        var ispageChange = false;
        var isInitialize = true;
        var accComId = component.get("v.growerAcc").split(',')[2] ? component.get("v.growerAcc").split(',')[2] :'';
        component.set("v.accComId",accComId);
        helper.createAccountDetailsComp(component, event);
        helper.getProgramActivitiesList(component,event,page,ispageChange,isInitialize);	
	},
    activitiesPageChange: function(component,event,helper) {
        var cmpName = event.getParam("compName");
        console.log('cmpName' +cmpName);
         if(cmpName == 'ActivitiesList'){
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        var ispageChange = true;        
        var isInitialize = false;
        helper.getProgramActivitiesList(component,event,page,ispageChange,isInitialize);
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
        helper.getProgramActivitiesList(component,event,page,ispageChange,isInitialize); 
    },
    scheduleTouchpoint : function(component,event,helper){
        var i;
        var programIds='';
        var activitiesIds='';
        var allActivitySelectedOfSameType=true;
        var activitySelectedArray = [];
        
        //Validating all Activities are selected with same Type
        for(i=0;i<document.getElementsByClassName('checkboxClass').length;i++){
            if(document.getElementsByClassName('checkboxClass')[i].checked){
                if(!activitySelectedArray.includes(document.getElementById('ActivityType_'+i).innerHTML)){
                    if(document.getElementById('ActivityType_'+i).innerHTML === '') {
                        activitySelectedArray.push(document.getElementById('ActivityType_'+i).innerHTML);
                    }else{
                        activitySelectedArray.push(document.getElementById('ActivityType_'+i).innerHTML);
                    }
                }
            }
        }
        
        if(activitySelectedArray.length > 1){
            allActivitySelectedOfSameType=false;
        }
        if(allActivitySelectedOfSameType)  {      
            for(i=0;i<document.getElementsByClassName('checkboxClass').length;i++){
                if(document.getElementsByClassName('checkboxClass')[i].checked){
                    //alert(document.getElementsByClassName('checkboxClass')[i].id);
                    if(!programIds.includes((document.getElementsByClassName('checkboxClass')[i].id).split('/')[0])){
                        programIds +=','+(document.getElementsByClassName('checkboxClass')[i].id).split('/')[0];
                    }
                    
                    activitiesIds += ','+(document.getElementsByClassName('checkboxClass')[i].id).split('/')[1];
                    //alert(activitiesIds);
                }
            }
            programIds = programIds.substring(1,activitiesIds.length);
            activitiesIds = activitiesIds.substring(1,activitiesIds.length);
            console.log(programIds+'/'+component.get("v.growerAcc")+'/'+activitiesIds);
            //alert(activitiesIds);
            var cmpEvent = component.getEvent("redirectToDealerDetail");
            cmpEvent.setParams({
                "accIdSapIdAccCommId" : programIds+'/'+component.get("v.growerAcc")+'/'+activitiesIds,
                "tabScopeNo" : '4',
                "componentName":"c:Frontier_GrowerAccount_UpdateTouchPoint",
                "newUpdateStatus":'New'
            });
            cmpEvent.fire();
        } else {
            alert('Please Select All Activities of Same Type')
        }

    },
    cancelActivity : function(component,event,helper){
        console.log('cancel');
		helper.cancelSelectedActivity(component,event,helper);
        var page = component.get("v.page") || 1;
    	var ispageChange = false;
    	var isInitialize = true;
    	component.set("v.usersInitialLoad",true);
		helper.getProgramActivitiesList(component,event,page,ispageChange,isInitialize);    
    },
    cancelTouchpoint : function(component,event,helper){
        var i;
        var activitiesIds='';
        for(i=0;i<document.getElementsByClassName('checkboxClass').length;i++){
        	document.getElementsByClassName('checkboxClass')[i].checked = false;
        }
        
    },
    pgmEventNavigation: function(component,event,helper){
     helper.navigateToProgramDetail(component,event,helper);   
    },
    
    individualScheduleTouchpoint : function(component,event,helper){
        var i;
        var programIds='';
        var activitiesIds='';
        //alert(document.getElementsByClassName('checkboxClass')[event.target.id].id)
        /*if(!programIds.includes((document.getElementsByClassName('checkboxClass')[event.target.id].id).split('/')[0])){
            programIds +=','+(document.getElementsByClassName('checkboxClass')[event.target.id].id).split('/')[0];
        }*/
        activitiesIds = (document.getElementsByClassName('checkboxClass')[event.target.id].id).split('/')[1];
        programIds = (document.getElementsByClassName('checkboxClass')[event.target.id].id).split('/')[0];
        console.log('programIds=>'+programIds);console.log('activitiesIds=>'+activitiesIds);
        var cmpEvent = component.getEvent("redirectToDealerDetail");
        cmpEvent.setParams({
            "accIdSapIdAccCommId" : programIds+'/'+component.get("v.growerAcc")+'/'+activitiesIds,
            "tabScopeNo" : '4',
            "componentName":"c:Frontier_GrowerAccount_UpdateTouchPoint",
            "newUpdateStatus":'New'
        });
        cmpEvent.fire();
        
        
    }
});