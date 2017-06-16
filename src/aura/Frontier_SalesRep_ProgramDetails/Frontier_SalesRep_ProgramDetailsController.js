({
	doInit : function(component, event, helper) {
    var progId = component.get("v.progId");
    console.log('Program Id' + progId);
    var page = component.get("v.page") || 1;
    var ispageChange = false;
    var isInitialize = true;
    component.set("v.usersInitialLoad",true);
	helper.programEventListHelper(component,event,page,ispageChange,isInitialize);	
    //helper.getAllPrograms(component,event,helper);
	},
    pageChange: function(component,event,helper) {
        var cmpName = event.getParam("compName");
        console.log('cmpName' + cmpName);
        if(cmpName == 'SalesRepAccountList'){
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
        var page = component.get("v.page") || 1;
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
    cancelProgram : function(component,event,helper){
        //console.log('Inside cancel' + document.getElementById("newCancel").style.display);
        var uniqueID = event.currentTarget.id;
        component.set("v.cancelUniqueId" , uniqueID);
        console.log(component.get("v.programId"));
        document.getElementById("newCancelPgm").style.display = "block";
        document.getElementById("cancelbackgrndPgm").style.display = "block";
    },
    showModalBox : function(component,event,helper){
        document.getElementById("newCancelPgm").style.display = "none";
        document.getElementById("cancelbackgrndPgm").style.display = "none";
        component.find("comments").set("v.value", ' ');
    },
    cancelPgmReason : function(component,event,helper){
        document.getElementById("newCancelPgm").style.display = "none";
        document.getElementById("cancelbackgrndPgm").style.display = "none";
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
        helper.programEventListHelper(component,event,page,ispageChange,isInitialize);        
    },
    completePgm : function(component,event,helper){
        helper.completePgm(component,event);
    },
    cancelActivity : function(component,event,helper){
        helper.cancelSelectedActivity(component,event);
        var page = component.get("v.page") || 1;
        var ispageChange = false;
        var isInitialize = true;
        component.set("v.usersInitialLoad",true);
        helper.programEventListHelper(component,event,page,ispageChange,isInitialize);  
    },    
    programDetailRedirect: function(component,event,helper){
        var uniqueId = event.target.id;      
        component.set("v.accountwithProgram",uniqueId);
        helper.navigateToActivityDetail(component, event,helper);
    },
    closeModal :function (component, event, helper){
			helper.closePopup(component, event);
    },
    showAddNewAccount:function(component, event, helper){
        var model = component.find('addnewaccount');
        $A.util.removeClass(model, 'slds-hide');
        $A.util.addClass(model, 'slds-show');
        var backDrop = component.find('addCancelbackgrnd');
        $A.util.removeClass(backDrop, 'slds-hide');
        $A.util.addClass(backDrop, 'slds-show');
        $('#lookup').removeClass("slds-hide").addClass("slds-show");
        $('#addButton').removeClass("slds-hide").addClass("slds-show");
        $('#okButton').removeClass("slds-show").addClass("slds-hide");
        $('#cancelButton').removeClass("slds-show").addClass("slds-hide");
        $('#confirmContent').removeClass("slds-show").addClass("slds-hide");
        $('.twitter-typeahead').removeAttr("style");
        if(component.get("v.accountsId") === 'null'){
            $('#addButton').attr('disabled',true);
        }else{
           $('#addButton').attr('disabled',false);
        }
    },
    setAccountsId : function(component, event, helper){
        component.set("v.accountsId",component.get("v.accountsId"));
        if(component.get("v.accountsId") === 'null'){
             $('#addButton').attr('disabled',true);
        }else{
             $('#addButton').attr('disabled',false);
        }
    },
    addAccount: function(component, event, helper){
        $('#lookup').removeClass("slds-show").addClass("slds-hide");
        $('#addButton').removeClass("slds-show").addClass("slds-hide");
        $('#okButton').removeClass("slds-hide").addClass("slds-show");
        $('#cancelButton').removeClass("slds-hide").addClass("slds-show");
        $('#confirmContent').removeClass("slds-hide").addClass("slds-show");
    },
    onokayButton : function(component, event, helper){
        helper.addAccountPrograms(component, event); 
    },
    onCancelButton : function(component, event, helper){
       	helper.closePopup(component, event); 
    }
});