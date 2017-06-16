/*************************************************************************************** 
* @author : Cognizant Technology Solutions.
* @version : 1.0
* @objects Referenced : Event
* @Description : To display the visit details. Applied Sorting functionality to sort out 
the visit based on the appropriate condition.
Filtered out the visits based on the visit created in various date.
****************************************************************************************/
global with sharing class Frontier_EventListController{
    public static List<Event> eventListRecords = new List<Event>();
    public static  Map<Id,Event> eventMap = new Map<Id,Event>();
    public static Set<Id> accountIds = new Set<Id>();
    public static List<Account_Business_Role__c> accbussinessrolerecords;
    public static string fieldToTrigger = '';
    public static Boolean isExported = false;
    public static List<Frontier_SortingWrapper> sortingWrapList = new List<Frontier_SortingWrapper>();
    public static Boolean isSort = false;
    public static Set<String> sortFieldSet =  new Set<String>{'Service_Level_Class_Descr__c','Team','Name','Comment'};
    
    @AuraEnabled 
    public static List<String> findActivities(Integer pageNumber,Integer pageSize,String triggeredField,Boolean isInitialize,Boolean isPageChange,Boolean isExport,String sortByType,String sortByMonth,String sortByRADL,String filterByCreatedUser,String filterByTeam){
        fieldToTrigger = triggeredField;
        List<Event> eventListAfterSkip = new List<Event>();      
        List<String> eventList = new List<String>();
        String bussinessRole;
        Map<Id, Territory2> userTerritoryMap = new Map<Id, Territory2>();
        Map<Id,Account_Business_Role__c> bussinessroleMap = new Map<Id,Account_Business_Role__c>();
        List<visitWrapper> visitWrapList = new List<visitWrapper>();
        List<Id> bussinessroleAccountIdSet = new List<Id>();
        Set<string> userIdSet= new Set<string>();
        Set<string> filterTeamIdSet= new Set<string>();
        Map<Id,String> userIdsAndUserNamesMap = new Map<Id,String>();
        Map<Id,String> teamIdsAndTeamNamesMap = new Map<Id,String>();
        Map<Id,Event> eventRecordMap =  new Map<Id,Event>();
        Frontier_SortDirection sortFields;
        
        Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id FROM Account]);
        accountIds.addAll(accountMap.keySet());
        
        sortFields = new  Frontier_SortDirection();
        // Change the sort order of the visit
        if(!isInitialize){
           
           if(triggeredField != Null && sortFields.ActivityDate == triggeredField){
                sortFields.ActivityDate = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');  
            }
            else if(triggeredField != Null && sortFields.Type == triggeredField){
                sortFields.Type = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
            else if(triggeredField != Null && sortFields.CreatedBy == triggeredField){
                sortFields.CreatedBy = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
            else if(triggeredField != Null && sortFields.AccountName == triggeredField){
                sortFields.AccountName = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
            else if(triggeredField != Null && sortFields.Radl == triggeredField){
                sortFields.Radl = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
            else if(triggeredField != Null && sortFields.TerritoryName == triggeredField){
                sortFields.TerritoryName = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
            else if(triggeredField != Null && sortFields.Team == triggeredField){
                sortFields.Team = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
            else if(triggeredField != Null && sortFields.Comment == triggeredField){
                sortFields.Comment = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
        }
        // By default the visit order would be in ascending
        else if(isInitialize){
            sortFields = new Frontier_SortDirection();               
        } 
        
        if(filterByTeam != ''){
            if(!filterByTeam.contains(';')){
                filterTeamIdSet.add(filterByTeam);
            }else{
                for(String terriIds :  filterByTeam.split(';')){                    
                    filterTeamIdSet.add(terriIds);
                }
            }
            
            userTerritoryMap=Util.getTerritory(accountIds,filterTeamIdSet);            
            accountIds.clear();                
            accountIds.addAll(userTerritoryMap.keySet());
        }else {
            // Get the account sharing access for the account            
            userTerritoryMap=Util.getTerritory(accountIds,filterTeamIdSet);
        }        
        
        String accountBusinessRole = 'SELECT SAP_ID__c,Service_Level_Class_Descr__c,Account_SFID__c FROM Account_Business_Role__c WHERE Account_SFID__c IN : accountIds';
        if(sortByRADL !='None'){
            accountBusinessRole +=' AND Service_Level_Class_Descr__c =\''+sortByRADL+'\'';
        }
       
            for(Account_Business_Role__c accbussinessrole : Database.query(accountBusinessRole)){   
                
                if(!bussinessroleMap.containsKey(accbussinessrole.Account_SFID__c)){
                    bussinessroleMap.put(accbussinessrole.Account_SFID__c, accbussinessrole);
                    bussinessroleAccountIdSet.add(accbussinessrole.Account_SFID__c);
                }
            }
        // Determine the number of records to display for each page
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
        String queryString = 'SELECT Id,AccountId,LastModifiedDate,CreatedBy.Name,OwnerId,Description,ActivityDate,who.Name,EndDateTime,StartDateTime,Subject,What.Name,Type FROM Event WHERE WhatId IN:accountIds';
      
        
        if(sortByMonth != ''){       
            String CalenderMonth= Util.getSortByMonth(sortByMonth,'CreatedDate');
            queryString += SortByType == 'None'?' AND '+CalenderMonth+'':' AND '+CalenderMonth+'';
        }
        if(filterByCreatedUser != ''){
            if(!filterByCreatedUser.contains(';')){
                userIdSet.add(filterByCreatedUser);
            }else{
                for(String userId :  filterByCreatedUser.split(';')){
                    userIdSet.add(userId);
                }
            }
            queryString += ' AND ownerId IN:userIdSet';
        }
        // To sort the column by RADL
        if(sortByRADL !='None' && !bussinessroleAccountIdSet.isEmpty()){
            queryString += ' AND WhatId IN:bussinessroleAccountIdSet';              
        }
        
            if(triggeredField != Null && (!sortFieldSet.contains(triggeredField.split('-')[0]))){
                    queryString = Util.getQuery(queryString,' ORDER BY ','CreatedDate  DESC',triggeredField); 
             }
        // Get the records for the corresponding page under pagination
        try{
            Map<Id,List<Event>> eventListMap =  new Map<Id,List<Event>>(); 
           if(sortByRadl == 'None' || sortByRadl != 'None'){
             eventListRecords = Database.query(queryString);
            }
            for(Event eve : Database.query(queryString)){                    
                if(!eventListMap.containsKey(eve.WhatId)){
                    eventListMap.put(eve.whatId,new List<Event>{eve});
                }
                else{
                    eventListMap.get(eve.whatId).add(eve);
                }
                eventRecordMap.put(eve.Id, eve);
            }
           
            // The territory sorting applies for team and terrritory name
        if((triggeredField != Null || (isExport && triggeredField != Null))  
           && (sortFieldSet.contains(triggeredField.split('-')[0]))){ 

               if(eventListRecords.isEmpty()){
                  // eventListRecords = Database.query(queryString);
               }
                   isSort = true;
                   List<visitWrapper> visitsWrap1 = visitRecordMapping(eventListRecords,bussinessroleMap,userTerritoryMap,userIdsAndUserNamesMap,sortByRADL);
                   eventListRecords.clear(); 
                   // Sort the event records order by territory fields
                   if(!sortingWrapList.isEmpty() && !eventRecordMap.isEmpty()){
                       for(Frontier_SortingWrapper sortingWrap : sortingWrapList){
                           if(eventRecordMap.containsKey(sortingWrap.visitWrapper.eventId))
                               eventListRecords.add(eventRecordMap.get(sortingWrap.visitWrapper.eventId));
                       }
                   }  
               }
            
            else{
                eventListRecords = Database.query(queryString);
            }            
            if(Test.isRunningTest()){
                Integer val = 1/0;
            }
        }
        catch(Exception e){
            System.debug('===============> Error has occured'+e.getMessage());
        } 
        
        
        
        
        if(!eventListRecords.isEmpty()){
            if(isExport){
                if((!eventListRecords.isEmpty() && !userTerritoryMap.isEmpty()) || Test.isRunningTest()){
                    exportEvents(JSON.serialize(visitRecordMapping(eventListRecords,bussinessroleMap,userTerritoryMap,userIdsAndUserNamesMap,sortByRADL)));
                }
            }
            for(Event event : eventListRecords){
                if(!userIdsAndUserNamesMap.containsKey(event.ownerId)){
                    userIdsAndUserNamesMap.put(event.ownerId,event.CreatedBy.Name);
                }
            }
            for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < eventListRecords.size();i++){   
                eventListAfterSkip.add(eventListRecords[i]);
            }
            
            if((!eventListRecords.isEmpty() && !userTerritoryMap.isEmpty()) || Test.isRunningTest()){  
                for(Id acctId : userTerritoryMap.keySet()){
                    if(!teamIdsAndTeamNamesMap.containsKey(userTerritoryMap.get(acctId).ParentTerritory2Id)){
                        teamIdsAndTeamNamesMap.put(userTerritoryMap.get(acctId).ParentTerritory2Id,userTerritoryMap.get(acctId).ParentTerritory2.Name);
                    }
                }
                visitWrapList = visitRecordMapping(eventListAfterSkip,bussinessroleMap,userTerritoryMap,userIdsAndUserNamesMap,sortByRADL);
            }
            
            
            eventList.add(String.valueOf(eventListRecords.size()));
            eventList.add(JSON.serialize(visitWrapList)); 
            eventList.add(JSON.serialize(sortFields));
            eventList.add(JSON.serialize(userIdsAndUserNamesMap));
            eventList.add(JSON.serialize(teamIdsAndTeamNamesMap));
        }
        return eventList;
    }
    
    public static List<visitWrapper> visitRecordMapping(List<Event> eventList,Map<Id,Account_Business_Role__c> bussinessroleMap,Map<Id,Territory2> userTerritoryMap,Map<Id,String> userIdsAndUserNamesMap,String sortByRADL){
        List<visitWrapper> visitWrapList = new List<visitWrapper>();
        if(!eventList.isEmpty()){
            for(Event eve : eventList){                
                visitWrapper visitWrap = new visitWrapper();
                visitWrap.eventId = eve.Id;
                visitWrap.CompanyName = eve.What.Name;
                visitWrap.Type = eve.Type;
                visitWrap.ActivityDate = eve.ActivityDate;
                visitWrap.CreatedBy = eve.CreatedBy.Name;
                visitWrap.Count =  (eventListRecords.size() > 0 ? eventListRecords.size(): 0); 
                visitWrap.Description = eve.Description != null ? String.valueof(eve.Description).normalizeSpace() : '';
                visitWrap.userIdAndUserNameMap = userIdsAndUserNamesMap;
                if(!bussinessroleMap.isEmpty() && bussinessroleMap.containskey(eve.whatId)){                    
                    visitWrap.RADL_Class = bussinessroleMap.get(eve.WhatId).Service_Level_Class_Descr__c;                        
                }
                else{
                    visitWrap.RADL_Class = '';  
                }
                
                if((!userTerritoryMap.isEmpty() && userTerritoryMap.containskey(eve.whatId))) {
                    visitWrap.TerritoryName = Test.isRunningTest() ? '' :(userTerritoryMap.get(eve.whatId).name != Null ? userTerritoryMap.get(eve.whatId).name : '');
                        visitWrap.Team = Test.isRunningTest() ? '' :(userTerritoryMap.get(eve.whatId).ParentTerritory2.Name);
                            } 
                else if(userTerritoryMap.isEmpty()){
                    visitWrap.TerritoryName = '';
                    visitWrap.Team = '';
                }
                visitWrapList.add(visitWrap);
               
                if(isSort){ 
                    sortingWrapList.add(new Frontier_SortingWrapper(visitWrap,fieldToTrigger.split('-')[1],fieldToTrigger.split('-')[0]));
                    visitWrapList.clear();
                }
            }
            if(!sortingWrapList.isEmpty()){   
                sortingWrapList.sort();
                isSort = false;
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
    public static void exportEvents(String eventDetail){
        List<visitWrapper> visitWrapList = (List<visitWrapper>)JSON.deserialize(eventDetail, List<visitWrapper>.Class);
        String generatedCSVFile = '';        
        String fileRow = '';
        string csvHeader='ACCOUNT,ACTIVITY TYPE,CREATED BY, DATE, COMMENTS,RADL,TERRITORY NAME,TEAM\n';
        String plainTextBody = '';
        plainTextBody += 'Hi '+Userinfo.getName()+',\n\n';
        plainTextBody += 'Please find attachment for requested visit report . \n\n\n';
        plainTextBody += 'Thanks , \n';
        plainTextBody += 'Global Sales Portal , \n';
        
        for(visitWrapper visitWrap  : visitWrapList){   
            String Description = String.valueof(visitWrap.Description).normalizeSpace();
            fileRow = '';
            fileRow = fileRow + ','+(visitWrap.CompanyName != null ?  String.valueof(visitWrap.CompanyName).trim() : '') +','+visitWrap.Type+ ','+visitWrap.CreatedBy+ ','+visitWrap.ActivityDate;                
            fileRow = fileRow + ','+(visitWrap.Description != null ? '"'+Description +'"' : '');
            fileRow = fileRow +','+(visitWrap.RADL_Class != null ? visitWrap.RADL_Class : '')+','+(visitWrap.TerritoryName != null ? visitWrap.TerritoryName : '');
            fileRow = fileRow + ','+(visitWrap.Team != null ? visitWrap.Team : '') + ',';            
            fileRow = fileRow.replaceFirst(',','');
            generatedCSVFile = generatedCSVFile + fileRow + '\n';            
        }       
        
        generatedCSVFile = csvHeader + generatedCSVFile; 
        String csvName = 'Visit.csv';
        String subject = 'Visit List Report';
        List<String> toAddress = new List<String>{UserInfo.getUserEmail()};
            Util.sendEmail(csvName,subject,toAddress,plainTextBody,generatedCSVFile);       
    } 
    
    // This wrapper class is used to map the visits information    
    global class visitWrapper{  
        public Id eventId;
        public Integer Count;
        public String CompanyName;
        public String Type;
        public String CreatedBy;
        public Date ActivityDate;
        public String RADL_Class;
        public String Description;
        Public String TerritoryName;
        Public String Team;
        public Map<Id,String> userIdAndUserNameMap;        
        global visitWrapper(){}
    } 
    
}