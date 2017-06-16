public with sharing class AccountListController {
   
    public static Map<Id,Integer> dealerAccountMap = new Map<Id,Integer>();
    public static Map<Id,Integer> dealergrowerAccountMap = new Map<Id,Integer>();
    
    @AuraEnabled    
    public static List<String> getAccounts(String searchKey,Integer pageSize,Integer pageNumber) {
        
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);        
        List<AccountWrapper> accountListAfterSkip=new List<AccountWrapper>();
        List<String> accountList= new List<String>();            
        List<Account_Org_Relationship__c> listGrowerAccounts = new List<Account_Org_Relationship__c>(); 
 
        Set<Id> dealerIdSet = new Set<Id>();
        Set<Id> dealerABSIdSet = new Set<Id>();
        Integer count = 0;
        string varsearchKey='%'+searchKey+'%';
        
        Set<Id> territoryaccIdSet = new Set<Id>();
        
        //Get Accounts of current user's territory from Util
        territoryaccIdSet = Util.getTerritoryAccountIds(); 
        
        try{
            List<Account_Business_Role__c> accountRecordsList= [SELECT id,Account_SFID__c,Account_SFID__r.Name,Service_Level_Class_Descr__c,                                
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
                                                                AND   Account_SFID__r.Name Like :varsearchKey
                                                                AND   Account_SFID__c IN : territoryaccIdSet
                                                                AND   Role_Descr__c = 'Partner'];
            if(!accountRecordsList.isEmpty()){
                for(Account_Business_Role__c accountBusiness : accountRecordsList){   
                    dealerIdSet.add(accountBusiness.Account_SFID__c);
                    dealerABSIdSet.add(accountBusiness.Id);
                }
            }
            
            //Getting Grower's Count 
            listGrowerAccounts = [SELECT Id, Parent_Account_SFID__c, Parent_Acct_Bus_Role_SFID__c, Child_Account_SFID__c, 
                                      	 Child_Acct_Bus_Role_SFID__c, HC_Integration_Key__c, Archive_Date__c, Archive_Ind__c,
                                  		 Parent_Account_SFID__r.Account_Global_Party_ID__c, Child_Account_SFID__r.Account_Global_Party_ID__c
                                      FROM Account_Org_Relationship__c WHERE Child_Account_SFID__c IN :territoryaccIdSet AND Child_Acct_Bus_Role_SFID__r.Role_Descr__c = 'Customer' 
                                  											 AND Parent_Account_SFID__c IN :dealerIdSet 
                                  											 AND Parent_Account_SFID__r.Account_Global_Party_ID__c != null 
                                       										 AND Child_Account_SFID__r.Account_Global_Party_ID__c != null
                                 ];
            
            for(Account_Org_Relationship__c growerAccount : listGrowerAccounts){
                if(growerAccount.Child_Account_SFID__c != Null && growerAccount.Child_Acct_Bus_Role_SFID__c != NULL){
                    if(!dealerAccountMap.containskey(growerAccount.Parent_Account_SFID__c)){
                        count = 1;
                        dealerAccountMap.put(growerAccount.Parent_Account_SFID__c,count);
                    }   
                    else if(dealerAccountMap.containsKey(growerAccount.Parent_Account_SFID__c)){
                        //count = dealerAccountMap.get(growerAccount.Child_Account_SFID__c)+1;
                        dealerAccountMap.put(growerAccount.Parent_Account_SFID__c,dealerAccountMap.get(growerAccount.Parent_Account_SFID__c)+1);
                    }
                }
            } 
           for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < accountRecordsList.size();i++){   
                accountListAfterSkip.add(new AccountWrapper(accountRecordsList[i],dealerAccountMap.get(accountRecordsList[i].Account_SFID__c)));
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
    public static List<String> sortBy(String sortbyValue,Integer pageSize,Integer pageNumber) {
        Set<Id> dealerIdSet = new Set<Id>();
        Set<Id> dealerABSIdSet = new Set<Id>();
        List<AccountWrapper> accountListAfterSkip=new List<AccountWrapper>();
        List<String> accountList= new List<String>();
        Integer count = 0;
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
        String WhereCondition;
        Set<Id> territoryaccIdSet = new Set<Id>();
        
        //Get Accounts of current user's territory from Util
        territoryaccIdSet = Util.getTerritoryAccountIds(); 
        
        WhereCondition = ' WHERE Archive_Ind__c =\'N\''+' AND Account_SFID__r.Archive_Ind__c =\'N\''+' AND Role_Descr__c = \'Partner\' AND Account_SFID__c IN :territoryaccIdSet';
        if(sortbyValue != null && !String.isBlank(sortbyValue)){
            WhereCondition = ' WHERE  Account_SFID__r.Account_Global_Party_ID__c != null AND Archive_Ind__c =\'N\'' +' AND Account_SFID__r.Archive_Ind__c =\'N\''+' AND Role_Descr__c = \'Partner\''
                +' AND Service_Level_Class_Descr__c != null AND Account_SFID__c IN :territoryaccIdSet ORDER BY Service_Level_Class_Descr__c ASC';  
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
        system.debug('sortbyValue=>'+sortbyValue);
        system.debug('Query to Execute::' +Query);        
        try{
            List<Account_Business_Role__c> accountRecordsList = Database.query(Query);
            if(!accountRecordsList.isEmpty()){
                for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < accountRecordsList.size();i++){   
                    dealerIdSet.add(accountRecordsList[i].Account_SFID__c);
                    dealerABSIdSet.add(accountRecordsList[i].id);
                }
            }
            for(Account_Org_Relationship__c growerAccount : [SELECT Id, Parent_Account_SFID__c, Parent_Acct_Bus_Role_SFID__c, Child_Account_SFID__c, 
                                                              		Child_Acct_Bus_Role_SFID__c, HC_Integration_Key__c, Archive_Date__c, Archive_Ind__c,
                                                             		Parent_Account_SFID__r.Account_Global_Party_ID__c, Child_Account_SFID__r.Account_Global_Party_ID__c
                                      FROM Account_Org_Relationship__c WHERE Parent_Account_SFID__c IN :dealerIdSet 
                                                             				 AND Child_Account_SFID__c IN :territoryaccIdSet 
                                                             				 AND Child_Acct_Bus_Role_SFID__r.Role_Descr__c = 'Customer'
                                                             				 AND Parent_Account_SFID__r.Account_Global_Party_ID__c != null 
                                       										 AND Child_Account_SFID__r.Account_Global_Party_ID__c != null
                                     ]){
                if(growerAccount.Child_Account_SFID__c != NUll && growerAccount.Child_Acct_Bus_Role_SFID__c != Null){
                    if(!dealerAccountMap.containskey(growerAccount.Parent_Account_SFID__c)){
                        count = 1;
                        dealerAccountMap.put(growerAccount.Parent_Account_SFID__c,count);
                    }
                    else{
                       dealerAccountMap.put(growerAccount.Parent_Account_SFID__c,dealerAccountMap.get(growerAccount.Parent_Account_SFID__c)+1);
                    }
                }
            }  
           for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < accountRecordsList.size();i++){   
                accountListAfterSkip.add(new AccountWrapper(accountRecordsList[i],dealerAccountMap.get(accountRecordsList[i].Account_SFID__c)));
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
        public Integer GrowerCount {get;set;}
        
        public Account_Identifier__c accountIdentifier{get;set;}        
        public Account_Communication__c accountCommunication{get;set;}
        
        public AccountWrapper(Account_Business_Role__c businessRole, Integer count){
            this.accountBusinessRole=businessRole;
            this.Name=accountBusinessRole.Account_SFID__r.Name;
            this.accId = accountBusinessRole.Account_SFID__c;            
            this.serviceLevelDesc=accountBusinessRole.Service_Level_Class_Descr__c;
            this.roleDesc=accountBusinessRole.Role_Descr__c;
            //this.sapId=accountBusinessRole.SAP_ID__C;
            this.accountIdentifier=(accountBusinessRole.Account_Identifiers__r.isEmpty() ? Null : accountBusinessRole.Account_Identifiers__r[0] );
            this.sapId=(accountBusinessRole.Account_Identifiers__r.isEmpty() ? Null : accountIdentifier.Source_System_ID__c);
            this.accountCommunication = (accountBusinessRole.Account_Communications__r.isEmpty() ? Null : accountBusinessRole.Account_Communications__r[0] );
            this.accCommu= (accountBusinessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.Id);
            this.streetAddress=(accountBusinessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.Street_Addr__c);
            this.cityName=(accountBusinessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.City_Name__c);
            this.stateName=(accountBusinessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.State_Name__c);
            this.countryName=(accountBusinessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.Country_Name__c);            
            this.GrowerCount = count;
        }          
    }
}