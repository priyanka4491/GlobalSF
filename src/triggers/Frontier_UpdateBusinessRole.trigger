trigger Frontier_UpdateBusinessRole on Account_Sales__c (before insert) {
Set<Id> AccIds = new Set<Id>();
set<id> recordTypeIds = new set<id>();
    for(Account_Sales__c recAccSales: Trigger.new){
        AccIds.add(recAccSales.Account_SFID__c);
        if(recAccSales.RecordTypeId!=null)
        recordTypeIds.add(recAccSales.RecordTypeId);
    }
   
    List<Account_Business_Role__c> Abr = [select id, Account_SFID__c,Role_Descr__c from Account_Business_Role__c where Account_SFID__c in :AccIds];
    Map<Id,Id> Acc_cust_abrId = new Map<Id,Id>();
    Map<Id,Id> Acc_partner_abrId = new Map<Id,Id>();
    for(Account_Business_Role__c recAccAbr: Abr){
        if(recAccAbr.Role_Descr__c.equalsignorecase('Customer'))
            Acc_cust_abrId.put(recAccAbr.Account_SFID__c, recAccAbr.Id);
        else if(recAccAbr.Role_Descr__c.equalsignorecase('Partner'))
            Acc_partner_abrId.put(recAccAbr.Account_SFID__c, recAccAbr.Id);
    }  
 
    Map<id,recordtype> recordtypeMap = new Map<id,Recordtype>([select id,developername from RecordType where id IN:recordTypeIds]);
 
    for(Account_Sales__c recAccSales: Trigger.new){
   
        if(recAccSales.recordTypeId!=null&&recordtypeMap.containskey(recAccSales.recordtypeid)&&String.valueof(recordtypeMap.get(recAccSales.recordtypeid).Developername)=='Dealer_Sales' &&Acc_partner_abrId.containskey(recAccSales.Account_SFID__c)){
            recAccSales.Account_Business_Role_SFID__c = Acc_partner_abrId.get(recAccSales.Account_SFID__c);
        }
        else if(recAccSales.recordTypeId!=null&&recordtypeMap.containskey(recAccSales.recordtypeid)&&String.valueof(recordtypeMap.get(recAccSales.recordtypeid).Developername)=='Customer_Sales' &&Acc_cust_abrId.containskey(recAccSales.Account_SFID__c)){

            recAccSales.Account_Business_Role_SFID__c = Acc_cust_abrId.get(recAccSales.Account_SFID__c);
        }
    }
   
}