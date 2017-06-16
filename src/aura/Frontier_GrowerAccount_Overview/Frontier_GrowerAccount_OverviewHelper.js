({
	navigateToTabComponents : function(component,event,compName,tabScoped) {
        //alert( component.get("v.role"));
        if(component.get("v.role") === 'Partner' && tabScoped === 'tab-scoped-1'){
            compName = "c:Frontier_DealerDetail_MasterComponent";
            component.set("v.heading", 'dealer');
        }
        $A.createComponent(compName,
                           { "growerAcc":component.get("v.growerAcc"),
                             "role": component.get("v.role")								                            
                           },
                           function(tabComponents){
                               console.log('Inside Dynamic creation');
                               var comp = component.find(tabScoped);
                               comp.set("v.body",tabComponents);
                               console.log(compName);                                       
                           }
                          );
	},
    
    toggleSelectedTabs : function(component,event,helper,tabScopeNo){
        var i;
        for(i=1;i<=4;i++){
            //alert(component.find('tab-scoped-'+i+'_tab'))
            $A.util.removeClass( component.find('tab-scoped-'+i+'_tab'),'slds-active');
            $A.util.removeClass( component.find('tab-scoped-'+i+'_tab'),'active');
            $A.util.removeClass( component.find('tab-scoped-'+i),'slds-show');
            $A.util.addClass( component.find('tab-scoped-'+i),'slds-hide');
            //$A.util.addClass( component.find('tab-scoped-'+i),'slds-show');
            $A.util.removeClass( component.find('tab-scoped-'+i+'__item'),'activeFont');
            $A.util.addClass( component.find('tab-scoped-'+i+'__item'),'inactiveFont');
        }
        $A.util.addClass( component.find('tab-scoped-'+tabScopeNo+'_tab'),'slds-active');
        $A.util.addClass( component.find('tab-scoped-'+tabScopeNo+'_tab'),'active');
        $A.util.addClass( component.find('tab-scoped-'+tabScopeNo+''),'slds-show');
        $A.util.removeClass( component.find('tab-scoped-'+tabScopeNo+''),'slds-hide');
        $A.util.addClass( component.find('tab-scoped-'+tabScopeNo+'__item'),'activeFont');
        $A.util.removeClass( component.find('tab-scoped-'+tabScopeNo+'__item'),'inactiveFont');
    }
})