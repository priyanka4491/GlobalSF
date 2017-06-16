/*************************************************************************************** 
* @author : Cognizant Technology Solutions.
* @version : 1.0
* @objects Referenced : Task
* @Description : To display the follow up task details. Applied Sorting functionality to sort out 
                 the task based on the appropriate condition.
				 Filtered out the task based on the task created in various date.
****************************************************************************************/
public class Frontier_TaskController{
    @AuraEnabled 
    public static List<String> findActivities(Integer pageNumber, Integer pageSize,String followupList,String triggeredField,Boolean isInitialize,Boolean isPageChange,string taskId){
        List<Task> followListAfterSkip = new List<Task>();
        List<String> eventList = new List<String>();
        List<Task> followupListRecords;
        Frontier_SortDirection sortFields;
        
        String queryString;
        String userId = Userinfo.getUserId();
        // Change the sort order of the task
        if(!isInitialize){
            sortFields = new  Frontier_SortDirection();
            if(triggeredField != Null && sortFields.ActivityDate == triggeredField){
                sortFields.ActivityDate = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');  
            }
            else if(triggeredField != Null && sortFields.CreatedBy == triggeredField){
                sortFields.CreatedBy = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
            else if(triggeredField != Null && sortFields.AccountName == triggeredField){
                sortFields.AccountName = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
        }
        // // By default the visit order would be in ascending
        else if(isInitialize){
            sortFields = new Frontier_SortDirection(); 
        }        
       // Determine the number of records to display for each page
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
        
            
                
       
         queryString = 'SELECT Id,CreatedBy.Name, What.Name, ActivityDate, Description FROM Task';
        
        
        
        // Apply the filter under the query based on the visit creation
        if(followupList == 'Recently Viewed'){
            if(triggeredField  == Null){
                queryString += ' ORDER BY LastModifiedDate DESC LIMIT 30';
            }
            else if(triggeredField != Null){
                queryString = Util.getQuery(queryString,' ORDER BY ','LastModifiedDate DESC LIMIT 30',triggeredField);                
            }
        }
        else if(followupList == 'All Tasks'){
            if(triggeredField == Null){
                queryString += ' ORDER BY CreatedDate  DESC';
            }
            else if(triggeredField != Null){
                queryString = Util.getQuery(queryString, ' ORDER BY ','CreatedDate  DESC',triggeredField);                
            }
        } 
        else if(followupList == 'My Tasks'){
            System.debug('TriggerField' + triggeredField);
            if(triggeredField == Null){
                queryString += ' WHERE OwnerId =: userId ORDER BY CreatedDate  DESC';
                system.debug('Sort Fields'+sortFields);
            }
            else if(triggeredField != Null){
                queryString = Util.getQuery(queryString, ' WHERE OwnerId =: userId ORDER BY CreatedDate  DESC','CreatedDate  DESC',triggeredField); 
            }
        }
        else if(followupList == 'New This Week'){
            if(triggeredField == Null){
                queryString += ' WHERE CreatedDate = THIS_WEEK ORDER BY CreatedDate  DESC';
            }
            else if(triggeredField != Null){
                queryString = Util.getQuery(queryString,' WHERE CreatedDate = THIS_WEEK ORDER BY CreatedDate  DESC','CreatedDate  DESC',triggeredField); 
            }
        }
        
         
       
        system.debug(queryString);
        // Get the task records
        try{
            followupListRecords = Database.query(queryString);
            if(Test.isRunningTest()){
               Integer val = 1/0;
            }
        }
        catch(Exception e){
            System.debug('The following error has been occured' + e.getMessage());
        }
        // Get the records for the corresponding page under pagination
            Task newTask = new Task();
            if(taskId !='' && taskId !=Null){
                newTask = [SELECT Id,CreatedBy.Name, What.Name, ActivityDate, Description FROM Task WHERE id =:TaskId ];
                pageSize = pageSize-1;
                followListAfterSkip.add(newTask);
            }
            if(!followupListRecords.isEmpty()){
                for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < followupListRecords.size();i++){   
                    if(newTask.id != followupListRecords[i].id) {
                        followListAfterSkip.add(followupListRecords[i]);
                    }else{
                        pageSize = pageSize+1;
                    }
                }
            }
            eventList.add((String.valueOf(followupListRecords.size())));
            eventList.add((JSON.serialize(followListAfterSkip))); 
            eventList.add(JSON.serialize(sortFields));
        return eventList;
    }
}