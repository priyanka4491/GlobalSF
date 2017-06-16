({
	doInit : function(component, event, helper) {
        var page = component.get("v.page") || 1;	
        var ispageChange = false;
        var isInitialize = true;
        console.log("ispageChange out" + ispageChange);
        if (ispageChange == undefined){
            console.log("ispageChange" + ispageChange);
        }
        component.set("v.usersInitialLoad",true);
        helper.navigateToProfileDetails(component, event);
        helper.listProgram(component,event,helper,page,ispageChange,isInitialize);
	},
    pageChange: function(component,event,helper) {
        var page = component.get("v.page") || 1;        
        var direction = event.getParam("direction");        
        page = direction === "previous" ? (page - 1) : (page + 1);
        var ispageChange = true;        
        var isInitialize = false;
        component.set("v.usersInitialLoad",false);
        helper.listProgram(component,event,helper,page,ispageChange,isInitialize);    
    },
    sortDirection : function(component,event,helper){
        if(event.currentTarget.id != '' && component.get("v.prevId") != '' && component.get("v.prevId") != event.currentTarget.id){
            component.set("v.SortBy"+component.get("v.prevId"),"onMouseOut");
        }
        var page = component.get("v.page") || 1;
        console.log("Event Target"+event.target.id)
        console.log("Current target" + event.currentTarget.id);
        if(event.currentTarget.id != ''){
            component.set("v.SortBy"+event.currentTarget.id,"onClick");
        }
        var ispageChange = false;
        var isInitialize = false;       
        component.set("v.prevId",event.currentTarget.id); 
        component.set("v.usersInitialLoad",false);
        helper.listProgram(component,event,helper,page,ispageChange,isInitialize); 
    },
    pgmEventNavigation: function(component,event,helper){
        
        helper.navigateToProgramDetail(component, event);
    },
    cancelProgram : function(component,event,helper){
        //console.log('Inside cancel' + document.getElementById("newCancel").style.display);
        component.set("v.programId" , event.currentTarget.id);
        console.log(component.get("v.programId"));
        document.getElementById("newCancel").style.display = "block";
        document.getElementById("cancelbackgrnd").style.display = "block";
       // var cancelEvent = $A.get("e.c:Frontier_CancelEvent");
        //cancelEvent.fire();
        //document.getElementById("newCancel").style.display = "block";
        //document.getElementById("cancelbackgrnd").style.display = "block";
       /* helper.cancelPgm(component,event);
        var page = component.get("v.page") || 1;	
        var ispageChange = false;
        var isInitialize = true;
        console.log("ispageChange out" + ispageChange);
        if (ispageChange == undefined){
            console.log("ispageChange" + ispageChange);
        }
        component.set("v.usersInitialLoad",true);
        helper.listProgram(component,event,helper,page,ispageChange,isInitialize); */
    },
    showModalBox : function(component,event,helper){
        document.getElementById("newCancel").style.display = "none";
        document.getElementById("cancelbackgrnd").style.display = "none";
        component.find("comments").set("v.value", ' ');
    },
    cancelPgmReason : function(component,event,helper){
        document.getElementById("newCancel").style.display = "none";
        document.getElementById("cancelbackgrnd").style.display = "none";
        var reason = component.find("comments").get("v.value");
        console.log("reason" + reason);
        component.find("comments").set("v.value", ' ');
        helper.cancelPgm(component,event,reason);
        var page = component.get("v.page") || 1;	
        var ispageChange = false;
        var isInitialize = true;
        console.log("ispageChange out" + ispageChange);
        if (ispageChange == undefined){
            console.log("ispageChange" + ispageChange);
        }
        component.set("v.usersInitialLoad",true);
        helper.listProgram(component,event,helper,page,ispageChange,isInitialize);
        
    }
})