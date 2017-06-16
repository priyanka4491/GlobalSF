({
    doInit : function(component, event, helper) {
        var page = component.get("v.page") || 1;
        var ispageChange = false;
        var isInitialize = true;
         var account = '';
        component.set("v.accounts",account);
        console.log('--------'+component.get("v.accounts"));

        helper.getAllAccounts(component,page,event,ispageChange,isInitialize); 
      
    },
    pageChange: function(component, event, helper) {
        var cmpName = event.getParam("compName");
        console.log('cmpName' + cmpName);
        if(cmpName == 'ReviewAccountList'){
            var page;
            var direction;
            page = component.get("v.page") || 1;
            direction = event.getParam("direction");
            page = direction === "previous" ? (page - 1) : (page + 1);
            var ispageChange = true;        
            var isInitialize = false;
            helper.getAllAccounts(component,page,event,ispageChange,isInitialize);
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
        helper.getAllAccounts(component,page,event,ispageChange,isInitialize); 
    },
    toggleEvent : function(component, event, helper) {
        console.log('Inside toggle');
        //var toggleText = document.getElementById("accountTable");
        var uniqueId =event.target.id;
        console.log('uniqueId'+uniqueId);
        var ProgramId =uniqueId.split('-')[0];
        console.log('ProgramId' + ProgramId);
        var showHideList = component.get("v.showhideAccounts");
        if(showHideList =='Hide Account List'){
            $A.util.addClass(document.getElementById(ProgramId),'slds-hide');
            component.set("v.showhideAccounts",'Show Account List');  
        }
        if(showHideList =='Show Account List'){
            $A.util.removeClass(document.getElementById(ProgramId),'slds-hide');
            component.set("v.showhideAccounts",'Hide Account List');  
        }
        
    }
})