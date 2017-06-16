trigger UpdateDealerOrGrower on Account_Business_Role__c (after insert, after update,after delete) {
    Set<Id> accountIds = new Set<Id>();
    Set<Id> businessaccountIds = new Set<Id>();
    List<Account> accountsList = new List<Account>();
   List<Account> listAccount = new List<Account>();

    Map<Id, List<Account_Business_Role__c>> mapAccount = new Map<Id, List<Account_Business_Role__c>>();
    Map<Id,String> accDealerGrowerMap = new Map<Id,String>();
    if(Trigger.isInsert || Trigger.isUpdate){
    for(Account_Business_Role__c accBusiness : Trigger.New)
    {
            accountIds.add(accBusiness.Account_SFID__c);
    }
    }
    if(Trigger.isDelete){
      for(Account_Business_Role__c accBusiness : Trigger.Old)
    {
            accountIds.add(accBusiness.Account_SFID__c);
    }  
    }
    for(Account_Business_Role__c accBusiness : [SELECT Id,Account_SFID__c,Role_Descr__c FROM Account_Business_Role__c WHERE Account_SFID__c=:accountIds])
    {
        system.debug('accBusiness'+accBusiness);
        if(accBusiness.Account_SFID__c != null)
        {
            businessaccountIds.add(accBusiness.Id);
            if(!mapAccount.containsKey(accBusiness.Account_SFID__c)){
                mapAccount.put(accBusiness.Account_SFID__c,new List<Account_Business_Role__c>{accBusiness});
                
                }
               
            else{
               mapAccount.get(accBusiness.Account_SFID__c).add(accBusiness);
                
               
            }
        }
    }
    List<Account_Business_Role__c> accbussinessList = new List<Account_Business_Role__c>();
    for(Id accId :mapAccount.keySet()){
       accbussinessList.addAll(mapAccount.get(accId));
       system.debug('accbussinessList'+accbussinessList);
        if(accbussinessList.size() > 1){
            listAccount.add(new Account(id=accId,Dealer_Grower__c='Both'));
        }
        else if((mapAccount.get(accId))[0].Role_Descr__c == 'Customer'){
            listAccount.add(new Account(id=accId,Dealer_Grower__c='Grower'));
        }
        else{
            listAccount.add(new Account(id=accId,Dealer_Grower__c='Dealer'));
        }
    }
    if(!listAccount.isEmpty()){
        
       update listAccount; 
    }
   
    
}