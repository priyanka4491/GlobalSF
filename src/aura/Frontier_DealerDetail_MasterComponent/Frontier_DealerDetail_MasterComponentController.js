({
	doinit : function(component, event, helper) {
        helper.navigateToDealerDetails(component, event);
        helper.getGrowerCount(component, event);
        var formFactor = $A.get("$Browser.formFactor");
        var charSection = component.find("chartSection");
        var touchPointSection = component.find("touchPointSection");
        if(formFactor === 'PHONE'){
            $A.util.addClass(charSection, 'slds-wrap');
            $A.util.addClass(touchPointSection, 'slds-wrap');
        }
        else {
            $A.util.removeClass(charSection, 'slds-wrap');
            $A.util.removeClass(touchPointSection, 'slds-wrap');
        }		
    },
    groweraccNavigation : function(component,event,helper){
        helper.toGrowerCount(component,event);
    /*
      
              <div class="slds-grid slds-grid--vertical-stretch">    
                <div class="slds-p-horizontal--small slds-size--1-of-1">
                        <div aura:id="touchPointSection" class="slds-grid slds-grid--pull-padded">
                            <div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--6-of-12 dealer-grid">
                               <<c:Frontier_DealerDetail_RecordTouchPoint ></c:Frontier_DealerDetail_RecordTouchPoint>
                            </div>
                            <div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--6-of-12 dealer-grid">
                                <c:Frontier_DealerAccountDetail_RecentTouchPoint ></c:Frontier_DealerAccountDetail_RecentTouchPoint>
                            </div>
                        </div>
                  </div>
               </div>
               
     */
     },
    
})