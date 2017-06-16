public with sharing class Frontier_GrowerAccountListController { 
    public static Map<Id,Integer> growerAccountMap = new Map<Id,Integer>();
    public static Map<Id,Map<String,Integer>> accIdAndMapFicialYearAndNetsaleMap = new Map<Id,Map<String,Integer>>();
    public static Integer currentYear = System.Today().Year();

     
    @AuraEnabled    
    public static List<String> getAccounts(String searchKey,Integer pageSize,Integer pageNumber, Id accId) {
        System.debug('SearchKey========>'+searchKey+'===PageSize===>'+pageSize+'===pageNumber======>'+pageNumber+'===account Id====>'+accId);
        growerAccountMap.clear();
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);        
        List<AccountWrapper> accountListAfterSkip=new List<AccountWrapper>();
        List<String> accountList= new List<String>();        
        Set<Id> growerAccountIds = new Set<Id>();
        Set<Id> growerAccountABSIds = new Set<Id>();
        Set<Id> growerAccountPerpageIdSet = new Set<Id>();
        Set<Id> growerAccountABSPerPageIdSet = new Set<Id>();
        string varsearchKey='%'+searchKey+'%'; 
        Integer count = 0;
        Set<Id> territoryaccIdSet = new Set<Id>();
        
        growerAccountMap.clear();
        //Get Accounts of current user's territory from Util
        territoryaccIdSet = Util.getTerritoryAccountIds();
        system.debug('territoryaccIdSet =>'+territoryaccIdSet );
        try{
            
            //Getting Dealer Specific Growers Account's
            List<Account_Org_Relationship__c> listGrowerAccounts = new List<Account_Org_Relationship__c>(); 
            listGrowerAccounts = [SELECT Id, Parent_Account_SFID__c, Parent_Acct_Bus_Role_SFID__c, Child_Account_SFID__c,Parent_Account_SFID__r.Account_Global_Party_ID__c, Child_Account_SFID__r.Account_Global_Party_ID__c, 
                                         Child_Acct_Bus_Role_SFID__c, HC_Integration_Key__c, Archive_Date__c, Archive_Ind__c
                                  FROM Account_Org_Relationship__c WHERE Child_Account_SFID__c IN :territoryaccIdSet AND Parent_Account_SFID__c = :accId
                                       AND Child_Acct_Bus_Role_SFID__r.Role_Descr__c = 'Customer'
                                       AND Parent_Account_SFID__r.Account_Global_Party_ID__c != null 
                                       AND Child_Account_SFID__r.Account_Global_Party_ID__c != null];
            System.debug('checking'+listGrowerAccounts);
            for(Account_Org_Relationship__c accOrg : listGrowerAccounts)
            {
                if(accOrg.Child_Account_SFID__c != null && accOrg.Child_Acct_Bus_Role_SFID__c != null)
                {
                    growerAccountIds.add(accOrg.Child_Account_SFID__c);
                    growerAccountABSIds.add(accOrg.Child_Acct_Bus_Role_SFID__c);
                }
            }
            system.debug('growerAccountIds=>'+growerAccountIds);
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
                                                                         AND Account_SFID__r.Name Like :varsearchKey
                                                                         AND Role_Descr__c = 'Customer' AND Role_Category_Descr__c = 'Consumer' AND Business_Unit_Descr__c = 'Customer'
                                                                         AND Account_SFID__c IN : growerAccountIds LIMIT 5000];
            System.debug('accountRecordsList'+accountRecordsList);
            
            if(!accountRecordsList.isEmpty()){
                for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < accountRecordsList.size();i++){   
                    growerAccountPerpageIdSet.add(accountRecordsList[i].Account_SFID__c);
                    growerAccountABSPerPageIdSet.add(accountRecordsList[i].id);
                }
                system.debug('growerAccountABSPerPageIdSet=>'+growerAccountABSPerPageIdSet);
                for(Account_Sales__c accSales : [SELECT Year__c,Net_Sales_Qty__c,Account_SFID__c FROM Account_Sales__c WHERE Account_SFID__c IN :growerAccountPerpageIdSet AND (Year__c = :String.valueOf(currentYear) OR Year__c = :String.valueOf(currentYear-1) OR Year__c = :String.valueOf(currentYear-2))]){
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
                 system.debug('accIdAndMapFicialYearAndNetsaleMap=>'+accIdAndMapFicialYearAndNetsaleMap);
                
                //Getting Grower's Specific Dealer Count
                    for(Account_Org_Relationship__c growerAccount : [SELECT Id, Parent_Account_SFID__c, Parent_Acct_Bus_Role_SFID__c, Child_Account_SFID__c,Parent_Account_SFID__r.Account_Global_Party_ID__c,Child_Account_SFID__r.Account_Global_Party_ID__c, 
                                                                      Child_Acct_Bus_Role_SFID__c, HC_Integration_Key__c, Archive_Date__c, Archive_Ind__c
                                                                      FROM Account_Org_Relationship__c WHERE Parent_Account_SFID__c IN : territoryaccIdSet
                                                                      AND Parent_Account_SFID__r.Account_Global_Party_ID__c != null 
                                                                      AND Child_Account_SFID__r.Account_Global_Party_ID__c != null
                                                                      AND Child_Account_SFID__c IN : growerAccountPerpageIdSet
                                                                      AND Parent_Acct_Bus_Role_SFID__r.Role_Descr__c = 'Partner'
                                                                    ]){
                    
                    if(growerAccount.Parent_Acct_Bus_Role_SFID__c != NUll && growerAccount.Parent_Account_SFID__c != NULL){
                        if(!growerAccountMap.containskey(growerAccount.Child_Account_SFID__c)){
                            count = 1;
                            growerAccountMap.put(growerAccount.Child_Account_SFID__c,count);
                        }
                        else{
                            growerAccountMap.put(growerAccount.Child_Account_SFID__c,growerAccountMap.get(growerAccount.Child_Account_SFID__c)+1);
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
            // Fetch list of Programs.
            List<Program__c> listPrograms = new List<Program__c>();
            listPrograms = [SELECT Id, Name From Program__c];
            
            
            // Fetch list of crops.
            //List<SelectOption> cropsAvailable = new List<SelectOption>();  
            List<String> cropsAvailable = new List<String>();       
            Schema.DescribeFieldResult fieldResult =
                Account_Sales__c.Crop__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple)
            {
                //cropsAvailable.add(new SelectOption(f.getLabel(), f.getValue()));
                cropsAvailable.add(f.getLabel());
            }   
            
            // Forming Response to Client.
            accountList.add((String.valueOf(accountRecordsList.size())));
            accountList.add((JSON.serialize(accountListAfterSkip))); 
            accountList.add(JSON.serialize(listPrograms));
            accountList.add(JSON.serialize(cropsAvailable));
        }
        catch(Exception e){
            System.debug('The following error has been occured' + e.getMessage()); 
        }
        System.debug('Accounts List'+accountList[1]);
        return accountList;
    }  
    
   @AuraEnabled  
    public static List<String> sortBy(String sortbyValue,Integer pageSize,Integer pageNumber,Id acId) {
        system.debug('Account Id===========>'+acId);
        growerAccountMap.clear();
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
        Set<Id> growerAccountPerpageIdSet = new Set<Id>();
        Set<Id> growerAccountABSPerPageIdSet = new Set<Id>();
        Integer count = 0;       
        String WhereCondition;
        Set<Id> territoryaccIdSet = new Set<Id>();
        
        growerAccountMap.clear();
        //Get Accounts of current user's territory from Util
        territoryaccIdSet = Util.getTerritoryAccountIds();
        
        WhereCondition = ' WHERE Archive_Ind__c =\'N\''+' AND Account_SFID__r.Archive_Ind__c =\'N\'' +' AND   Account_SFID__r.Dealer_SFID__c = \''+ acId + '\' AND Role_Descr__c = \'Customer\'' +' AND Role_Category_Descr__c = \'Consumer\''+' AND Business_Unit_Descr__c = \'Customer\' AND Account_SFID__c IN :territoryaccIdSet LIMIT 5000';
        if(sortbyValue != null && !String.isBlank(sortbyValue)){
            WhereCondition = ' WHERE Archive_Ind__c =\'N\'' +' AND Account_SFID__r.Archive_Ind__c =\'N\''+' AND Role_Descr__c = \'Customer\'' +' AND Role_Category_Descr__c = \'Consumer\''+' AND Business_Unit_Descr__c = \'Customer\''
               +' AND Account_SFID__r.Dealer_SFID__c = \''+ acId + '\' AND Account_SFID__r.Account_Global_Party_ID__c != null AND Service_Level_Class_Descr__c != null AND Account_SFID__c IN :territoryaccIdSet ORDER BY Service_Level_Class_Descr__c ASC LIMIT 5000';  
        }
       
        String Query = 'SELECT Account_SFID__c,Account_SFID__r.Name,Service_Level_Class_Descr__c, Account_SFID__r.Account_Global_Party_ID__c,'                                
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
        system.debug('sortbyValue============>'+sortbyValue+'===Query to Execute=========>' +Query);
        try{
            List<Account_Business_Role__c> accountRecordsList = Database.query(Query);
            
            if(!accountRecordsList.isEmpty()){
                for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < accountRecordsList.size();i++){   
                    growerAccountPerpageIdSet.add(accountRecordsList[i].Account_SFID__c);
                    growerAccountABSPerPageIdSet.add(accountRecordsList[i].id);
                }
                //Getting Grower's Specific Dealers Count
                for(Account_Org_Relationship__c growerAccount : [SELECT Id, Parent_Account_SFID__c, Parent_Acct_Bus_Role_SFID__c, Child_Account_SFID__c,
                                                                  Parent_Account_SFID__r.Account_Global_Party_ID__c, Child_Account_SFID__r.Account_Global_Party_ID__c, 
                                                                  Child_Acct_Bus_Role_SFID__c, HC_Integration_Key__c, Archive_Date__c, Archive_Ind__c
                                                                  FROM Account_Org_Relationship__c 
                                                                  WHERE Parent_Account_SFID__c IN : territoryaccIdSet
                                                                          AND Parent_Account_SFID__r.Account_Global_Party_ID__c != null 
                                                                          AND Child_Account_SFID__r.Account_Global_Party_ID__c != null
                                                                          AND Child_Account_SFID__c IN : growerAccountPerpageIdSet
                                                                          AND Child_Acct_Bus_Role_SFID__c IN :growerAccountABSPerPageIdSet
                                                                          AND Parent_Acct_Bus_Role_SFID__r.Role_Descr__c = 'Partner'
                                                                ]){
                    if(growerAccount.Parent_Account_SFID__c != Null && growerAccount.Parent_Acct_Bus_Role_SFID__c != NULL){
                        if(!growerAccountMap.containskey(growerAccount.Child_Account_SFID__c)){
                            count = 1;
                            growerAccountMap.put(growerAccount.Child_Account_SFID__c,count);
                        }
                        else{
                           growerAccountMap.put(growerAccount.Child_Account_SFID__c,growerAccountMap.get(growerAccount.Child_Account_SFID__c)+1);
                        }
                    }
                }
             }
            if(!accountRecordsList.isEmpty()){
                for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < accountRecordsList.size();i++){   
                    accountListAfterSkip.add(new AccountWrapper(accountRecordsList[i],growerAccountMap.get(accountRecordsList[i].Account_SFID__c)) );                }
            }
            system.debug('accountListAfterSkip=>'+JSON.serialize(accountListAfterSkip) );
            accountList.add((String.valueOf(accountRecordsList.size())));
            accountList.add((JSON.serialize(accountListAfterSkip))); 
        }
        catch(Exception e){
            System.debug('The following error has been occured' + e.getMessage());
        }
        return accountList;
    }
    @AuraEnabled    
    public static List<String> getAllGrowerAccounts(String searchKey,Integer pageSize,Integer pageNumber) {
        System.debug('SearchKey========>'+searchKey+'===PageSize===>'+pageSize+'===pageNumber======>'+pageNumber);
        growerAccountMap.clear();
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);        
        List<AccountWrapper> accountListAfterSkip=new List<AccountWrapper>();
        List<String> accountList= new List<String>();   
        Set<Id> growerAccountPerpageIdSet = new Set<Id>();
        Set<Id> growerAccountABSPerPageIdSet = new Set<Id>();     
        string varsearchKey='%'+searchKey+'%';
        Integer count = 0;
         Set<Id> territoryaccIdSet = new Set<Id>();
        
        growerAccountMap.clear();
        //Get Accounts of current user's territory from Util
        territoryaccIdSet = Util.getTerritoryAccountIds();

        try{
            List<Account_Business_Role__c> accountRecordsList= [SELECT Account_SFID__c,Account_SFID__r.Name,Service_Level_Class_Descr__c,Account_SFID__r.Account_Global_Party_ID__c,                                
                                                                Role_Descr__c,Business_Unit_Descr__c, 
                                                                (SELECT Source_System_ID__c FROM Account_Identifiers__r LIMIT 1),
                                                                (SELECT Parent_SFID__r.Parent_SFID__r.Id,Parent_SFID__r.Parent_SFID__r.Street_Addr__c,Parent_SFID__r.Parent_SFID__r.City_Name__c,      
                                                                Parent_SFID__r.Parent_SFID__r.State_Name__c,Parent_SFID__r.Parent_SFID__r.Country_Name__c,   
                                                                 Parent_SFID__r.Role_Descr__c FROM Account_Communications__r 
                                                                 WHERE   Archive_Ind__c = 'N' AND  Parent_SFID__r.Archive_Ind__c = 'N' AND   Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                                                                 AND   RecordType.DeveloperName = 'Account_Communication_Address_Role_Business_Role' AND  Parent_SFID__r.Role_Descr__c = 'Business'
                                                                 LIMIT 1)
                                                                FROM    Account_Business_Role__c
                                                                WHERE   Archive_Ind__c = 'N' AND   Account_SFID__r.Archive_Ind__c = 'N' AND   Account_SFID__r.Name Like :varsearchKey
                                                                AND Account_SFID__r.Account_Global_Party_ID__c != null AND Account_SFID__c IN :territoryaccIdSet
                                                                AND Role_Descr__c = 'Customer' AND Role_Category_Descr__c = 'Consumer' AND Business_Unit_Descr__c = 'Customer' AND Account_SFID__c IN :territoryaccIdSet LIMIT 5000];
            System.debug('accountRecordsList'+accountRecordsList); 
            
            
            if(!accountRecordsList.isEmpty()){
                 for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < accountRecordsList.size();i++){   
                        growerAccountPerpageIdSet.add(accountRecordsList[i].Account_SFID__c);
                        growerAccountABSPerPageIdSet.add(accountRecordsList[i].id);
                  }
                  //Getting Grower's Specific Dealers Count
                  system.debug('territoryaccIdSet=>'+territoryaccIdSet);
                  for(Account_Org_Relationship__c growerAccount : [SELECT Id, Parent_Account_SFID__c, Parent_Acct_Bus_Role_SFID__c, Child_Account_SFID__c,
                                                                       Parent_Account_SFID__r.Account_Global_Party_ID__c, Child_Account_SFID__r.Account_Global_Party_ID__c, 
                                                                      Child_Acct_Bus_Role_SFID__c, HC_Integration_Key__c, Archive_Date__c, Archive_Ind__c
                                                                      FROM Account_Org_Relationship__c WHERE Parent_Account_SFID__c IN :territoryaccIdSet
                                                                      AND Parent_Account_SFID__r.Account_Global_Party_ID__c != null
                                                                      AND Child_Account_SFID__r.Account_Global_Party_ID__c != null
                                                                      AND Child_Acct_Bus_Role_SFID__c IN : growerAccountABSPerPageIdSet
                                                                      AND Child_Account_SFID__c IN : growerAccountPerpageIdSet
                                                                      AND Parent_Acct_Bus_Role_SFID__r.Role_Descr__c = 'Partner'

                                                                   ]){
                        if(growerAccount.Parent_Acct_Bus_Role_SFID__c != Null && growerAccount.Parent_Account_SFID__c != NULL){
                            if(!growerAccountMap.containskey(growerAccount.Child_Account_SFID__c)){
                                count = 1;
                                growerAccountMap.put(growerAccount.Child_Account_SFID__c,count);
                            }
                            else{
                                growerAccountMap.put(growerAccount.Child_Account_SFID__c,growerAccountMap.get(growerAccount.Child_Account_SFID__c)+1);
                            }
                        }
                }
            }
            system.debug('growerAccountMap=>'+growerAccountMap);
                                                
            if(!accountRecordsList.isEmpty()){
                for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < accountRecordsList.size();i++){  
                    system.debug('accountRecordsList[i].Account_SFID__c=>'+accountRecordsList[i].Account_SFID__c);
                    system.debug('growerAccountMap.get(accountRecordsList[i].Account_SFID__c)=>'+growerAccountMap.get(accountRecordsList[i].Account_SFID__c));
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
        growerAccountMap.clear();
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
        Set<Id> growerAccountPerpageIdSet = new Set<Id>();
        Set<Id> growerAccountABSPerPageIdSet = new Set<Id>();
        Integer count = 0;       
        String WhereCondition;
        Set<Id> territoryaccIdSet = new Set<Id>();
        
        growerAccountMap.clear();
        //Get Accounts of current user's territory from Util
        territoryaccIdSet = Util.getTerritoryAccountIds();
        
        WhereCondition = ' WHERE Archive_Ind__c =\'N\''+' AND Account_SFID__r.Archive_Ind__c =\'N\''+' AND Role_Descr__c = \'Customer\'' +' AND Role_Category_Descr__c = \'Consumer\''+' AND Business_Unit_Descr__c = \'Customer\' AND Account_SFID__r.Account_Global_Party_ID__c != null AND Account_SFID__c IN :territoryaccIdSet LIMIT 5000';
        if(sortbyValue != null && !String.isBlank(sortbyValue)){
            WhereCondition = ' WHERE Archive_Ind__c =\'N\'' +' AND Account_SFID__r.Archive_Ind__c =\'N\''+' AND Role_Descr__c = \'Customer\'' +' AND Role_Category_Descr__c = \'Consumer\''+' AND Business_Unit_Descr__c = \'Customer\' '
                  + ' AND Account_SFID__r.Account_Global_Party_ID__c !=null AND Service_Level_Class_Descr__c != null AND Account_SFID__c IN :territoryaccIdSet ORDER BY Service_Level_Class_Descr__c ASC LIMIT 5000';  
        }
       
        String Query = 'SELECT Account_SFID__c,Account_SFID__r.Name,Service_Level_Class_Descr__c, Account_SFID__r.Account_Global_Party_ID__c,'                                
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
                        growerAccountPerpageIdSet.add(accountRecordsList[i].Account_SFID__c);
                        growerAccountABSPerPageIdSet.add(accountRecordsList[i].id);
                  }
                  //Getting Grower's Specific Dealers Count
                  for(Account_Org_Relationship__c growerAccount : [SELECT Id, Parent_Account_SFID__c, Parent_Acct_Bus_Role_SFID__c, Child_Account_SFID__c, Parent_Account_SFID__r.Account_Global_Party_ID__c, 
                                                                      Child_Acct_Bus_Role_SFID__c, HC_Integration_Key__c, Archive_Date__c, Archive_Ind__c,Child_Account_SFID__r.Account_Global_Party_ID__c
                                                                      FROM Account_Org_Relationship__c WHERE Parent_Account_SFID__c IN :territoryaccIdSet
                                                                      AND Parent_Account_SFID__r.Account_Global_Party_ID__c != null
                                                                      AND Child_Account_SFID__r.Account_Global_Party_ID__c != null
                                                                      AND Child_Acct_Bus_Role_SFID__c IN : growerAccountABSPerPageIdSet
                                                                      AND Child_Account_SFID__c IN : growerAccountPerpageIdSet
                                                                      AND Parent_Acct_Bus_Role_SFID__r.Role_Descr__c = 'Partner'
                                                                  ]){
                        if(growerAccount.Parent_Account_SFID__c != Null && growerAccount.Parent_Acct_Bus_Role_SFID__c != NULL){
                            if(!growerAccountMap.containskey(growerAccount.Child_Account_SFID__c)){
                                count = 1;
                                growerAccountMap.put(growerAccount.Child_Account_SFID__c,count);
                            }
                            else{
                                growerAccountMap.put(growerAccount.Child_Account_SFID__c,growerAccountMap.get(growerAccount.Child_Account_SFID__c)+1);
                            }
                        }
                }
            }                                                   
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
        public Integer dealerCount{get;set;}
        public Account_Identifier__c accountIdentifier{get;set;}        
        public Account_Communication__c accountCommunication{get;set;}
        public String PY2Sales {get;set;}
        public string PYSales {get;set;}
        public string CYSales {get;set;}
        
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
            this.dealerCount = Count;
            this.CYSales = accountBusinessRole.Account_SFID__c != Null ?  (accIdAndMapFicialYearAndNetsaleMap.containsKey(accountBusinessRole.Account_SFID__c ) ? (accIdAndMapFicialYearAndNetsaleMap.get(accountBusinessRole.Account_SFID__c ).containsKey(String.valueOf(currentYear)) ? String.valueOf(accIdAndMapFicialYearAndNetsaleMap.get(accountBusinessRole.Account_SFID__c ).get(String.valueOf(currentYear))) : '0') :'0') :'0';
            this.PYSales = accountBusinessRole.Account_SFID__c != Null ?  (accIdAndMapFicialYearAndNetsaleMap.containsKey(accountBusinessRole.Account_SFID__c ) ? (accIdAndMapFicialYearAndNetsaleMap.get(accountBusinessRole.Account_SFID__c ).containsKey(String.valueOf(currentYear-1)) ? String.valueOf(accIdAndMapFicialYearAndNetsaleMap.get(accountBusinessRole.Account_SFID__c ).get(String.valueOf(currentYear-1))) : '0') :'0') :'0';
            this.PY2Sales = accountBusinessRole.Account_SFID__c != Null ?  (accIdAndMapFicialYearAndNetsaleMap.containsKey(accountBusinessRole.Account_SFID__c ) ? (accIdAndMapFicialYearAndNetsaleMap.get(accountBusinessRole.Account_SFID__c ).containsKey(String.valueOf(currentYear-2)) ? String.valueOf(accIdAndMapFicialYearAndNetsaleMap.get(accountBusinessRole.Account_SFID__c ).get(String.valueOf(currentYear-2))) : '0') :'0') :'0';
        }          
    }
}