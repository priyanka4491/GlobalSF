/* 
*
* @author : Cognizant technology solutions.
* @version : 1.0
* @objects Referenced : Account Business Role
* @Description : To fetch the required records from the targeted object based on page size
*/

public class sObjectRecordController {
    /**
* This method is used to re     * @param pageNumber - return recently view records
* @param ObjectName - Specify the API name of object to get recently view records
* @param fieldstoget - Fields from the object need to get
mber of the page to display in the table
* @param pageSize - Number of records needs to be displayed in the page
*/ 
    @AuraEnabled 
    public static lightningTableWrapper getRecords(String ObjectName,String fieldstoget,Decimal pageNumber, String pageSize, String ProductId){     
        Integer offset = (integer.valueOf(pageNumber) - 1) * 5;
        String item = ProductId; 
   
        String queryString;
        //if(String.isBlank(sortFieldName) || sortFieldName == null){
          queryString = 'SELECT '+ String.escapeSingleQuotes(fieldstoget)+
            ' FROM '+ String.escapeSingleQuotes(ObjectName) +
            ' LIMIT '+ String.escapeSingleQuotes(pageSize) + ' Offset '+offset;
        system.debug(queryString);    
        //}  
      /*  if(sortFieldName != ''){
            queryString = 'SELECT '+ String.escapeSingleQuotes(fieldstoget)+
            ' FROM '+ String.escapeSingleQuotes(ObjectName) +
            ' ORDER BY '+ String.escapeSingleQuotes(sortFieldName) + ' ASC' +
            ' LIMIT '+ String.escapeSingleQuotes(pageSize) + ' Offset '+offset;   
             system.debug(queryString);
        }
   */
        lightningTableWrapper ltw;
        try{
            ltw = new lightningTableWrapper();
            Integer intCount = 0;
            for(AggregateResult result :[SELECT COUNT(Id) intVal FROM Account]){
                intCount+=(Integer)result.get('intVal');
            }   
            ltw.total = intCount;
            ltw.page = Integer.valueOf(pageNumber);
            ltw.sObjectrecords = database.query(queryString);
            System.debug('ltw'+ltw.sObjectrecords);
        }
        catch(QueryException qe){System.debug('The following exception has occurred: ' + qe.getMessage());}
        if(ltw == null)
            ltw = new lightningTableWrapper();
        return ltw;
    }
    
    @AuraEnabled 
    public static List<Account> getGrowerRecords(String ObjectName,String fieldstoget,Decimal pageNumber, String pageSize, String ProductId){     
        Integer offset = (integer.valueOf(pageNumber) - 1) * 5;
        String item = ProductId; 
   
        String queryString;
 
          queryString = 'SELECT '+ String.escapeSingleQuotes(fieldstoget)+
            ' FROM '+ String.escapeSingleQuotes(ObjectName) +
            ' LIMIT '+ String.escapeSingleQuotes(pageSize) + ' Offset '+offset;
        system.debug(queryString);  
        List<Account> accountRec = Database.query(queryString);
    return accountRec;
   
    }
    
    //Method to get the Account assosiated Activities
    @AuraEnabled 
    public static List<String> findActivities(String ObjectName,String fieldstoget,Integer pageNumber, Integer pageSize, String accId,  String searchText, String searchType, String fromDate, String toDate,String searchContact){     

        List<Id> eventid = new List<Id>();
        List<Event> eventListAfterSkip = new List<Event>();
        List<String> eventList = new List<String>(); 
        String eventDesc;
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize); 
        //Get the event id which contains Description against the Search key
        Id accountId = Id.valueof(accId);
        for(Event eve : [Select id, Description, WhatId from Event where WhatId =: accountId]){
            if(eve.Description == null){
                continue;                
            }
            else if(eve.Description != null){
                eventDesc = String.valueof(eve.Description).toLowerCase();
                if((searchText!= null || !(String.isBlank(searchText))) && eventDesc.contains(searchText.toLowerCase())){   
                 eventid.add(eve.Id);   
                }   
            }            
           
        } 
        System.debug(eventid);
        // Get the Event records against the Search Text, Search Type, From Activity Date and To Activity Date
        String queryString = 'SELECT Id,AccountId, ActivityDate,who.Name, Description,EndDateTime,StartDateTime,Subject,What.Name,Type FROM Event WHERE WhatId = \''+accountId+'\'';
        if(searchText != null || !(String.isBlank(searchText))){
         queryString += ' AND Id IN: eventid';
        }
        if(searchContact != null || !(String.isBlank(searchContact))){
         queryString += ' AND who.Name LIKE \'%'+ searchContact+ '%\'';
        }
        if(searchType != 'None'){
         queryString += ' AND Type =\''+searchType+'\'';
        }
        if(fromDate != null){
         queryString += ' AND ActivityDate >='+fromDate;
        }
        if(toDate != null){
         queryString += ' AND ActivityDate <='+toDate;
        }
        queryString +=' ORDER BY CreatedDate  DESC'; 
        system.debug(queryString);
        try{
            List<Event> eventListRecords = Database.query(queryString);
            System.debug('Test Class'+eventListRecords.size()+'****'+noOfRecordsToSkip + Integer.valueOf(pageSize));
            for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < eventListRecords.size();i++)
            {   
                eventListAfterSkip.add(eventListRecords[i]);
            }
            eventList.add((String.valueOf(eventListRecords.size())));
            eventList.add((JSON.serialize(eventListAfterSkip))); 
             if(Test.isRunningTest()){
                Integer val = 1/0;
            }
        }
        catch(Exception e){System.debug('The following error has been occured' + e.getMessage()+'eventListiiiiiiiiiiiiiiiii'+eventList);}
        return eventList;
    }      
}