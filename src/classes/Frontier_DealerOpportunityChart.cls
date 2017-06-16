public class Frontier_DealerOpportunityChart {
	@AuraEnabled    
    public static String getdealerOpportunity(Id dealerAccId){
        System.debug('Inside apex');
        List<Account_Sales__c> accSalesList = new List<Account_Sales__c>();
        AccountDataWrapper accountData = new AccountDataWrapper();
        //Set<String> seasonSet = new Set<String>{'2017 Safra','2016 Safra','2015 Safra'};
        String Crop = 'Corn';
        String queryString= 'Select Id,Name,Account_SFID__c,Net_Sales_Qty__c,Year__c,Order_Qty__c,Budget__c,Opportunity__c From Account_Sales__c where Account_SFID__c=:dealerAccId AND Crop__c=:crop';  
        accSalesList =Database.query(queryString);
        System.debug('accSalesList' + accSalesList);
        if(!accSalesList.isEmpty()){
        for(Account_Sales__c accSales :accSalesList){
          accountData.SalesYearMap.put(accSales.Year__c,accSales.Net_Sales_Qty__c) ;
          accountData.OpportunityYearMap.put(accSales.Year__c,accSales.Opportunity__c) ;
          accountData.BudgetYearMap.put(accSales.Year__c,accSales.Budget__c) ;
        }
        }
        System.debug('SalesYearMap' +accountData.SalesYearMap +accountData.OpportunityYearMap);
        return JSON.serialize(accountData);
        
        
    }
    
     public class AccountDataWrapper{
        public  Map<String,Decimal> SalesYearMap{get;set;}
        public  Map<String,Decimal> OpportunityYearMap{get;set;}
        public Map<String,Decimal> BudgetYearMap{get;set;}
         public AccountDataWrapper(){
            SalesYearMap=new Map<String,Decimal>();
            OpportunityYearMap=new Map<String,Decimal>();
             BudgetYearMap=new Map<String,Decimal>();
        }
     }
}