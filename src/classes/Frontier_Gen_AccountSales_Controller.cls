public with sharing class Frontier_Gen_AccountSales_Controller { 
    
    @AuraEnabled
    public static String updateCYTarget(String CYTarget)
    {
        System.debug('received value');
        return 'Success';
    }
    
    @AuraEnabled 
    public static String getAccountSalesDetails(Id recordId, String accountType)
    {   
        String accountSalesDetails;
        if(accountType == 'Dealer')
        {
        	accountSalesDetails = getDealerAccountDetails(recordId, accountType);    
        }        
        System.debug('accountSalesDetails'+accountSalesDetails);
        return accountSalesDetails; 
    }
    //This method retrives Account Communication Details
    @AuraEnabled 
    public static String getDealerAccountDetails (Id recordId, String accountType)
    {        
        Id accountId = recordId;
        Account accountRecord = [SELECT Id, Name From Account Where Id =: accountId];
        Integer currentYear = System.Today().year();
        List<Account_Sales__c> accSales = new List<Account_Sales__c>();
        accSales = [SELECT Id, Name, Account_SFID__c, Account_Business_Role_SFID__c, Brand_Name__c, Business_Unit_Descr__c,
                   Crop__c, Net_Sales_Qty__c, Selling_Season_Descr__c, Unit_Of_Measure__c, Year__c, Year_Type__c
                   From Account_Sales__c 
                   Where Account_SFID__c =: accountId 
                   AND Selling_Season_Descr__c = 'SUMMER'
                   AND Account_Business_Role_SFID__r.Role_Descr__c = 'Partner'
                   AND Account_Business_Role_SFID__r.Role_Category_Descr__c = 'Intermediary'];
        
        map<Id, Double> mapCYSales = new map<Id, Double>();
        map<Id, Double> mapPYSales = new map<Id, Double>();    
        map<Id, Double> map2PYSales = new map<Id, Double>();
        
        for(Account_Sales__c acSal : accSales)
        {
            if(acSal.Selling_Season_Descr__c != null && acSal.Selling_Season_Descr__c == 'SUMMER')
            {
                if(acSal.Year__c == String.valueOf(currentYear))
                {
                    if(!mapCYSales.containsKey(acSal.Id))
                    {
                        mapCYSales.put(acSal.Id, acSal.Net_Sales_Qty__c);
                    }else if(mapCYSales.containsKey(acSal.Id))
                    {
                        mapCYSales.put(acSal.Id, mapCYSales.get(acSal.Id)+acSal.Net_Sales_Qty__c);
                    }
                    System.debug('mapCYSales'+mapCYSales.values());
                }
                if(acSal.Year__c == String.valueOf(currentYear - 1))
                {
                    if(!mapPYSales.containsKey(acSal.Id))
                    {
                        mapPYSales.put(acSal.Id, acSal.Net_Sales_Qty__c);
                    }else if(mapPYSales.containsKey(acSal.Id))
                    {
                        mapPYSales.put(acSal.Id, mapPYSales.get(acSal.Id)+acSal.Net_Sales_Qty__c);
                    }
                    System.debug('mapPYSales'+mapPYSales.values());
                }
                if(acSal.Year__c == String.valueOf(currentYear - 2))
                {
                    if(!map2PYSales.containsKey(acSal.Id))
                    {
                        map2PYSales.put(acSal.Id, acSal.Net_Sales_Qty__c);
                    }else if(map2PYSales.containsKey(acSal.Id))
                    {
                        map2PYSales.put(acSal.Id, map2PYSales.get(acSal.Id)+acSal.Net_Sales_Qty__c);
                    }
                    System.debug('map2PYSales'+map2PYSales.values());
                }
            }
        }
        
        List<Account_Program__c> accPrograms = new List<Account_Program__c>();
        accPrograms = [Select Id, Name, Account_SFID__c, Planning_Status__c, Execution_Status__c, Submitted__c, Service_Level_Class_Descr__c 
                       From Account_Program__c where Account_SFID__c =: accountId Limit 1];
        
        AccountSalesDataWrapper accountSalesData = new AccountSalesDataWrapper();
        accountSalesData.CYSales = String.valueOf(mapCYSales.values()) != null ? String.valueOf(mapCYSales.values()) : 'NA';
        accountSalesData.PYSales = String.valueOf(mapPYSales.values()) != null ? String.valueOf(mapPYSales.values()) : 'NA';
        accountSalesData.twoPYSales = String.valueOf(map2PYSales.values()) != null ? String.valueOf(map2PYSales.values()) : 'NA';
        accountSalesData.AccountStatus = !accPrograms.isEmpty() ? accPrograms[0].Planning_Status__c != null ? accPrograms[0].Planning_Status__c : '' : 'Not Planned';
        
        return JSON.serialize(accountSalesData);
    }
        class AccountSalesDataWrapper{
            public String CYSales {get;set;}
            public String PYSales {get;set;}
            public String twoPYSales {get;set;}
            public String AccountStatus {get;set;}
        }        
    }