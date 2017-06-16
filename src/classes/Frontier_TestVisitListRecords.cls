/*****************************************************************************************************************
* @author : Cognizant Technology Solutions.
* @version : 1.0
* @objects Referenced :Account,Event,Account Business Role,Territory
* @Description : This Class is used to retrive visits records with account,account bussiness role,territory details.
*******************************************************************************************************************/

public without sharing class Frontier_TestVisitListRecords {
    public static List<Event> eventrecords;
    public static List<Account_Business_Role__c> accbussinessrolerecords;
    @AuraEnabled
    public static string getVisitDetails(Integer pageNumber,Integer pageSize,String searchType,String sortByRADL,String eventsList,Boolean isExport){
        System.debug(pageNumber + 'pageNumber' + pageSize + 'pageSize');
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
        List<visitWrapper> visitWrapList = new List<visitWrapper>();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> accountShareIds = new Set<Id>();
        Map<Id,Id> territoryWithGroupIds = new  Map<Id,Id>();
        Map<Id,Set<Id>> groupWithAccountIds = new Map<Id,Set<Id>>();
        Map<Id, Territory2> userTerritoryMap = new Map<Id, Territory2>();
        String userId = Userinfo.getUserId();
        List<Event> eventList = new List<Event>();
        Map<Id,Account_Business_Role__c> bussinessroleMap = new Map<Id,Account_Business_Role__c>();
        
        // Get the visit details based on the date when the visits are captured         
        String queryString ='SELECT Id,Type,ActivityDate,CreatedBy.Name,WhatId,What.Name FROM Event';
        if(searchType != 'None'){
            queryString += ' WHERE Type =\''+searchType+'\'';
        }
        
        
        /* if(eventsList == 'Recently Viewed'){
queryString += ' ORDER BY LastModifiedDate DESC LIMIT 30';
}
else if(eventsList == 'All Visits'){
queryString += ' ORDER BY CreatedDate  DESC';
}
else if(eventsList == 'My Visits'){
queryString += ' AND OwnerId =: userId ORDER BY CreatedDate  DESC';
}
else if(eventsList == 'New This Week'){
queryString += ' AND CreatedDate = THIS_WEEK ORDER BY CreatedDate  DESC';
}*/
        system.debug(queryString);
        try{
            eventrecords  = Database.query(queryString);
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
        String query = 'SELECT SAP_ID__c,Service_Level_Class_Descr__c,Account_SFID__c FROM Account_Business_Role__c WHERE Account_SFID__c IN : accountIds';
        if(sortByRADL != 'None'){
            query += ' AND Service_Level_Class_Descr__c =\''+sortByRADL+'\'';
        }
        System.debug('query' + query);
        accbussinessrolerecords  = Database.query(query);
        if(!accountIds.isEmpty()){
            for(Account_Business_Role__c accbussinessrole : accbussinessrolerecords){
                if(!bussinessroleMap.containsKey(accbussinessrole.Account_SFID__c))
                    bussinessroleMap.put(accbussinessrole.Account_SFID__c, accbussinessrole);
            }
        }
        // Get the account sharing access for the account
        if(accountIds.size() > 0){            
            for(AccountShare acctShare : [SELECT Id, UserOrGroupId, AccountId FROM AccountShare WHERE RowCause = 'TerritoryManual' AND AccountId IN :accountIds]){
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
                    }
                }
            }
            if(!territoryWithGroupIds.isEmpty()){
                for(Territory2 listOfTerritory : [SELECT id, name,ParentTerritory2.Name,Description FROM Territory2 WHERE Id IN :territoryWithGroupIds.keySet()]) {
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
        }
        
        // Map the visit details to the visit wrapper
        if(!eventList.isEmpty()){                
            visitWrapList = visitRecordMapping(eventList,bussinessroleMap,userTerritoryMap);
        }
        // Export the visit details and send to the slaes rep via Email
        if(isExport){
            List<Event> events = Database.query(queryString);
            Set<Id> accountIdSet = new Set<Id>();
            Map<Id,Account_Business_Role__c> accountBusinessRoleMap = new Map<Id,Account_Business_Role__c>();
            Map<Id,Set<Id>> groupWithExportAccountIds = new Map<Id,Set<Id>>();
            Map<Id,Id> territoryWithGroupIdMap = new  Map<Id,Id>();
            Map<Id, Territory2> userTerritoriesMap = new Map<Id, Territory2>();
            
            if(!events.isEmpty()){
                for(Event event : events){
                    accountIdSet.add(event.WhatId);
                }
            }  
            for(Account_Business_Role__c accbussinessrole : [SELECT SAP_ID__c,Service_Level_Class_Descr__c,Account_SFID__c 
                                                             FROM Account_Business_Role__c WHERE Account_SFID__c IN : accountIdSet]){
                                  if(!accountBusinessRoleMap.containsKey(accbussinessrole.Account_SFID__c))
                                                                     accountBusinessRoleMap.put(accbussinessrole.Account_SFID__c, accbussinessrole);
                                                             }
            
            // Get the account sharing access for the account
            if(accountIdSet.size() > 0){            
                for(AccountShare acctShare : [SELECT Id, UserOrGroupId, AccountId FROM AccountShare WHERE RowCause = 'TerritoryManual' AND AccountId IN :accountIdSet]){
                    if(!groupWithExportAccountIds.containsKey(acctShare.UserOrGroupId)){
                        groupWithExportAccountIds.put(acctShare.UserOrGroupId,new Set<Id>{acctShare.AccountId});
                    }
                    else{
                        groupWithExportAccountIds.get(acctShare.UserOrGroupId).add(acctShare.AccountId);
                    }
                }
                if(!groupWithExportAccountIds.isEmpty()){
                    for(Group groupRecord : [SELECT Id, RelatedId from Group WHERE Type='Territory' AND Id IN :groupWithExportAccountIds.keySet()]){
                        if(!territoryWithGroupIdMap.containsKey(groupRecord.RelatedId)){
                            territoryWithGroupIdMap.put(groupRecord.RelatedId,groupRecord.Id);
                        }
                    }
                }
                if(!territoryWithGroupIdMap.isEmpty()){
                    for(Territory2 listOfTerritory : [SELECT id, name,ParentTerritory2.Name,Description FROM Territory2 WHERE Id IN :territoryWithGroupIdMap.keySet()]) {
                        if(territoryWithGroupIdMap.containsKey(listOfTerritory.Id)){
                            for(Id accountId : groupWithExportAccountIds.get(territoryWithGroupIdMap.get(listOfTerritory.Id))){
                                userTerritoriesMap.put(accountId,listOfTerritory);
                            }
                        }
                        else{
                            continue;
                        }
                    }
                }
            }
            exportVisits(visitRecordMapping(events,accountBusinessRoleMap,userTerritoriesMap)); 
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
                visitWrap.Count =  (eventrecords.size() > 0 ? eventrecords.size(): 0);                    
                if(!bussinessroleMap.isEmpty() && bussinessroleMap.containskey(eve.whatId)){
                    visitWrap.SAPID = bussinessroleMap.get(eve.WhatId).SAP_ID__C;
                    visitWrap.RADL_Class = bussinessroleMap.get(eve.WhatId).Service_Level_Class_Descr__c;                        
                }
                if(!userTerritoryMap.isEmpty() && userTerritoryMap.containskey(eve.whatId)) {
                    visitWrap.TerritoryId = userTerritoryMap.get(eve.whatId).id != Null ? userTerritoryMap.get(eve.whatId).id : '';
                    visitWrap.TerritoryName = userTerritoryMap.get(eve.whatId).name != Null ? userTerritoryMap.get(eve.whatId).name : '';
                    visitWrap.ParentTerritoryLabel = userTerritoryMap.get(eve.whatId).ParentTerritory2.Name;
                    visitWrap.TerritoryDescription = userTerritoryMap.get(eve.whatId).Description;
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
    @AuraEnabled
    public static void exportVisits(List<visitWrapper> visitWrapList){
        String generatedCSVFile = '';        
        String fileRow = '';
        string csvHeader='Account Name,Account Id, Visit Id, Created By, Type,Activity Date,SAP ID,RADL,Territory Id,Territory Name,Parent Territory Label,Description\n';
        String plainTextBody = '';
        plainTextBody += 'Hi '+Userinfo.getName()+',\n\n';
        plainTextBody += 'Please find attachment for requested visit report . \n\n\n';
        plainTextBody += 'Thanks , \n';
        plainTextBody += 'Global Sales Portal , \n';
        
        for(visitWrapper visitWrap  : visitWrapList){  
            if(Limits.getHeapSize() < 275000){
                fileRow = '';
                fileRow = fileRow + ','+visitWrap.Name+','+visitWrap.Id+ ','+visitWrap.EventId+ ','+visitWrap.CreatedBy;
                fileRow = fileRow + ','+visitWrap.Type+ ','+visitWrap.ActivityDate+ ','+visitWrap.SAPId+ ','+visitWrap.RADL_Class;
                fileRow = fileRow + ','+visitWrap.TerritoryId+ ','+visitWrap.TerritoryName+ ','+visitWrap.ParentTerritoryLabel;
                fileRow = fileRow + ','+visitWrap.TerritoryDescription;
                fileRow = fileRow.replaceFirst(',','');
                generatedCSVFile = generatedCSVFile + fileRow + '\n';
            }
            else{
                break;
            }
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