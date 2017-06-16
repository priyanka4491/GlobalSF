trigger Frontier_UpdateBusinessRoleOnRelationship on Account_Org_Relationship__c (before insert) {
Set<Id> AccIds = new Set<Id>();
for(Account_Org_Relationship__c recAccOrg: Trigger.new){
AccIds.add(recAccOrg.Child_Account_SFID__c);
}
List<Account_Business_Role__c> Abr = [select id, Account_SFID__c from Account_Business_Role__c where Account_SFID__c in :AccIds and Role_Descr__c = 'Partner'];
Map<Id,Id> Acc_abrId = new Map<Id,Id>();
for(Account_Business_Role__c recAccAbr: Abr){
Acc_abrId.put(recAccAbr.Account_SFID__c, recAccAbr.Id);
}
for(Account_Org_Relationship__c recAccOrg: Trigger.new){
if(Acc_abrId.containskey(recAccOrg.Child_Account_SFID__c)){
recAccOrg.Child_Acct_Bus_Role_SFID__c = Acc_abrId.get(recAccOrg.Child_Account_SFID__c);
}
}
}