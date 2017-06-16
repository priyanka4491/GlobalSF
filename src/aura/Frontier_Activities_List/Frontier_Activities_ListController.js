({
    doInit : function(component,event,helper) {
        var formFactor = $A.get("$Browser.formFactor");
        if(formFactor === 'PHONE'){
            component.set("v.isMobileDevice",true);
        }
        else {
            component.set("v.isMobileDevice",false);
        }
        var productID = component.get("v.childProductId");
        console.log(productID);
        console.log('doInit');
        var page = component.get("v.page") || 1;
        var flag = false;
        helper.getsObjectRecords(component,event,page,productID,flag);
    },
    pageChange: function(component,event,helper) {
        var page = component.get("v.page") || 1;
        var productID = component.get("v.childProductId");
        var direction = event.getParam("direction");
        var flag = true;
        page = direction === "previous" ? (page - 1) : (page + 1);
        component.set("v.collapsibleId",'');
        helper.getsObjectRecords(component,event,page,productID,flag);
    },
    showModalBox : function(component){
        document.getElementById("searchText").value = '';
        /*Commented By Priyanka
         document.getElementById("searchContact").value = ''; */
        console.log('inside showModal');
        component.find("searchType").set("v.value","None");
        component.find("fromDate").set("v.value","");
        component.find("toDate").set("v.value","");
        document.getElementById("backGroundSectionId").style.display = "none";
        document.getElementById("newAccountSectionId").style.display = "none";
    },
    searchVisitsBy:function(component,event,helper){
        var productID = component.get("v.childProductId");
        var flag = true;
        console.log(productID);
        console.log('searchVisits');
        var page = 1;
        component.set("v.collapsibleId",'');
        helper.getsObjectRecords(component,event,page, productID,flag);
    },
    toggleEvent: function(component, event){
        console.log('Previous Id'+component.get("v.PrevIndex"));
        var prevId = (component.get("v.PrevIndex") != "" ? component.get("v.PrevIndex") : "");
        var replaceText = '';
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
    //Chartih added for handle activies on Modal
    handleTouchPoints:function(component, event, helper){
        var productID = component.get("v.childProductId");
        console.log(productID);
        console.log('doInit');
        var page = component.get("v.page") || 1;
        var flag = false;
        helper.getsObjectRecords(component,event,page,productID,flag);
    },
    clearSearchValues : function(component, event, helper) {
        document.getElementById("searchText").value = '';
        component.find("searchType").set("v.value","None");
        component.find("fromDate").set("v.value","");
        component.find("toDate").set("v.value","");
        var productID = component.get("v.childProductId");
        var page = 1;
        var flag = false;
        helper.getsObjectRecords(component,event,page,productID,flag);
    }
});