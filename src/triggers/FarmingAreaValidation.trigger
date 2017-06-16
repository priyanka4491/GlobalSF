trigger FarmingAreaValidation on Account_Farming_Area__c (before insert, before update) {
    //Trigger on and off through custom setting Trigger Control.
    TriggerControl__c farmingTrigger = TriggerControl__c.getValues('Trigger: FarmingAreaValidation');
    Map<Id,Account_Farming_Area__c> OldMap = new Map<Id,Account_Farming_Area__c>();
    //Execute only if Execute Trigger is True.
    if(farmingTrigger.Execute_Trigger__c) {
        if(Trigger.isBefore){        
            if(Trigger.isInsert){
                FarmingAreaValidationTriggerHandler.onBeforeInsertOrUpdate(Trigger.new, 'isInsert',OldMap);
            }
            if(Trigger.isUpdate){
                FarmingAreaValidationTriggerHandler.onBeforeInsertOrUpdate(Trigger.new,'isUpdate',Trigger.OldMap);
            }
        }
    }
}