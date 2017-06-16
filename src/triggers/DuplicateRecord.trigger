trigger DuplicateRecord on Account_org_relationship__c (before insert, before update){  

set<id> businessRoleIds = new Set<id>(); 
set<string> businessRoleIdCombination = new Set<string>();
for(Account_org_relationship__c  recAccountOrg : Trigger.new){
    businessRoleIds.add(recAccountOrg.Parent_Acct_Bus_Role_SFID__c);
    businessRoleIds.add(recAccountOrg.Child_Acct_Bus_Role_SFID__c);
}

List<Account_org_relationship__c > accOrgList = [Select id,name,Parent_Acct_Bus_Role_SFID__c, Child_Acct_Bus_Role_SFID__c from Account_org_relationship__c where Parent_Acct_Bus_Role_SFID__c In:businessRoleIds or Child_Acct_Bus_Role_SFID__c In: businessRoleIds];

for(Account_org_relationship__c recAccOrg : accOrgList){
    businessRoleIdCombination.add(recAccOrg.Parent_Acct_Bus_Role_SFID__c+'~~'+recAccOrg.Child_Acct_Bus_Role_SFID__c);
    businessRoleIdCombination.add(recAccOrg.Child_Acct_Bus_Role_SFID__c+'~~'+recAccOrg.Parent_Acct_Bus_Role_SFID__c);
}
for (Account_org_relationship__c ct : Trigger.new)
  {      
  if(businessRoleIdCombination.contains(ct.Parent_Acct_Bus_Role_SFID__c+'~~'+ct.Child_Acct_Bus_Role_SFID__c) || businessRoleIdCombination.contains(ct.Child_Acct_Bus_Role_SFID__c+'~~'+ct.Parent_Acct_Bus_Role_SFID__c)){
    ct.adderror('Duplicate record exists with this combination');
  }
}
}