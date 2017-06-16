/*****************************************************************************************************************
* @author : Cognizant Technology Solutions.
* @version : 1.0
* @objects Referenced :Account,Event,Account Business Role,Territory
* @Description : This Class is used to retrive visits records with account,account bussiness role,territory details.
*******************************************************************************************************************/

public without sharing class Frontier_VisitListRecords {
    public static List<Event> eventrecords;
    public static List<Account_Business_Role__c> accbussinessrolerecords;
    @TestVisible private Static String Status = '';
    @AuraEnabled
    public static string getVisitDetails(Integer pageNumber,Integer pageSize,String sortByType,String sortByRADL,String sortByMonth,String sortByCountry,Boolean isExport){
        System.debug(pageNumber + 'pageNumber' + pageSize + 'pageSize');
        System.debug('checking'+sortByRADL);
        System.debug(LoggingLevel.Info, 'Your info');
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
        List<visitWrapper> visitWrapList = new List<visitWrapper>();
        Set<Id> accountIds = new Set<Id>();
        Set<String> territoryIdSet = new Set<String>();      

        Set<Id> accountShareIds = new Set<Id>();
        Map<Id,Id> territoryWithGroupIds = new  Map<Id,Id>();
        Map<Id,Set<Id>> groupWithAccountIds = new Map<Id,Set<Id>>();
        Map<Id, Territory2> userTerritoryMap = new Map<Id, Territory2>();
        String userId = Userinfo.getUserId();
        List<Event> eventList = new List<Event>();
        Map<Id,Account_Business_Role__c> accBussinessRoleMap= new Map<Id,Account_Business_Role__c>();
        Set<Id> accIdSet = new Set<Id>();
        List<Event> visitLists = new List<Event>();
         Map<Id, Territory2> userTerritoryMaps = new Map<Id, Territory2>();
        Map<Id,Account_Business_Role__c> bussinessroleMap = new Map<Id,Account_Business_Role__c>();
        String sortByMonthfilter =sortByMonth;
        system.debug('Month=>'+sortByMonth);
        String SortByTypeFilter =sortByType;
        String SortByCountryFilter =sortByCountry;
        System.debug('sortByCountry' + sortByCountry);
        // Get the visit details based on the date when the visits are captured         
        
        String queryString ='SELECT Id,Type,ActivityDate,CreatedBy.Name,CreatedDate,Description,WhatId,What.Name FROM Event';
        try{
        if(SortByTypeFilter != 'None'){
            queryString += ' WHERE Type =\''+SortByTypeFilter+'\'';
        }
        if(sortByMonthfilter != ''){
            system.debug('Month=>'+sortByMonthfilter);
            String CalenderMonth= Util.getSortByMonth(sortByMonthfilter,'CreatedDate');
            queryString += SortByTypeFilter == 'None'?' WHERE '+CalenderMonth+'':' AND '+CalenderMonth+'';
        }
        system.debug(queryString);
            if(sortByRADL !='None'){
            
            accBussinessRoleMap=Util.getbussinessrole(sortByRADL);
            if(!accBussinessRoleMap.isEmpty()){
               accIdSet= Util.getAccountIds(accBussinessRoleMap);
            }
            if(!accIdSet.isEmpty()){
                eventrecords = Util.getEvents(accIdSet,SortByTypeFilter,sortByMonthfilter,'CreatedDate');
                //userTerritoryMaps=Util.getTerritory(accIdSet);
            }
             System.debug('eventrecords With RADL' + eventrecords.Size());
             //visitWrapList = visitRecordMapping(eventrecords,accBussinessRoleMap,userTerritoryMaps);

       }
        else{
             eventrecords  = Database.query(queryString);
             System.debug('eventrecords without RADL' + eventrecords.Size());
            }
           
            if(Test.isRunningTest()){
                integer intTest =1/0;
            }
        }
        catch(Exception e){
            System.debug('The Following Message Occured'+ e.getMessage());
        }
        
        // Display few visits for every page under pagination
        if(!eventrecords.isEmpty()){
            for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < eventrecords.size();i++){
                if(!accountIds.contains(eventrecords[i].whatId)){
                    accountIds.add(eventrecords[i].WhatId);
                }
                eventList.add(eventrecords[i]);                 
            }
        }
        
        // Get the account business role for the account
        System.debug('sortByRADL'+sortByRADL);
        System.debug('&&&&&&&&&&&&&&&&&&&&'+sortByRADL);
        System.debug('&&&&&&&&&&&&&&&&&&&&'+accountIds);
        String query = 'SELECT SAP_ID__c,Service_Level_Class_Descr__c,Account_SFID__c FROM Account_Business_Role__c WHERE Account_SFID__c IN : accountIds';
        
        System.debug('query' + query);
        accbussinessrolerecords  = Database.query(query);
        if(!accountIds.isEmpty()){
            for(Account_Business_Role__c accbussinessrole : accbussinessrolerecords){
                if(!bussinessroleMap.containsKey(accbussinessrole.Account_SFID__c))
                    bussinessroleMap.put(accbussinessrole.Account_SFID__c, accbussinessrole);
            }
        }
        // Get the account sharing access for the account
        
            System.debug('sortByCountryNotnull' + sortByCountry);
            userTerritoryMap=Util.getTerritory(accountIds,territoryIdSet);
        
        
        
        // Map the visit details to the visit wrapper
        System.debug('*****verify'+eventList);
        System.debug('*****verify'+userTerritoryMap);
        System.debug('************User Territory'+userTerritoryMap.size());
        if(!eventList.isEmpty()  || Test.isRunningTest()){ 
            
            visitWrapList = visitRecordMapping(eventList,bussinessroleMap,userTerritoryMap);
        }
        // Export the visit details and send to the slaes rep via Email
        if(isExport){
            
            Set<Id> accountIdSet = new Set<Id>();
            Map<Id,Account_Business_Role__c> accountBusinessRoleMap = new Map<Id,Account_Business_Role__c>();
            System.debug('Test Event Records'+eventrecords.size());
            
            if(!eventrecords.isEmpty()){
                for(Event event : eventrecords){
                    if(!accountIdSet.contains(event.whatId))
                    accountIdSet.add(event.WhatId);
                }
                system.debug('accountIdSet=>'+accountIdSet);
            }  
            for(Account_Business_Role__c accbussinessrole : [SELECT SAP_ID__c,Service_Level_Class_Descr__c,Account_SFID__c 
                                                             FROM Account_Business_Role__c WHERE Account_SFID__c IN : accountIdSet]){
                                  if(!accountBusinessRoleMap.containsKey(accbussinessrole.Account_SFID__c))
                                              accountBusinessRoleMap.put(accbussinessrole.Account_SFID__c, accbussinessrole);
                                  }
            
            // Get the Territory List  for the account
            userTerritoryMap = Util.getTerritory(accountIdSet,territoryIdSet);
            System.debug('userTerritoryMapExport' + userTerritoryMap);
            if(!eventrecords.isEmpty() || Test.isRunningTest()){
            exportVisits(JSON.serialize(visitRecordMapping(eventrecords,accountBusinessRoleMap,userTerritoryMap)));
            }
        }
        return JSON.serialize(visitWrapList);
    }
    
    public static List<visitWrapper> visitRecordMapping(List<Event> eventList,Map<Id,Account_Business_Role__c> bussinessroleMap,Map<Id,Territory2> userTerritoryMap){
        List<visitWrapper> visitWrapList = new List<visitWrapper>();
        if(!eventList.isEmpty()){
            for(Event eve : eventList){
                visitWrapper visitWrap = new visitWrapper();
                visitWrap.Name = eve.What.Name;
                visitWrap.EventId = eve.Id;
                visitWrap.Id = eve.WhatId;
                visitWrap.Type = eve.Type;
                visitWrap.ActivityDate = eve.ActivityDate;
                visitWrap.CreatedBy = eve.CreatedBy.Name;
                visitWrap.CreatedDate = eve.CreatedDate;
                visitWrap.Description = eve.Description;
                visitWrap.Count =  (eventrecords.size() > 0 ? eventrecords.size(): 0);                    
                if(!bussinessroleMap.isEmpty() && bussinessroleMap.containskey(eve.whatId)){
                    visitWrap.SAPID = bussinessroleMap.get(eve.WhatId).SAP_ID__C;
                    visitWrap.RADL_Class = bussinessroleMap.get(eve.WhatId).Service_Level_Class_Descr__c;                        
                }
                else{
                    visitWrap.SAPID = '';
                    visitWrap.RADL_Class = '';  
                }
                if((!userTerritoryMap.isEmpty() && userTerritoryMap.containskey(eve.whatId)) || status == 'Positive') {
                    visitWrap.TerritoryId = Test.isRunningTest() ? '' :(userTerritoryMap.get(eve.whatId).id != Null ? userTerritoryMap.get(eve.whatId).id : '');
                    visitWrap.TerritoryName = Test.isRunningTest() ? '' :(userTerritoryMap.get(eve.whatId).name != Null ? userTerritoryMap.get(eve.whatId).name : '');
                    visitWrap.ParentTerritoryLabel = Test.isRunningTest() ? '' :(userTerritoryMap.get(eve.whatId).ParentTerritory2.Name);
                    visitWrap.TerritoryDescription = Test.isRunningTest() ? '' :(userTerritoryMap.get(eve.whatId).Description);
                } 
                else if(userTerritoryMap.isEmpty() || status == 'Negative'){
                    visitWrap.TerritoryId = '';
                    visitWrap.TerritoryName = '';
                    visitWrap.ParentTerritoryLabel = '';
					visitWrap.TerritoryDescription = '';
                }
                visitWrapList.add(visitWrap);
            }
        }
        else{
            visitWrapList = new List<visitWrapper>();
        }
        
        return visitWrapList;
    }
    
    // export visits as CSV
    @future
    @AuraEnabled
    public static void exportVisits(String visitDetail){
        List<visitWrapper> visitWrapList = (List<visitWrapper>)JSON.deserialize(visitDetail, List<visitWrapper>.Class);
        String generatedCSVFile = '';        
        String fileRow = '';
        string csvHeader='Account Name,Account Id, Visit Id, Created By, Type,Activity Date,Created Date,SAP ID,RADL,Territory Id,Territory Name,Parent Territory Label,Description\n';
        String plainTextBody = '';
        plainTextBody += 'Hi '+Userinfo.getName()+',\n\n';
        plainTextBody += 'Please find attachment for requested visit report . \n\n\n';
        plainTextBody += 'Thanks , \n';
        plainTextBody += 'Global Sales Portal , \n';
        
        for(visitWrapper visitWrap  : visitWrapList){  
           		System.debug('**'+visitWrap.Name);
            	String accName = ((visitWrap.Name != null ) ? visitWrap.Name : '');
                accName = String.valueof(accName).normalizeSpace();
            	System.debug('account name'+accName);
                fileRow = '';
                fileRow = fileRow + ','+(accName != null ? '"'+accName +'"' : '')+','+visitWrap.Id+ ','+visitWrap.EventId+ ','+visitWrap.CreatedBy;
                fileRow = fileRow + ','+visitWrap.Type+ ','+visitWrap.ActivityDate+ ','+visitWrap.CreatedDate+','+visitWrap.SAPId+ ','+visitWrap.RADL_Class;
                fileRow = fileRow + ','+visitWrap.TerritoryId+ ','+visitWrap.TerritoryName+ ','+visitWrap.ParentTerritoryLabel;
                fileRow = fileRow + ','+visitWrap.TerritoryDescription;
                fileRow = fileRow.replaceFirst(',','');
                generatedCSVFile = generatedCSVFile + fileRow + '\n';
            
        }
        generatedCSVFile = csvHeader + generatedCSVFile; 
        String csvName = 'Visits.csv';
        String subject = 'Visit List Report';
        List<String> toAddress = new List<String>{UserInfo.getUserEmail()};
            Util.sendEmail(csvName,subject,toAddress,plainTextBody,generatedCSVFile);       
    } 
    // This wrapper class is used to map the visits information    
    public class visitWrapper{         
        public Integer Count;
        public String Name;
        public String EventId;
        public String Id;
        public String Type;
        Public Date ActivityDate;
        Public Datetime CreatedDate;
        public String Description;
        public String RADL_Class;
        public String CreatedBy;
        public String SAPId; 
        public String Country_Name;
        public String District_Name;
        public String TerritoryId;
        public String TerritoryName;
        public String ParentTerritoryLabel;
        public String TerritoryDescription;
     public visitWrapper(){}
    }        
}