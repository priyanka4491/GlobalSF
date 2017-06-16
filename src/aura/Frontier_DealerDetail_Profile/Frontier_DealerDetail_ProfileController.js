({
	doInit : function(component, event, helper) {
		helper.dealerProfile(component, event, helper);
	},
    fetchSeasonData : function(component, event, helper) {
		helper.dealerProfile(component, event, helper);
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
          		panel.style.maxHeight ="100px"; //panel.scrollHeight
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
    navigateToGrowerList : function(component,event,helper){
        var cmpEvent = component.getEvent("redirectToGrowerList");
        cmpEvent.setParams({
            "accountId" : component.get("v.dealerId"),
        });
        cmpEvent.fire();
    },
    navigateToProgramPlanning:function(component,event,helper){ 
        var appEvent = $A.get("e.c:Frontier_DealerDetailEvent");
        appEvent.setParams({ "dealerId" : component.get("v.dealerId") });
       appEvent.fire();
                
       
    },
  /*  groweraccNavigation : function(component,event,helper){
        $A.createComponent("c:Frontier_GrowerAccountList",
                           {label : ""},
                           function(GrowerList){
                               console.log('AccountList');
                               var comp = component.find("growerList");
                               comp.set("v.body",GrowerList);
                           }
    }*/
})