({
	doInit: function(component, event, helper) {
        
        helper.navigateToGrowerProfile(component, event);
       	helper.navigateToGrowerFarmSize(component, event);
        //helper.navigateToPreviousTouchPoint(component, event);
        helper.navigateToGrowerAccountSales(component, event);
        //helper.navigateToGrowerCharts(component, event);
        
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
    showSpinner : function (component) {
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, "xc-hidden");
    },
    hideSpinner : function (component) {
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, "xc-hidden");
    },
    
    navigateToDealerDetail : function (component,event) {
        component.set("v.growerAcc",event.getParam("accIdSapIdAccCommId"));

    	$A.createComponent(
            
            "c:Frontier_DealerDetail_MasterComponent",
            {
                growerAcc: event.getParam("accIdSapIdAccCommId"),
              	role: 'Partner'
            },
            function(newCmp){
                var cmp = component.find("dealerDetail");
                //cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );
        
        /* 
        	  <div class="slds-grid slds-grid--vertical-stretch growerAlign">    
                <div class="slds-p-horizontal--small slds-size--1-of-1">
                        <div aura:id="touchPointSection" class="slds-grid slds-grid--pull-padded">
                            <div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--4-of-12 slds-large-size--4-of-12 grower-grid">
                              <!-- <c:Frontier_GrowerAccount_RecordTouchPoint ></c:Frontier_GrowerAccount_RecordTouchPoint>-->
                                <div aura:id="GrowerRecordTouchPointSection"></div> 
                            </div>
                            <div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--4-of-12 slds-large-size--4-of-12 grower-grid grower-alignment">
                                <div aura:id="previousTouch"></div>
                                </div>
                            <div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--4-of-12 slds-large-size--4-of-12 grower-grid grower-alignment">
                               <!--<c:Frontier_GrowerAccount_TopProducts ></c:Frontier_GrowerAccount_TopProducts>-->
                            </div>
                        </div>
                  </div>
               </div>
        
        
        */
    }
})