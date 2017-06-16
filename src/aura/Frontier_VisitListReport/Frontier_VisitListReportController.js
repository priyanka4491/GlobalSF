({
    doInit : function(component, event, helper) {
        var page = component.get("v.page") || 1;
        var isInitialize = true;
        helper.getsEventRecords(component,event,page,helper,isInitialize);
        
    },
    pageChange: function(component,event,helper) {
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        console.log("Page direction" + page);
        var isInitialize = false;
        helper.getsEventRecords(component,event,page,helper,isInitialize);
    },
    VisitsList:function(component,event,helper){
        var page = 1;
        var isInitialize = false;
        helper.getsEventRecords(component,event,page,helper,isInitialize);
    },
    exportData:function(component,event,helper){
        component.set("v.isExport",true);
        var page = 1;
        var isInitialize = false;
        helper.getsEventRecords(component,event,page,helper,isInitialize);
    },
    tooglepopover:function(component,event,helper){
        var popElement = document.getElementById("popover" +event.target.id);
        $A.util.toggleClass(popElement, "slds-show");
        if((document.getElementById(event.target.id).innerHTML) === 'Show More'){
            //component.set('v.toolTipToggle','Show Less');
            document.getElementById(event.target.id).innerHTML='Show Less';
           if($A.get("$Browser.isDesktop"))
           {
        		popElement.scrollIntoView();
               
           }
        }else {
            //component.set('v.toolTipToggle','Show More');
            document.getElementById(event.target.id).innerHTML='Show More';

        }
        //window.location.hash = '#popover'+event.target.id;
    },
     clearSearchValues : function(component, event, helper) {
        component.find("sortByType").set("v.value","");
        component.find("sortByRADL").set("v.value","");
        component.find("MonthSort").set("v.value","");
        var page = component.get("v.page") || 1;
        var isInitialize = false;
        helper.getsEventRecords(component,event,page,helper,isInitialize);
    },
   
})