({
	
    doInit : function(component, event, helper){
        if(component.get("v.handlerName") === 'activityView'){          	
            helper.navigateToTabComponents(component,event,"c:Frontier_GrowerAccount_Program","tab-scoped-2");
            helper.toggleSelectedTabs(component,event,helper,2);            
        }else{
            helper.navigateToTabComponents(component,event,"c:Frontier_GrowerAccount_MasterComponent","tab-scoped-1");            
        }
    },
    toggleTabs : function(component, event, helper) {
        var accProgramDetails  = component.get("v.growerAcc");
        var accDet = component.get("v.accountAddressInfo");
        console.log("accDet"+accDet);
        if(accProgramDetails.split(',')[3]){
            component.set("v.growerAcc",accProgramDetails.split(',')[0]+','+accProgramDetails.split(',')[1]+','+accProgramDetails.split(',')[2])
        }
        else if(accProgramDetails.split('/')[1]){
            component.set("v.growerAcc",accProgramDetails.split('/')[1])
        }
		//alert((event.target.id).substring(0,(event.target.id).indexOf('_')));
		//alert((event.target.id).substring((event.target.id).indexOf('___')+3,(event.target.id).lastIndexOf('___')));
        var compName =(event.target.id).substring((event.target.id).indexOf('___')+3,(event.target.id).lastIndexOf('___'));
        var tabScoped = (event.target.id).substring(0,(event.target.id).indexOf('_')); 
        var i;
        for(i=1;i<=5;i++){
            //alert(component.find('tab-scoped-'+i+'_tab'))
             $A.util.removeClass( component.find('tab-scoped-'+i+'_tab'),'slds-active');
             $A.util.removeClass( component.find('tab-scoped-'+i+'_tab'),'active');
             $A.util.removeClass( component.find('tab-scoped-'+i),'slds-show');
             $A.util.addClass( component.find('tab-scoped-'+i),'slds-hide');
             //$A.util.addClass( component.find('tab-scoped-'+i),'slds-show');
             $A.util.removeClass( component.find('tab-scoped-'+i+'__item'),'activeFont');
             $A.util.addClass( component.find('tab-scoped-'+i+'__item'),'inactiveFont');
        }
        //$A.util.addClass( component.find((event.target.id).substring(0,(event.target.id).indexOf('_'))+'_tab'),'slds-active');
        $A.util.removeClass( component.find((event.target.id).substring(0,(event.target.id).indexOf('_'))),'slds-hide');
        $A.util.addClass( component.find((event.target.id).substring(0,(event.target.id).indexOf('_'))),'slds-show');
        $A.util.removeClass( component.find((event.target.id).substring(0,(event.target.id).indexOf('_'))+'__item'),'inactiveFont');
        $A.util.addClass( component.find((event.target.id).substring(0,(event.target.id).indexOf('_'))+'__item'),'activeFont');
        $A.util.addClass( component.find((event.target.id).substring(0,(event.target.id).indexOf('_'))+'_tab'),'active');
        if(compName !== 'ta'){
            helper.navigateToTabComponents(component,event,compName,tabScoped);
        }

	},
     navigateToDealerDetail : function (component,event,helper) {
         
        console.log(event.getParam("businessRole"));
        if(event.getParam("componentName") === 'c:Frontier_DealerDetail_MasterComponent' && event.getParam("tabScopeNo") === '1' ){
        	component.set("v.role",event.getParam("businessRole"));
        }
        component.set("v.growerAcc",event.getParam("accIdSapIdAccCommId"));

        helper.navigateToTabComponents(component,event,event.getParam("componentName"),"tab-scoped-"+event.getParam("tabScopeNo"));
         
       	helper.toggleSelectedTabs(component,event,helper,event.getParam("tabScopeNo"));
        
     },
    showSpinner : function (component) {
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, "xc-hidden");
    },
    hideSpinner : function (component) {
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, "xc-hidden");
    },
     navigateToProgramPlanning:function(component,event,helper){ 
        var dealerAccDetail = component.get("v.growerAcc");
        var dealerAccId = dealerAccDetail.split(',')[0];  
         $A.createComponent(
            "c:Frontier_ProgramPlanning",
            {              
                dealerId  : dealerAccId
            },
            function(newCmp){
                var cmp = component.find("programBlock");
                cmp.set("v.body",[]);
                cmp.set("v.body", newCmp);	
            }
        );
       
    },
})