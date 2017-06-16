public class Frontier_DealerAccountList{

    public static Map<Id,Map<String,Integer>> accIdAndMapFicialYearAndNetsaleMap = new Map<Id,Map<String,Integer>>();

    public static String getAccounts(String dealerOrGrowerIdentity){
    
        /*
            dealerOrGrowerIdentity = Partner (Dealer Accounts)
            dealerOrGrowerIdentity = Customer (Grower Accounts)
        */
         List<Account_Business_Role__c> accountRecordsList = new List<Account_Business_Role__c>();
         Set<Id> territoryaccIdSet = new Set<Id>();
         Set<Id> accIdSet = new Set<Id>();
         
         //Get Accounts of current user's territory from Util
         territoryaccIdSet = Util.getTerritoryAccountIds(); 
         
         accountRecordsList= [SELECT id,Account_SFID__c,Account_SFID__r.Name,Service_Level_Class_Descr__c,                                
                                                                Role_Descr__c,Business_Unit_Descr__c,Account_SFID__r.Account_Global_Party_ID__c, 
                                                                (SELECT Source_System_ID__c FROM Account_Identifiers__r LIMIT 1),
                                                                (SELECT Parent_SFID__r.Parent_SFID__r.Id,Parent_SFID__r.Parent_SFID__r.Street_Addr__c,Parent_SFID__r.Parent_SFID__r.City_Name__c,      
                                                                Parent_SFID__r.Parent_SFID__r.State_Name__c,Parent_SFID__r.Parent_SFID__r.Country_Name__c,   
                                                                Parent_SFID__r.Role_Descr__c FROM Account_Communications__r 
                                                                WHERE   Archive_Ind__c = 'N' AND  Parent_SFID__r.Archive_Ind__c = 'N' AND   Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                                                                AND   RecordType.DeveloperName = 'Account_Communication_Address_Role_Business_Role' AND  Parent_SFID__r.Role_Descr__c = 'Business'
                                                                LIMIT 1)
                                                                FROM  Account_Business_Role__c
                                                                WHERE Archive_Ind__c = 'N'
                                                                AND   Account_SFID__r.Account_Global_Party_ID__c != null
                                                                AND   Account_SFID__r.Archive_Ind__c = 'N'
                                                                AND   Account_SFID__c IN : territoryaccIdSet
                                                                AND   Role_Descr__c = :dealerOrGrowerIdentity Limit 10];
                                                                
         for(Account_Business_Role__c abr : accountRecordsList){
             accIdSet.add(abr.Account_SFID__c);
         }
         Integer currentYear = System.Today().Year();
         for(Account_Sales__c accSales : [SELECT Year__c,Net_Sales_Qty__c,Account_SFID__c FROM Account_Sales__c WHERE Account_SFID__c IN :accIdSet ]){
             if(String.valueOf(currentYear) == accSales.Year__c || String.valueOf(currentYear-1) == accSales.Year__c || String.valueOf(currentYear-2) == accSales.Year__c){
                 /*  currentYear = CY  *  currentYear-1 = PY  *  currentYear-2 = 2PY  */
                 if(!accIdAndMapFicialYearAndNetsaleMap.containsKey(accSales.Account_SFID__c)){
                     Map<String,Integer> tempMap = new Map<String,Integer>();
                     tempMap.put(accSales.Year__c,Integer.valueOf(accSales.Net_Sales_Qty__c));
                     accIdAndMapFicialYearAndNetsaleMap.put(accSales.Account_SFID__c,tempMap);
                 }else{
                     if(!accIdAndMapFicialYearAndNetsaleMap.get(accSales.Account_SFID__c).containsKey(accSales.Year__c)){
                          Map<String,Integer> tempMap = new Map<String,Integer>();
                          tempMap.put(accSales.Year__c,Integer.valueOf(accSales.Year__c)); 
                          accIdAndMapFicialYearAndNetsaleMap.get(accSales.Account_SFID__c).put(accSales.Year__c,Integer.valueOf(accSales.Net_Sales_Qty__c));       
                     }else{
                         Integer netSale = accIdAndMapFicialYearAndNetsaleMap.get(accSales.Account_SFID__c).get(accSales.Year__c);
                          accIdAndMapFicialYearAndNetsaleMap.get(accSales.Account_SFID__c).put(accSales.Year__c,Integer.valueOf(accSales.Net_Sales_Qty__c)+netSale);       
                     }    
                 
                 }
             }
         
         }
                                                                
          return Null;

    
    }
    
    Public class AccountWrapper{
        public String Role {get;set;}
        public String AccountName {get;set;}
        public String Address {get;set;}
        public String PY2Sales {get;set;}
        public string PYSales {get;set;}
        public string CYSales {get;set;}
    
    
    }


}