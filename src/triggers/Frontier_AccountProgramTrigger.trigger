trigger Frontier_AccountProgramTrigger on Account_Program__c (after update,after delete) {
    TriggerControl__c triggerControl = TriggerControl__c.getValues('Trigger:AccountProgramTrigger');
    if(triggerControl.Execute_Trigger__c){
        if(Trigger.isAfter){    
            if(Trigger.isUpdate || Trigger.isDelete){
           			Frontier_AccountProgramClass.AssociateProgramActivities((Trigger.isUpdate?Trigger.New:(Trigger.isDelete ?Trigger.Old:Trigger.New)),Trigger.oldMap,(Trigger.isUpdate?'isUpdate':(Trigger.isDelete ?'isDelete':'')));
            }	
        }
    }
}