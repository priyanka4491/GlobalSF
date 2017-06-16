/*********************************************************************************************
* @author : Cognizant Technology Solutions.
* @version : 1.0
* @Description : This is the common class to reuse the code.
1) Concatenate the query to with the filter
2) Obtain the month name from the given date
3) Send Email with the attachment
*********************************************************************************************/
public without sharing class Util {
    public static Set<Id> accdashboardIdSet = new Set<Id>();
    public static Boolean getaccIdflag = false;
    // Construct the query with the given filter and return it
    public static String getQuery(String query,String startQuery,String endQuery,String fieldList){
        query += startQuery + fieldList.split('-')[0]+' '+fieldList.split('-')[1]+ ','+endQuery;
        system.debug('Generated query inside util'+query);
        return query;     
    }  
    // Return the month name from the given date
    public static string getMonth(DateTime loginTime){
        return loginTime.format('MMMMM');
    }
    // Send the email with the attachment
    public static void sendEmail(String csvName,String subject,List<String> toAddress,String emailBody,String generatedCSVFile){
        Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
        Blob csvBlob = blob.valueOf(generatedCSVFile);        
        csvAttachment.setFileName(csvName);
        csvAttachment.setBody(csvBlob);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject(subject);
        //email.setReplyTo('Visit-Followup@monsonto.com');
        //email.setSenderDisplayName('Visit Follow Up');
        email.setToAddresses(toAddress);
        email.setPlainTextBody(emailBody);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
        Messaging.SendEmailResult[] emailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
    }
    public static  Map<Id,Account_Business_Role__c> getbussinessrole(String sortByRADL){
        
        Map<Id,Account_Business_Role__c> bussinessroleMap = new Map<Id,Account_Business_Role__c>();
        List<Account_Business_Role__c> accbussinessrolerecords = new List<Account_Business_Role__c>();
        String query = 'SELECT SAP_ID__c,Service_Level_Class_Descr__c,Account_SFID__c FROM Account_Business_Role__c';
        query += ' WHERE Service_Level_Class_Descr__c =\''+sortByRADL+'\'';
        System.debug('Query Util' + query);
        accbussinessrolerecords  = Database.query(query);
        for(Account_Business_Role__c accbussinessrole : accbussinessrolerecords){
            if(!bussinessroleMap.containsKey(accbussinessrole.Account_SFID__c))
                bussinessroleMap.put(accbussinessrole.Account_SFID__c, accbussinessrole);
        }  
        System.debug('bussinessroleMap' + bussinessroleMap.Size());
        return bussinessroleMap;
        
    }
    public static Set<Id> getAccountIds(Map<Id,Account_Business_Role__c> accbussinessroleMap){
        Set<Id> accountIds = new Set<Id>();
        if(!accbussinessroleMap.isEmpty()){
            for(Account_Business_Role__c accBussinessRole : accbussinessroleMap.values()){
                accountIds.add(accBussinessRole.Account_SFID__c); 
            }
        }
        System.debug('accountIds' + accountIds.size());
        return accountIds;
    }   
    public static List<Event> getEvents(Set<Id> accountIds,String SortByTypeFilter,String sortByMonthfilter,String CreatedDate){ 
        List<Event> eventsList = new List<Event>();
        String queryString ='SELECT Id,Type,ActivityDate,CreatedBy.Name,WhatId,CreatedDate,What.Name FROM Event WHERE WhatId IN :accountIds';
        if(SortByTypeFilter != 'None'){
            queryString += ' AND Type =\''+SortByTypeFilter+'\'';
        }
        if(sortByMonthfilter != ''){
            system.debug('Month=>'+sortByMonthfilter);
            String CalenderMonth= getSortByMonth(sortByMonthfilter,'CreatedDate');
            queryString += ' AND '+CalenderMonth+'';
        }
        
        queryString += ' ORDER BY CreatedDate  DESC';
        eventsList = Database.query(queryString);
        System.debug('queryString' + queryString);
        System.debug('eventsList' + eventsList .size());
        return eventsList;
    }
    public static Map<Id, Territory2> getTerritory(Set<Id> accountIds,Set<string> territoryIdSet){ 
        Set<Id> accountShareIds = new Set<Id>();
        Map<Id,Id> territoryWithGroupIds = new  Map<Id,Id>();
        Map<Id,Set<Id>> groupWithAccountIds = new Map<Id,Set<Id>>();
        Map<Id, Territory2> userTerritoryMap = new Map<Id, Territory2>();
        List<Territory2> territoryList = new List<Territory2>();
        Set<Id> territoryWithGroupIdset = new Set<Id>();
        String query = 'SELECT Id, UserOrGroupId, AccountId FROM AccountShare WHERE RowCause = \'TerritoryManual\'';
        //  if(accountIds.size() > 0){   
        if(!accountIds.isEmpty()){
            query += 'AND AccountId IN :accountIds';
        } 
        if(accountIds.isEmpty() && territoryIdSet.isEmpty()){
            Id userId = UserInfo.getUserId();
            System.debug('userId' + userId);
            query += ' AND UserOrGroupId = :userId';  
        }
        for(AccountShare acctShare : Database.query(query)){
            System.debug('acctShare' + acctShare);
            accountShareIds.add(acctShare.UserOrGroupId); 
            if(!groupWithAccountIds.containsKey(acctShare.UserOrGroupId)){
                groupWithAccountIds.put(acctShare.UserOrGroupId,new Set<Id>{acctShare.AccountId});
            }
            else{
                groupWithAccountIds.get(acctShare.UserOrGroupId).add(acctShare.AccountId);
            }
        }
        if(!accountShareIds.isEmpty()){
            for(Group groupRecord : [SELECT Id, RelatedId from Group WHERE Type='Territory' AND Id IN :groupWithAccountIds.keySet()]){
                if(!territoryWithGroupIds.containsKey(groupRecord.RelatedId)){
                    territoryWithGroupIds.put(groupRecord.RelatedId,groupRecord.id);
                    territoryWithGroupIdset.add(groupRecord.RelatedId);
                }
            }
        }
        
        String queryString ='SELECT id,name,ParentTerritory2Id,ParentTerritory2.Name,Description FROM Territory2'; 
        system.debug('territoryIdSet=>'+territoryIdSet);
        String territoryIds = territoryIdSet.isEmpty() ? ' WHERE Id IN :territoryWithGroupIdset' : ' WHERE ParentTerritory2Id IN :territoryIdSet';
        queryString += territoryIds ;
        
        System.debug('queryStringTerritory'+ queryString);
        //System.debug('territoryList' + territoryList);
        territoryList = Database.query(queryString);
        
        if(!territoryWithGroupIds.isEmpty()){
            for(Territory2 listOfTerritory : territoryList) {
                if(territoryWithGroupIds.containsKey(listOfTerritory.Id)){
                    for(Id accountId : groupWithAccountIds.get(territoryWithGroupIds.get(listOfTerritory.Id))){
                        userTerritoryMap.put(accountId,listOfTerritory);
                    }
                }
                else{
                    continue;
                }
            }
        }
        // }
        return userTerritoryMap;
    }
    
    
    
    
    public static string getSortByMonth(String Month,String CreatedDate){
        String CalenderMonth;
        
        if(!Month.contains(';')){
            CalenderMonth= 'CALENDAR_MONTH('+CreatedDate+')='+Month;
        }
        else{
            CalenderMonth='(';
            for(String mon :  Month.split(';')){
                if(CalenderMonth == '('){
                    CalenderMonth+= 'CALENDAR_MONTH('+CreatedDate+')='+mon;
                    
                }
                else{
                    CalenderMonth += ' OR CALENDAR_MONTH('+CreatedDate+')='+mon;
                    
                }
                
            }
            CalenderMonth += ')'; 
        }
        return CalenderMonth;
    } 
    
    public static string getSortByCountry(String Country,String ParentTerritoryName){
        String CountryFilter;
        if(!Country.contains(';')){
            CountryFilter = ''+ParentTerritoryName+'=\''+Country+'\'';
        }
        else{
            CountryFilter ='(';
            for(String Con :  Country.split(';')){
                if(CountryFilter == '('){
                    CountryFilter += ''+ParentTerritoryName+'=\''+Con+'\'';
                    System.debug(CountryFilter + 'CountryFilter');
                    System.debug(Con +'Con');
                }
                else{
                    CountryFilter += ' OR '+ParentTerritoryName+'=\''+Con+'\'';
                    System.debug(CountryFilter + 'CountryFilter');
                }
                
            }
            CountryFilter += ')';
        }
        return CountryFilter; 
    }
    
    public static String getRecordsPerPage(){
        return null;
    }
    
    public static Frontier_ProgramDetailWrapper getProgramDetail(String progId){
        Frontier_ProgramDetailWrapper programDetailWrapper = new Frontier_ProgramDetailWrapper();
        if(progId != Null){
            Program__c program = [SELECT Id,Name,Available__c,Allocated__c,Budget__c,Consumed__c,CS_Growth__c,Growth__c,
                                  Planning_Status__c,Volume_Growth__c,Completed__c,Cancelled__c,Execution_Status__c,Brand_Family__c FROM Program__c WHERE Id=:progId];
            
            programDetailWrapper.programName = program.Name;
            programDetailWrapper.Id = program.Id;
            programDetailWrapper.Budget = ((program.Budget__c == Null || program.Budget__c == 0) ? 'NA' : String.valueOf(program.Budget__c));
            programDetailWrapper.BrandFamily = program.Brand_Family__c;
            programDetailWrapper.Available = (programDetailWrapper.Budget != 'NA' ? Integer.valueOf(program.Budget__c) : 0);
            
            List<Account_Program__c> accountPrograms = [SELECT Id,Planning_Status__c,Execution_Status__c,Program_SFID__c,Service_Level_Class_Descr__c FROM Account_Program__c
                                                        WHERE Program_SFID__c =:progId AND CreatedBy.Id =:Userinfo.getUserId()];
            if(!accountPrograms.isEmpty()){                
                for(Account_Program__c accProg : accountPrograms){
                    if(accProg.Execution_Status__c != 'Completed' && accProg.Execution_Status__c != 'Cancelled'){
                        programDetailWrapper.Allocated += 1;
                        programDetailWrapper.Available = (programDetailWrapper.Available != 0 ? (programDetailWrapper.Available - 1 == -1 ? 0 : programDetailWrapper.Available - 1) : 0);
                    }
                    else if(accProg.Execution_Status__c == 'Completed'){
                        programDetailWrapper.Consumed += 1;
                        programDetailWrapper.Allocated += 1;
                        programDetailWrapper.Available = (programDetailWrapper.Available != 0 ? (programDetailWrapper.Available - 1 == -1 ? 0 : programDetailWrapper.Available - 1) : 0);
                    }  
                    if(accProg.Service_Level_Class_Descr__c == 'Retain' && accProg.Execution_Status__c != 'Cancelled'){
                        programDetailWrapper.RetainCount += 1;                           
                    }
                    else if(accProg.Service_Level_Class_Descr__c == 'Acquire' && accProg.Execution_Status__c != 'Cancelled'){
                        programDetailWrapper.AquireCount += 1;
                    }
                    else if(accProg.Service_Level_Class_Descr__c == 'Light Touch' && accProg.Execution_Status__c != 'Cancelled'){
                        programDetailWrapper.LtCount += 1;
                    }
                    else if(accProg.Service_Level_Class_Descr__c == 'Develop' && accProg.Execution_Status__c != 'Cancelled'){
                        programDetailWrapper.DevelopCount += 1;
                    }
                }
            }
            
        }
        return programDetailWrapper;
    }
    public static Map<Id,Frontier_ProgramDetailWrapper> getProgramBudgetDetail(){
        List<Account_Program__c> accountPrograms = [SELECT Id,Program_SFID__r.Id,Planning_Status__c,Execution_Status__c,Program_SFID__r.Name,
                                                    Program_SFID__r.Available__c,Program_SFID__r.Allocated__c,Program_SFID__r.Budget__c,Program_SFID__r.Program_Coverage__c,
                                                    Program_SFID__r.Consumed__c,Program_SFID__r.CS_Growth__c,Program_SFID__r.Growth__c, Program_SFID__r.Planning_Status__c,
                                                    Program_SFID__r.Volume_Growth__c,Program_SFID__r.Completed__c,Program_SFID__r.Cancelled__c,Program_SFID__r.Execution_Status__c,Program_SFID__r.Brand_Family__c,  
                                                    Service_Level_Class_Descr__c FROM Account_Program__c
                                                    WHERE CreatedBy.Id =:Userinfo.getUserId()];
        
        List<Frontier_ProgramDetailWrapper> programDetailWrapperList = new List<Frontier_ProgramDetailWrapper>();
        Map<Id,Frontier_ProgramDetailWrapper> programDetailWrapperMap = new Map<Id,Frontier_ProgramDetailWrapper>();
        if(!accountPrograms.isEmpty()){
            for(Account_Program__c accProg : accountPrograms){
                Frontier_ProgramDetailWrapper programDetailWrapper = new Frontier_ProgramDetailWrapper();
                programDetailWrapper.programName = accProg.Program_SFID__r.Name;
                programDetailWrapper.Id = accProg.Program_SFID__r.Id;
                programDetailWrapper.Budget = ((accProg.Program_SFID__r.Budget__c == Null || accProg.Program_SFID__r.Budget__c == 0) ? 'NA' : String.valueOf(accProg.Program_SFID__r.Budget__c));
                programDetailWrapper.BrandFamily = accProg.Program_SFID__r.Brand_Family__c;
                programDetailWrapper.Available = (programDetailWrapper.Budget != 'NA' ? Integer.valueOf(accProg.Program_SFID__r.Budget__c) : 0);
                
                if(programDetailWrapperMap.containsKey(accProg.Program_SFID__r.Id)){
                    programDetailWrapper = programDetailWrapperMap.get(accProg.Program_SFID__r.Id);
                }  
                
                
                programDetailWrapper.ProgramCoverage = accProg.Program_SFID__r.Program_Coverage__c;
                if(accProg.Execution_Status__c != 'Completed' && accProg.Execution_Status__c != 'Cancelled'){
                    programDetailWrapper.Allocated += 1;
                    programDetailWrapper.Available = (programDetailWrapper.Available != 0 ? (programDetailWrapper.Available - 1 == -1 ? 0 : programDetailWrapper.Available - 1) : 0);
                }
                else if(accProg.Execution_Status__c == 'Completed'){
                    programDetailWrapper.Consumed += 1;
                    programDetailWrapper.Allocated += 1;
                    programDetailWrapper.Available = (programDetailWrapper.Available != 0 ? (programDetailWrapper.Available - 1 == -1 ? 0 : programDetailWrapper.Available - 1) : 0);
                }  
                if(accProg.Service_Level_Class_Descr__c == 'Retain'){
                    programDetailWrapper.RetainCount += 1;                           
                }
                else if(accProg.Service_Level_Class_Descr__c == 'Acquire'){
                    programDetailWrapper.AquireCount += 1;
                }
                else if(accProg.Service_Level_Class_Descr__c == 'Light Touch'){
                    programDetailWrapper.LtCount += 1;
                }
                else if(accProg.Service_Level_Class_Descr__c == 'Develop'){
                    programDetailWrapper.DevelopCount += 1;
                }
                if(!programDetailWrapperMap.containsKey(accProg.Program_SFID__c)){
                    programDetailWrapperMap.put(accProg.Program_SFID__r.Id,programDetailWrapper);
                }
            }
        }
        System.debug('programDetailWrapperMap'+programDetailWrapperMap);
        return programDetailWrapperMap;
    }
    
    public static Set<Id> getTerritoryAccountIds(){
        List<UserTerritory2Association> userTerritoryList = new List<UserTerritory2Association>();
        Set<Id> territoryIdSet = new Set<Id>();
        Set<Id> groupIdSet = new Set<Id>();
        Set<Id> accountIdSet = new Set<Id>();
        
        
        userTerritoryList = [SELECT Id, IsActive, RoleInTerritory2, Territory2Id, UserId FROM 
                             UserTerritory2Association WHERE UserId =: userInfo.getuserId()];
        if(!userTerritoryList.isEmpty()){
            for(Territory2 territory : [SELECT Id, Name, DeveloperName, Division__c FROM 
                                        Territory2 WHERE Id =: userTerritoryList[0].Territory2Id]){
                                            territoryIdSet.add(territory.Id);
                                        }
            
        }
        
        
        List<Group> groupList = new List<Group>();
        if(!territoryIdSet.isEmpty()){
            for(Group grouprecord : [SELECT Id, RelatedId from Group WHERE Type='Territory' AND RelatedId =:territoryIdSet]){
                groupIdSet.add(grouprecord.Id);
            }
        }
        
        if(!groupIdSet.isEmpty()){
            for(AccountShare accShare : [SELECT Id, UserOrGroupId, AccountId FROM AccountShare WHERE RowCause = 'TerritoryManual' AND UserOrGroupId=:groupIdSet]){
                accountIdSet.add(accShare.accountId);
            }
        }
        return accountIdSet;
    }
    
    
    public static Set<Id> getTerritoryAccountIdsForMultipleUsers(Set<Id> userIdSet){
        List<Group> groupList = new List<Group>();
        Set<Id> territory2IdSet = new Set<Id>();
        Set<Id> territoryIdSet = new Set<Id>();
        Set<Id> groupIdSet = new Set<Id>();
        Set<Id> accountIdSet = new Set<Id>();
        
        system.debug('Util-userIdSet=>'+userIdSet);
        
        for(UserTerritory2Association usrTerr : [SELECT Id, IsActive, RoleInTerritory2, Territory2Id, UserId FROM UserTerritory2Association WHERE UserId IN :userIdSet]){
            territory2IdSet.add(usrTerr.Territory2Id);
            
        }
        system.debug('Util-territory2IdSet=>'+territory2IdSet);
        if(!territory2IdSet.isEmpty()){
            for(Territory2 territory : [SELECT Id, Name, DeveloperName, Division__c FROM Territory2 WHERE Id IN :territory2IdSet]){
                territoryIdSet.add(territory.Id);
            }
            
        }
        system.debug('Util-territoryIdSet=>'+territoryIdSet);
        
        
        if(!territoryIdSet.isEmpty()){
            for(Group grouprecord : [SELECT Id, RelatedId from Group WHERE Type='Territory' AND RelatedId =:territoryIdSet]){
                groupIdSet.add(grouprecord.Id);
            }
        }
        system.debug('Util-groupIdSet=>'+groupIdSet);
        
        if(!groupIdSet.isEmpty()){
            for(AccountShare accShare : [SELECT Id, UserOrGroupId, AccountId FROM AccountShare WHERE RowCause = 'TerritoryManual' AND UserOrGroupId=:groupIdSet]){
                accountIdSet.add(accShare.accountId);
            }
        }
        system.debug('Util-accountIdSet=>'+accountIdSet);
        return accountIdSet;
    }   
    //Get account id in logged-in user's territory,Account Sales and Account Farming area
    public static Map<String,Set<Id>> getAccountSalesAccId(String season, String accType){
        //List<Account_Sales__c> accSalesList = new List<Account_Sales__c>();
        Set<Id> territoryAccId = new Set<Id>();
        Set<Id> accdashboardIdCustSet = new Set<Id>();
        Map<String,Set<Id>> territoryAccIdMap = new Map<String,Set<Id>>();
        territoryAccId = getTerritoryAccountIds();
        System.debug('territoryAccId' + territoryAccId.size());
        System.debug('territoryAccIdMap'+ territoryAccIdMap);
        //Query Account Sales with territoryAccId, selected season, crop, account type and year 
        if(territoryAccIdMap.isEmpty()){
            if(accType =='All Accounts'){
                for(Account_Sales__c accSales : [SELECT Account_SFID__c,Net_Sales_Qty__c,Opportunity__c 
                                                 FROM Account_Sales__c 
                                                 WHERE Selling_Season_Descr__c = :season AND Year__c ='2016' AND Account_Business_Role_SFID__c != null AND Account_SFID__c= :territoryAccId]){
                                                     accdashboardIdSet.add(accSales.Account_SFID__c);   
                                                     System.debug('accdashboardIdSet partner' + accdashboardIdSet.size());
                                                 }
                if(!accdashboardIdSet.isEmpty()){
                    territoryAccIdMap.put('Partner',accdashboardIdSet);
                    System.debug('territoryAccIdMap partner' + (territoryAccIdMap.get('Partner')).Size());
                }
                for(Account_Farming_Area__c accFarm : [SELECT Account_SFID__c,Area_Opportunity__c 
                                                       FROM Account_Farming_Area__c 
                                                       WHERE Selling_Season_Descr__c = :season AND Year__c =2016 AND Parent_SFID__c != null AND Account_Business_Role_SFID__c != null AND Account_SFID__c= :territoryAccId]){
                                                           accdashboardIdCustSet.add(accFarm.Account_SFID__c);
                                                           System.debug('accdashboardIdCustSet customer' + accdashboardIdCustSet.size());
                                                       }
                if(!accdashboardIdCustSet.isEmpty()){
                    territoryAccIdMap.put('Customer',accdashboardIdCustSet);
                    System.debug('territoryAccIdMap customer' + (territoryAccIdMap.get('Customer')).Size());
                }
            }
            if(accType == 'Partner'){
                //if(crop == 'All Crops'){
                  for(Account_Sales__c accSales : [SELECT Account_SFID__c,Net_Sales_Qty__c,Opportunity__c 
                                                 FROM Account_Sales__c 
                                                 WHERE Selling_Season_Descr__c = :season AND Year__c ='2016' AND Account_Business_Role_SFID__r.Role_Descr__c= :accType AND Account_SFID__c= :territoryAccId]){
                                                     accdashboardIdSet.add(accSales.Account_SFID__c);
                                                 }
                if(!accdashboardIdSet.isEmpty()){
                    territoryAccIdMap.put('Partner',accdashboardIdSet);
                    System.debug('territoryAccIdMap partner' + (territoryAccIdMap.get('Partner')).Size());
                }
                //}
                /*else{
                   for(Account_Sales__c accSales : [SELECT Account_SFID__c,Net_Sales_Qty__c,Opportunity__c 
                                                 FROM Account_Sales__c 
                                                 WHERE Selling_Season_Descr__c = :season AND Crop__c = :crop AND Year__c ='2016' AND Account_Business_Role_SFID__r.Role_Descr__c= :accType AND Account_SFID__c= :territoryAccId]){
                                                     accdashboardIdSet.add(accSales.Account_SFID__c);
                                                 }  
                }*/        
            }
            else if(accType == 'Customer'){ 
                //if(crop == 'All Crops'){
                  for(Account_Farming_Area__c accFarm : [SELECT Account_SFID__c,Area_Opportunity__c 
                                                       FROM Account_Farming_Area__c 
                                                       WHERE Selling_Season_Descr__c = :season AND Year__c =2016 AND Parent_SFID__c != null AND Account_Business_Role_SFID__r.Role_Descr__c= :accType AND Account_SFID__c= :territoryAccId]){
                                                           accdashboardIdSet.add(accFarm.Account_SFID__c);
                                                       } 
                if(!accdashboardIdSet.isEmpty()){
                    territoryAccIdMap.put('Customer',accdashboardIdSet);
                    System.debug('territoryAccIdMap customer' + (territoryAccIdMap.get('Customer')).Size());
                }
                //}
               /* else{
                  for(Account_Farming_Area__c accFarm : [SELECT Account_SFID__c,Area_Opportunity__c 
                                                       FROM Account_Farming_Area__c 
                                                       WHERE Selling_Season_Descr__c = :season AND Area_Usage_Descr__c = :crop AND Year__c =2016 AND Account_Business_Role_SFID__r.Role_Descr__c= :accType AND Account_SFID__c= :territoryAccId]){
                                                           accdashboardIdSet.add(accFarm.Account_SFID__c);
                                                       }  
                }*/
                 
            }  
        }
        if(territoryAccIdMap != null){
            System.debug('territoryAccIdMap' + territoryAccIdMap);
            return territoryAccIdMap;
        }
        else{
            return null;
        }
        
    }
}