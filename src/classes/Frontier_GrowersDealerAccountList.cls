public with sharing class Frontier_GrowersDealerAccountList { 
    public static Map<Id,Integer> growerAccountMap = new Map<Id,Integer>();
     
    @AuraEnabled    
    public static List<String> getDealerAccounts(String searchKey,Integer pageSize,Integer pageNumber, Id accId) {
        System.debug('SearchKey========>'+searchKey+'===PageSize===>'+pageSize+'===pageNumber======>'+pageNumber+'===account Id====>'+accId);
        growerAccountMap.clear();
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);        
        List<AccountWrapper> accountListAfterSkip=new List<AccountWrapper>();
        List<String> accountList= new List<String>();        
        Set<Id> dealerAccountIdSet = new Set<Id>();
        Set<Id> dealerAccountABSIdSet = new Set<Id>();
        Set<Id> dealerAccountPerpageIdSet = new Set<Id>();
        Set<Id> dealerAccountABSPerPageIdSet = new Set<Id>();
        string varsearchKey='%'+searchKey+'%'; 
        Integer count = 0;  
        Set<Id> territoryaccIdSet = new Set<Id>();
        
        //Get Accounts of current user's territory from Util
        territoryaccIdSet = Util.getTerritoryAccountIds();
        try{
            
            List<Account_Org_Relationship__c> listDealerAccounts = new List<Account_Org_Relationship__c>(); 
            //Getting Grower's specific Dealers
            listDealerAccounts = [SELECT Id, Parent_Account_SFID__c, Parent_Acct_Bus_Role_SFID__c, Child_Account_SFID__c, Parent_Account_SFID__r.Account_Global_Party_ID__c,  
                                      Child_Account_SFID__r.Account_Global_Party_ID__c,Child_Acct_Bus_Role_SFID__c, HC_Integration_Key__c, Archive_Date__c, Archive_Ind__c
                                      FROM Account_Org_Relationship__c WHERE Parent_Account_SFID__c IN :territoryaccIdSet  AND Parent_Account_SFID__r.Account_Global_Party_ID__c != null
                                                                             AND Child_Account_SFID__r.Account_Global_Party_ID__c != null AND Child_Account_SFID__c = :accId
                                 									         AND Parent_Acct_Bus_Role_SFID__r.Role_Descr__c = 'Partner'

                                 ];
            System.debug('listDealerAccounts=>'+listDealerAccounts );
            for(Account_Org_Relationship__c accOrg : listDealerAccounts )
            {
                if(accOrg.Parent_Account_SFID__c != null && accOrg.Parent_Acct_Bus_Role_SFID__c != null)
                {
                    dealerAccountIdSet.add(accOrg.Parent_Account_SFID__c);
                    dealerAccountABSIdSet.add(accOrg.Parent_Acct_Bus_Role_SFID__c);
                }
            }
            List<Account_Business_Role__c> accountRecordsList= [SELECT id,Account_SFID__c,Account_SFID__r.Name,Service_Level_Class_Descr__c,Account_SFID__r.Account_Global_Party_ID__c,                                
                                                                Role_Descr__c,Business_Unit_Descr__c, RecordType.DeveloperName,
                                                                (SELECT Source_System_ID__c FROM Account_Identifiers__r LIMIT 1),
                                                                (SELECT Parent_SFID__r.Parent_SFID__r.Id,Parent_SFID__r.Parent_SFID__r.Street_Addr__c,Parent_SFID__r.Parent_SFID__r.City_Name__c,      
                                                                Parent_SFID__r.Parent_SFID__r.State_Name__c,Parent_SFID__r.Parent_SFID__r.Country_Name__c,   
                                                                 Parent_SFID__r.Role_Descr__c FROM Account_Communications__r 
                                                                 WHERE   Archive_Ind__c = 'N' AND  Parent_SFID__r.Archive_Ind__c = 'N' AND   Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                                                                 AND   RecordType.DeveloperName = 'Account_Communication_Address_Role_Business_Role' AND  Parent_SFID__r.Role_Descr__c = 'Business'
                                                                 LIMIT 1)
                                                                FROM  Account_Business_Role__c
                                                                WHERE Archive_Ind__c = 'N'
                                                                AND Account_SFID__r.Account_Global_Party_ID__c != null
                                                                AND Account_SFID__r.Archive_Ind__c = 'N'
                                                                AND   Account_SFID__r.Name Like :varsearchKey
                                                                AND Role_Descr__c = 'Partner'
                                                                AND Account_SFID__c IN : dealerAccountIdSet LIMIT 5000];
            System.debug('accountRecordsList'+accountRecordsList);
            
            if(!accountRecordsList.isEmpty()){
                for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < accountRecordsList.size();i++){   
                    dealerAccountPerpageIdSet.add(accountRecordsList[i].Account_SFID__c);
                    dealerAccountABSPerPageIdSet.add(accountRecordsList[i].id);
                }
                //Getting Dealer Specific Grower Count
               for(Account_Org_Relationship__c growerAccount : [SELECT Id, Parent_Account_SFID__c, Parent_Acct_Bus_Role_SFID__c, Child_Account_SFID__c,Child_Account_SFID__r.Account_Global_Party_ID__c,Parent_Account_SFID__r.Account_Global_Party_ID__c, 
                                              					Child_Acct_Bus_Role_SFID__c, HC_Integration_Key__c, Archive_Date__c, Archive_Ind__c
                                              					FROM Account_Org_Relationship__c WHERE Parent_Account_SFID__c IN :dealerAccountPerpageIdSet AND Parent_Account_SFID__r.Account_Global_Party_ID__c != null
                                                                                                         AND Child_Account_SFID__r.Account_Global_Party_ID__c != null AND Child_Account_SFID__c IN :territoryaccIdSet
                                                                                                         AND Child_Acct_Bus_Role_SFID__r.Role_Descr__c = 'Customer'
                                              					]){
                        if(growerAccount.Child_Account_SFID__c != Null && growerAccount.Child_Acct_Bus_Role_SFID__c != Null){                          
                            if(!growerAccountMap.containskey(growerAccount.Parent_Account_SFID__c)){
                                count = 1;
                                growerAccountMap.put(growerAccount.Parent_Account_SFID__c ,count);
                            }
                            else{
                               growerAccountMap.put(growerAccount.Parent_Account_SFID__c ,growerAccountMap.get(growerAccount.Parent_Account_SFID__c)+1);
                            }
                        }
                    }
             }
            system.debug('growerAccountMap=>'+growerAccountMap);
            if(!accountRecordsList.isEmpty()){
                for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < accountRecordsList.size();i++){   
                    accountListAfterSkip.add(new AccountWrapper(accountRecordsList[i],growerAccountMap.get(accountRecordsList[i].Account_SFID__c)) );
                }
            }
            accountList.add((String.valueOf(accountRecordsList.size())));
            accountList.add((JSON.serialize(accountListAfterSkip)));    
        }
        catch(Exception e){
            System.debug('The following error has been occured' + e.getMessage()); 
        }

        return accountList;
    }  
    
   @AuraEnabled  
    public static List<String> sortBy(String sortbyValue,Integer pageSize,Integer pageNumber,Id accId) {
        system.debug('Account Id===========>'+accId);
        
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
        Set<Id> dealerAccountIdSet = new Set<Id>();
        Set<Id> dealerAccountABSIdSet = new Set<Id>();
        Set<Id> dealerAccountPerpageIdSet = new Set<Id>();
        Set<Id> dealerAccountABSPerPageIdSet = new Set<Id>();
        Integer count = 0;       
        String WhereCondition;
        Set<Id> territoryaccIdSet = new Set<Id>();
        
        //Get Accounts of current user's territory from Util
        territoryaccIdSet = Util.getTerritoryAccountIds();
        
        growerAccountMap.clear();
        List<Account_Org_Relationship__c> listDealerAccounts = new List<Account_Org_Relationship__c>(); 
        //Getting Grower Specific Dealers
        listDealerAccounts = [SELECT Id, Parent_Account_SFID__c, Parent_Acct_Bus_Role_SFID__c, Child_Account_SFID__c,
                                  Parent_Account_SFID__r.Account_Global_Party_ID__c, Child_Account_SFID__r.Account_Global_Party_ID__c,   
                                  Child_Acct_Bus_Role_SFID__c, HC_Integration_Key__c, Archive_Date__c, Archive_Ind__c
                                  FROM Account_Org_Relationship__c WHERE Parent_Account_SFID__c IN :territoryaccIdSet 
                                    AND Parent_Account_SFID__r.Account_Global_Party_ID__c != null
                                    AND Child_Account_SFID__r.Account_Global_Party_ID__c != null
                             		AND Child_Account_SFID__c = :accId
                                    AND Parent_Acct_Bus_Role_SFID__r.Role_Descr__c = 'Partner'
                             ];
        System.debug('listDealerAccounts=>'+listDealerAccounts );
        for(Account_Org_Relationship__c accOrg : listDealerAccounts )
        {
            if(accOrg.Parent_Account_SFID__c != null && accOrg.Parent_Account_SFID__c != null)
            {
                dealerAccountIdSet.add(accOrg.Parent_Account_SFID__c);
                dealerAccountABSIdSet.add(accOrg.Parent_Account_SFID__c);
            }
        }
        
        
        WhereCondition = ' WHERE Archive_Ind__c =\'N\''+' AND Account_SFID__r.Archive_Ind__c =\'N\''+' AND Role_Descr__c = \'Partner\' AND Account_SFID__c IN : dealerAccountIdSet';

        if(sortbyValue != null && !String.isBlank(sortbyValue)){
            WhereCondition = ' WHERE Archive_Ind__c =\'N\'' +' AND Account_SFID__r.Archive_Ind__c =\'N\''+' AND Role_Descr__c = \'Partner\' AND Account_SFID__c IN : dealerAccountIdSet '
                +' AND Account_SFID__r.Account_Global_Party_ID__c != null AND Service_Level_Class_Descr__c != null ORDER BY Service_Level_Class_Descr__c ASC';  
        }
        
        String Query = 'SELECT Account_SFID__c,Account_SFID__r.Name,Service_Level_Class_Descr__c,Account_SFID__r.Account_Global_Party_ID__c,'                                
            +'Role_Descr__c,Business_Unit_Descr__c,' 
            +'(SELECT Source_System_ID__c FROM Account_Identifiers__r LIMIT 1)'
            +' ,(SELECT Parent_SFID__r.Parent_SFID__r.Id,Parent_SFID__r.Parent_SFID__r.Street_Addr__c,Parent_SFID__r.Parent_SFID__r.City_Name__c,'      
            +'Parent_SFID__r.Parent_SFID__r.State_Name__c,Parent_SFID__r.Parent_SFID__r.Country_Name__c,'   
            +'Parent_SFID__r.Role_Descr__c FROM Account_Communications__r'
            +' WHERE   Archive_Ind__c =\'N\''+ ' AND  Parent_SFID__r.Archive_Ind__c =\'N\''+'AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c =\'N\''
            +' AND   RecordType.DeveloperName = \'Account_Communication_Address_Role_Business_Role\'' +'AND  Parent_SFID__r.Role_Descr__c = \'Business\''
            +' LIMIT 1)'
            +' FROM    Account_Business_Role__c'
            + WhereCondition;
        
        system.debug('Query to Execute::' +Query);
        
        
        List<AccountWrapper> accountListAfterSkip=new List<AccountWrapper>();
        List<String> accountList= new List<String>();
        system.debug('sortbyValue============>'+sortbyValue+'===Query to Execute=========>' +Query);
        try{
            List<Account_Business_Role__c> accountRecordsList = Database.query(Query);
            
            if(!accountRecordsList.isEmpty()){
                for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < accountRecordsList.size();i++){   
                    dealerAccountPerpageIdSet.add(accountRecordsList[i].Account_SFID__c);
                    dealerAccountABSPerPageIdSet.add(accountRecordsList[i].id);
                }
               //Getting Dealers Grower Count
               for(Account_Org_Relationship__c growerAccount : [SELECT Id, Parent_Account_SFID__c, Parent_Acct_Bus_Role_SFID__c, Child_Account_SFID__c,
                                                                  Parent_Account_SFID__r.Account_Global_Party_ID__c, Child_Account_SFID__r.Account_Global_Party_ID__c,  
                                                                  Child_Acct_Bus_Role_SFID__c, HC_Integration_Key__c, Archive_Date__c, Archive_Ind__c
                                                                FROM Account_Org_Relationship__c WHERE Parent_Account_SFID__c IN :dealerAccountPerpageIdSet
                                                                	 AND Child_Account_SFID__c IN :territoryaccIdSet
                                                                     AND Parent_Account_SFID__r.Account_Global_Party_ID__c != null
                                                                     AND Child_Account_SFID__r.Account_Global_Party_ID__c != null AND Child_Acct_Bus_Role_SFID__r.Role_Descr__c = 'Customer'
																]){
                          if(growerAccount.Child_Account_SFID__c != Null && growerAccount.Child_Account_SFID__c != Null){
                                if(!growerAccountMap.containskey(growerAccount.Parent_Account_SFID__c)){
                                    count = 1;
                                    growerAccountMap.put(growerAccount.Parent_Account_SFID__c ,count);
                                }
                                else{
                                   growerAccountMap.put(growerAccount.Parent_Account_SFID__c ,growerAccountMap.get(growerAccount.Parent_Account_SFID__c)+1);
                                }
                           }
                    }
             }
            system.debug('growerAccountMap=>'+growerAccountMap); 
            if(!accountRecordsList.isEmpty()){
                for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < accountRecordsList.size();i++){   
                    accountListAfterSkip.add(new AccountWrapper(accountRecordsList[i],growerAccountMap.get(accountRecordsList[i].Account_SFID__c)) );                }
            }
            accountList.add((String.valueOf(accountRecordsList.size())));
            accountList.add((JSON.serialize(accountListAfterSkip))); 
        }
        catch(Exception e){
            System.debug('The following error has been occured' + e.getMessage());
        }
        return accountList;
    }
   
     @AuraEnabled  
    public static List<String> sortByRADL(String sortbyValue,Integer pageSize,Integer pageNumber) {
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
        Set<Id> dealerAccountPerpageIdSet = new Set<Id>();
        Set<Id> dealerAccountABSPerPageIdSet = new Set<Id>();
        Integer count = 0;       
        String WhereCondition;
        growerAccountMap.clear();
        Set<Id> territoryaccIdSet = new Set<Id>();
        
        //Get Accounts of current user's territory from Util
        territoryaccIdSet = Util.getTerritoryAccountIds();
        
        WhereCondition = ' WHERE Archive_Ind__c =\'N\''+' AND Account_SFID__r.Archive_Ind__c =\'N\''+' AND Role_Descr__c = \'Customer\'' +' AND Role_Category_Descr__c = \'Consumer\''+' AND Business_Unit_Descr__c = \'Customer\' AND Account_SFID__c IN :territoryaccIdSet LIMIT 5000';
        if(sortbyValue != null && !String.isBlank(sortbyValue)){
            WhereCondition = ' WHERE Archive_Ind__c =\'N\'' +' AND Account_SFID__r.Archive_Ind__c =\'N\''+' AND Role_Descr__c = \'Customer\'' +' AND Role_Category_Descr__c = \'Consumer\''+' AND Business_Unit_Descr__c = \'Customer\''
                  + 'AND Account_SFID__r.Account_Global_Party_ID__c != null AND Service_Level_Class_Descr__c != null AND Account_SFID__c IN :territoryaccIdSet ORDER BY Service_Level_Class_Descr__c ASC LIMIT 5000';  
        }
       
        String Query = 'SELECT Account_SFID__c,Account_SFID__r.Name,Service_Level_Class_Descr__c,Account_SFID__r.Account_Global_Party_ID__c'                                
            +'Role_Descr__c,Business_Unit_Descr__c,' 
            +'(SELECT Source_System_ID__c FROM Account_Identifiers__r LIMIT 1)'
            +', (SELECT Parent_SFID__r.Parent_SFID__r.Id,Parent_SFID__r.Parent_SFID__r.Street_Addr__c,Parent_SFID__r.Parent_SFID__r.City_Name__c,'      
            +'Parent_SFID__r.Parent_SFID__r.State_Name__c,Parent_SFID__r.Parent_SFID__r.Country_Name__c,'   
            +'Parent_SFID__r.Role_Descr__c FROM Account_Communications__r'
            +' WHERE   Archive_Ind__c =\'N\''+ ' AND  Parent_SFID__r.Archive_Ind__c =\'N\''+' AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c =\'N\''
            +' AND   RecordType.DeveloperName = \'Account_Communication_Address_Role_Business_Role\'' +' AND  Parent_SFID__r.Role_Descr__c = \'Business\''
            +' LIMIT 1)'
            +' FROM    Account_Business_Role__c'
            + WhereCondition;
        
        
        List<AccountWrapper> accountListAfterSkip=new List<AccountWrapper>();
        List<String> accountList= new List<String>();
        system.debug('sortbyValue=========>'+sortbyValue+'======Query To Execute===>'+Query);
        try{
            List<Account_Business_Role__c> accountRecordsList = Database.query(Query);
            if(!accountRecordsList.isEmpty()){
                for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < accountRecordsList.size();i++){   
                    dealerAccountPerpageIdSet.add(accountRecordsList[i].Account_SFID__c);
                    dealerAccountABSPerPageIdSet.add(accountRecordsList[i].id);
                }
                //Getting Dealer specific Grower Count
               for(Account_Org_Relationship__c growerAccount : [SELECT Id, Parent_Account_SFID__c, Parent_Acct_Bus_Role_SFID__c, Child_Account_SFID__c,Parent_Account_SFID__r.Account_Global_Party_ID__c, 
                                              Child_Acct_Bus_Role_SFID__c, HC_Integration_Key__c, Archive_Date__c, Archive_Ind__c,Child_Account_SFID__r.Account_Global_Party_ID__c
                                              FROM Account_Org_Relationship__c WHERE Parent_Account_SFID__c IN :dealerAccountPerpageIdSet  AND Parent_Account_SFID__r.Account_Global_Party_ID__c != null
                                                                                     AND Child_Account_SFID__r.Account_Global_Party_ID__c != null
                                                                                     AND Child_Account_SFID__c IN :territoryaccIdSet
                                                                                     AND Child_Acct_Bus_Role_SFID__r.Role_Descr__c = 'Customer'
                                              ]){
                                                      if(growerAccount.Child_Account_SFID__c != Null && growerAccount.Child_Account_SFID__c != Null){
                                                                  
                                                            if(!growerAccountMap.containskey(growerAccount.Parent_Account_SFID__c)){
                                                                count = 1;
                                                                growerAccountMap.put(growerAccount.Parent_Account_SFID__c ,count);
                                                            }
                                                            else{
                                                               growerAccountMap.put(growerAccount.Parent_Account_SFID__c ,growerAccountMap.get(growerAccount.Parent_Account_SFID__c)+1);
                                                            }
                                                        }
                								}                             
             }
            system.debug('growerAccountMap=>'+growerAccountMap);                                                   
            if(!accountRecordsList.isEmpty()){
                for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < accountRecordsList.size();i++){   
                    accountListAfterSkip.add(new AccountWrapper(accountRecordsList[i],growerAccountMap.get(accountRecordsList[i].Account_SFID__c)) );                }
            }
            accountList.add((String.valueOf(accountRecordsList.size())));
            accountList.add((JSON.serialize(accountListAfterSkip))); 
        }
        catch(Exception e){
            System.debug('The following error has been occured' + e.getMessage());
        }
        return accountList;
    }
    
    Public Class AccountWrapper {      
        
        public String Name{get;set;}
        public String accId{get;set;}
        public Account_Business_Role__c accountBusinessRole {get;set;}
        
        public String serviceLevelDesc{get;set;}  
        public String roleDesc{get;set;}
        public String sapId{get;set;} 
        
        public String accCommu{get;set;}
        public String streetAddress{get;set;}
        public String cityName{get;set;}
        public String stateName{get;set;}
        public String countryName{get;set;}
        public Integer growerCount{get;set;}
        public Account_Identifier__c accountIdentifier{get;set;}        
        public Account_Communication__c accountCommunication{get;set;}
        
        public AccountWrapper(Account_Business_Role__c businessRole,Integer Count)
        {
            this.accountBusinessRole=businessRole;
            this.Name=accountBusinessRole.Account_SFID__r.Name;
            this.accId = accountBusinessRole.Account_SFID__c;            
            this.serviceLevelDesc=accountBusinessRole.Service_Level_Class_Descr__c;
            this.roleDesc=accountBusinessRole.Role_Descr__c;
            //this.sapId=accountBusinessRole.SAP_ID__C;
            this.accountIdentifier=(accountBusinessRole.Account_Identifiers__r.isEmpty() ? Null : accountBusinessRole.Account_Identifiers__r[0] );
            this.sapId=(accountBusinessRole.Account_Identifiers__r.isEmpty() ? Null : accountIdentifier.Source_System_ID__c);
            this.accountCommunication = (accountBusinessRole.Account_Communications__r.isEmpty() ? Null : accountBusinessRole.Account_Communications__r[0] );
            System.debug('accountCommunication'+accountCommunication);
            this.accCommu= (accountBusinessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.Id);
            System.debug('accCommu'+accCommu);
            this.streetAddress=(accountBusinessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.Street_Addr__c);
            this.cityName=(accountBusinessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.City_Name__c);
            this.stateName=(accountBusinessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.State_Name__c);
            this.countryName=(accountBusinessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.Country_Name__c);
            this.growerCount = Count;
        }          
    }
}