({
	doInit : function(component, event, helper) {
		var key= component.get("v.key");
        var Tmap = component.get("v.taskMap");
        var taskList = [];
        var tasks = [];
        var task;
         console.log("Taskssssssssssss Map=====================>"+Tmap);
        console.log("keyyyyyyyyyyyy=====================>"+key);
        //tasks.push(Tmap[key]);
        for(var key1 in Tmap){
            if(key1 == key){
                taskList.push(Tmap[key1]);
            }
            
        }
        
        //tasklist.push(map[key]);
        component.set("v.tasks",taskList);
        var tasklist=component.get("v.tasks");
        console.log("Taskssssssssssss List=====================>"+ JSON.stringify(tasklist));
        var programs = [];
        var programActivities =[];
        var date =[];
        var type=[];
        var status=[];
        var redirectParameter='';
        for(var i=0;i<tasklist.length;i++){
            for(var j=0;j<tasklist[i].length;j++){
            console.log(tasklist[i][j].Program_SFID__r.Name);
                programs.push(tasklist[i][j].Program_SFID__r.Name);
                programActivities.push(tasklist[i][j].Program_Activity_SFID__r.Name);
                date.push(tasklist[i][j].TouchPoint_SFID__r.Date__c);
                type.push(tasklist[i][j].TouchPoint_SFID__r.TouchPointTypes__c);
                status.push(tasklist[i][j].TouchPoint_SFID__r.TouchPoint_Status__c);
                redirectParameter = tasklist[i][j].Program_SFID__c +'/'+ component.get("v.growerAcc")+'/'+tasklist[i][j].Program_Activity_SFID__c+'/'+tasklist[i][j].TouchPoint_SFID__c+'/'+tasklist[i][j].TouchPoint_SFID__r.Date__c+'/'+'c:Frontier_GrowerAcc_Touchpoint';
        }
        }
        component.set("v.Programs",programs);
        component.set("v.ProgramActivities",programActivities);
        component.set("v.TouchpointDate",date);
        component.set("v.TouchpointStatus",status);
        component.set("v.TouchpointType",type);
        component.set("v.redirectString",redirectParameter)

        console.log('Program Name' +component.get("v.Programs")+component.get("v.ProgramActivities")+component.get("v.TouchpointDate"));
	   console.log('Program Name------' +component.get("v.TouchpointStatus")+component.get("v.TouchpointType"));

    },
    navigateToTouchpointEventFire : function(cmp,event,helper){
    	

    	var compEvent = cmp.getEvent("navigateToTouchpointList");
        compEvent.setParams(
            { 
                touchPointRedirect :  cmp.get("v.redirectString"),
                touchPointStatus : document.getElementById(event.target.parentNode.id).parentNode.parentNode.childNodes[4].innerHTML
            
            }
        );
        compEvent.fire();

	}
})