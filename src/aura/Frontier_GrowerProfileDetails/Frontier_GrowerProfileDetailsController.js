({   
	doInit : function(component, event, helper) {
		helper.growerProfile(component, event, helper);
	},
    fetchSeasonData : function(component, event, helper) {
		helper.growerProfile(component, event, helper);
	},
    
    //Mobile View
    toggleCrops : function(cmp,event,helper){
        var targetObjId=event.target.id;
        if(targetObjId === ''){
            targetObjId = event.target.parentElement.id;
            if(targetObjId === '' || (targetObjId.length === 0)){
                targetObjId = event.target.parentElement.parentElement.id;
                if(targetObjId === '' || (targetObjId.length === 0)){
                    targetObjId = event.target.parentElement.parentElement.parentElement.id;
                    if(targetObjId === '' || (targetObjId.length === 0)){
                        targetObjId = event.target.parentElement.parentElement.parentElement.parentElement.id;
                        if(targetObjId === '' || (targetObjId.length === 0)){
                            targetObjId = event.target.parentElement.parentElement.parentElement.parentElement.parentElement.id;
                        }
                    }
                }
            }
        }
        if(!document.getElementById('panel-'+targetObjId).classList.contains("slidedown")){
            /*$A.util.addClass(cmp.find('slidedown'+targetObjId), 'slds-hide');
            $A.util.removeClass(cmp.find('slidedown'+targetObjId), 'slds-show');
            $A.util.addClass(cmp.find('slideup'+targetObjId), 'slds-show')
            $A.util.removeClass(cmp.find('slideup'+targetObjId), 'slds-hide')*/
            document.getElementById(targetObjId).childNodes[0].classList = 'slds-hide';
            document.getElementById(targetObjId).childNodes[1].classList = 'slds-show';
            
            document.getElementById('panel-'+targetObjId).classList = 'slidedown';
             var panel = document.getElementById('paneldiv-'+targetObjId);
        	if (panel.style.maxHeight){
                panel.style.maxHeight = null;
       		} else {
          		panel.style.maxHeight ="114px"; //panel.scrollHeight
                panel.style.padding = '3%';
            } 
        } else{
          	/*$A.util.addClass(cmp.find('slidedown'+targetObjId), 'slds-show');
            $A.util.removeClass(cmp.find('slidedown'+targetObjId), 'slds-hide');
            $A.util.addClass(cmp.find('slideup'+targetObjId), 'slds-hide');
            $A.util.removeClass(cmp.find('slideup'+targetObjId), 'slds-show');*/
            document.getElementById('panel-'+targetObjId).classList = 'slideup';
            document.getElementById(targetObjId).childNodes[0].classList = 'slds-show';
            document.getElementById(targetObjId).childNodes[1].classList = 'slds-hide';
            //document.getElementById('slidedown'+targetObjId).classList = 'slds-show';
            //document.getElementById('slideup'+targetObjId).classList = 'slds-hide';
        }

    },
    navigateToDealerAccount : function(component, event, helper) {
        /*var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:Frontier_AccountDetailViewComponent",
                componentAttributes: {
                    accId: (event.target.id).split(',')[0],
                	sapId: (event.target.id).split(',')[1],
                	accCommunicationId: (event.target.id).split(',')[2]
                }
            });
            evt.fire();*/
        
         /*$A.createComponent(
            "c:Frontier_AccountDetailViewComponent",
            {
                accId: (event.target.id).split(',')[0],
              	sapId: (event.target.id).split(',')[1],
                accCommunicationId: (event.target.id).split(',')[2]
            },
            function(newCmp){
                var cmp = component.find("DealerDetail");
                //cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );*/
        
        var cmpEvent = component.getEvent("redirectToDealerDetail");
        cmpEvent.setParams({
            "accIdSapIdAccCommId" : event.target.id,
            "tabScopeNo" : '1',
            "componentName":"c:Frontier_DealerDetail_MasterComponent",
            "businessRole": "Partner"
        });
        cmpEvent.fire();
    },
    
    navigateToDealerList : function(component,event,helper){
        var cmpEvent = component.getEvent("redirectToDelaerList");
        console.log('GrowerProfileDetail=>'+component.get("v.growerId"));
        cmpEvent.setParams({
            "accountId" : component.get("v.growerId"),
        });
        cmpEvent.fire();
    },
})