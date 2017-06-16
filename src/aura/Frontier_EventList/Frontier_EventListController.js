({
    doInit : function(component, event, helper) {
        var page = component.get("v.page") || 1;
        var ispageChange = false;
        var isInitialize = true;
        component.set("v.usersInitialLoad",true);
        helper.getsEventObjectRecords(component,event,helper,page,ispageChange,isInitialize,'');	
    },
    VisitsList:function(component,event,helper){
        var page=1;
        var ispageChange = false;
        var isInitialize = false;
        if(component.get("v.prevId") != ''){
            component.set("v.SortBy"+component.get("v.prevId"),"onMouseOut");
        }
        component.set("v.usersInitialLoad",false);
        
        helper.getsEventObjectRecords(component,event,helper,page,ispageChange,isInitialize,component.find('createdUser').get("v.value"));
    },
    pageChange: function(component,event,helper) {
        var page = component.get("v.page") || 1;        
        var direction = event.getParam("direction");        
        page = direction === "previous" ? (page - 1) : (page + 1);
        var ispageChange = true;        
        var isInitialize = false;
        component.set("v.usersInitialLoad",false);
        helper.getsEventObjectRecords(component,event,helper,page,ispageChange,isInitialize,component.find('createdUser').get("v.value"));    
    },
    /*  showIcon : function(component,event){
        if(event.target.id != null && component.get("v.SortBy"+event.target.id) != "onClick"){
            component.set("v.SortBy"+event.target.id,"onHover");
        }
    },
    hideIcon : function(component,event){
        if(event.target.id != null && component.get("v.SortBy"+event.target.id) != "onClick"){
            component.set("v.SortBy"+event.target.id,"onMouseOut");
        }
    },*/
    sortDirection : function(component,event,helper){
        if(event.target.id != '' && component.get("v.prevId") != '' && component.get("v.prevId") != event.target.id){
            component.set("v.SortBy"+component.get("v.prevId"),"onMouseOut");
        }
        var page = component.get("v.page") || 1;
        console.log("Event Target"+event.target.id)
        if(event.target.id != ''){
            component.set("v.SortBy"+event.target.id,"onClick");
        }
        var ispageChange = false;
        var isInitialize = false;       
        component.set("v.prevId",event.target.id); 
        component.set("v.usersInitialLoad",false);
        helper.getsEventObjectRecords(component,event,helper,page,ispageChange,isInitialize,component.find('createdUser').get("v.value")); 
    },
    exportData:function(component,event,helper){
        component.set("v.isExport",true);
        var page = component.get("v.page");
        var ispageChange = true;
        var isInitialize = false;
        component.set("v.usersInitialLoad",false);         
        helper.getsEventObjectRecords(component,event,helper,page,ispageChange,isInitialize,component.find('createdUser').get("v.value"));
        
    },
    VisitFilterList:function(component,event,helper){
        var page = component.get("v.page");
        var ispageChange = true;
        var isInitialize = false;
        component.set("v.usersInitialLoad",false);
        helper.getsEventObjectRecords(component,event,helper,page,ispageChange,isInitialize,component.find('createdUser').get("v.value"));
    },
    filerByCreatedUser : function(component,event,helper){
        component.set("v.userId",component.find('createdUser').get("v.value"));
        console.log('createdUser=>'+component.find('createdUser').get("v.value"));
        component.set("v.createdByUserIds",component.find('createdUser').get("v.value"));
        var page = component.get("v.page") || 1;        
        var ispageChange = true;
        var isInitialize = false;
        component.set("v.usersInitialLoad",false);
        helper.getsEventObjectRecords(component,event,helper,page,ispageChange,isInitialize,component.find('createdUser').get("v.value"));        
    },
    
    filerByTeam : function(component,event,helper){
        component.set("v.territoryId",component.find('TeamSort').get("v.value"));
        console.log('createdUser=>'+component.find('TeamSort').get("v.value"));
        var page = component.get("v.page") || 1;        
        var ispageChange = true;
        var isInitialize = false;
        component.set("v.usersInitialLoad",false);
        helper.getsEventObjectRecords(component,event,helper,page,ispageChange,isInitialize,component.find('createdUser').get("v.value"));        
    },
    clearSearchValues : function(component, event, helper) {
        component.find("sortByRADLList").set("v.value","");
        component.find("createdUser").set("v.value","");
        component.find("MonthSort").set("v.value","");
        component.find("TeamSort").set("v.value","");
        
        component.set("v.triggeredField","");
        var page = component.get("v.page") || 1;
        var ispageChange = false;
        var isInitialize = false;
        helper.getsEventObjectRecords(component,event,helper,page,ispageChange,isInitialize,'');
    },
    toggleShowLess: function(component, event){
        console.log('Previous Id'+component.get("v.PrevIndex"));
        var prevId = (component.get("v.PrevIndex") != "" ? component.get("v.PrevIndex") : "");
        var replaceText = '';
        console.log('event.target.id' + event.target.id);
        if(event.target.id.includes("showeventId")){
            replaceText='showeventId';
        }
        else if(event.target.id.includes("lesseventId")){
            replaceText='lesseventId';
        }
        var prevtoggleId = prevId.replace(replaceText,'');
        var thisId = event.target.id;
        var thisElement = document.getElementById(thisId);
        var thisValue = thisElement.innerHTML;
        var prevElement = document.getElementById(prevId);
        var prevValue ="";
        if(prevElement !== null && prevElement !== '' && prevElement !== 'undefined'){
            prevValue = prevElement.innerHTML;
        }
        var showmoreId = 'showmore'+event.target.id.replace(replaceText,'');
        var showmoreElement = document.getElementById(showmoreId);
        var showlessId = 'showless'+event.target.id.replace(replaceText,'');
        var showlessElement = document.getElementById(showlessId);
        console.log(thisValue);
        if(thisValue === "" || thisValue === 'undefined' || thisValue.toUpperCase() === 'SHOW MORE'){
            if(prevId !== '' && prevId !== 'undefined' && prevValue.toUpperCase() === 'SHOW LESS'){
                prevElement.innerHTML = 'Show More';
                $A.util.removeClass(document.getElementById('showless'+prevtoggleId),'slds-show');
                $A.util.addClass(document.getElementById('showless'+prevtoggleId),'slds-hide');
                $A.util.removeClass(document.getElementById('showmore'+prevtoggleId),'slds-hide');
                $A.util.addClass(document.getElementById('showmore'+prevtoggleId),'slds-show');
            }
            thisElement.innerHTML = 'show Less';
            document.getElementById(event.target.id.replace('showeventId','lesseventId')).innerHTML = 'Show Less';
            $A.util.removeClass(showlessElement,'slds-hide');
            $A.util.addClass(showlessElement,'slds-show');
            $A.util.removeClass(showmoreElement,'slds-show');
            $A.util.addClass(showmoreElement,'slds-hide');
        }
        else{
            thisElement.innerHTML = 'show More';
            document.getElementById(event.target.id.replace('lesseventId','showeventId')).innerHTML = 'Show More';
            $A.util.removeClass(showlessElement,'slds-show');
            $A.util.addClass(showlessElement,'slds-hide');
            $A.util.removeClass(showmoreElement,'slds-hide');
            $A.util.addClass(showmoreElement,'slds-show');
        }
        console.log('********************'+thisId);
        component.set("v.PrevIndex",thisId);
        console.log(component.get("v.PrevIndex"));
    },
});