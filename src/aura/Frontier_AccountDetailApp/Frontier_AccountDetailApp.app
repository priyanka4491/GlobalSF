<aura:application access="global" >
       <ltng:require styles="{!$Resource.SLDS +
                          '/assets/styles/salesforce-lightning-design-system.css'}"/>
   <aura:attribute name="myOptions" type="SelectItem[]" access="Global" />
   <aura:handler name="init" value="{!this}" action="{!c.doInit}"/>
   <!--<aura:handler name="SelectChange" event="c:SelectChange" action="{!c.handleSelectChangeEvent}"/>-->

	
    <div class="slds-form-element">
        <label class="slds-form-element__label" for="my-multi-select">Multi Select!!</label>
        <div class="slds-form-element__control" aura:id="mul-select">
        </div>
    </div>
</aura:application>