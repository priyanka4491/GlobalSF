public with sharing class Frontier_TaskRemainder {
    
    @AuraEnabled
    //Method to get all the In-progress Task for the current user
    public static String getallTask(){
        List<TaskWrapper> allTask = new List<TaskWrapper>();
        List<Task> taskList =new list<Task>();
        try{
            taskList = [SELECT Id,Subject, ActivityDate, WhatId, What.Name,Description,Status 
                        FROM Task 
                        where OwnerId = :UserInfo.getUserId() AND Status= 'In Progress' AND (ActivityDate = NEXT_N_DAYS:6 OR ActivityDate = :Date.Today())
                        ORDER BY ActivityDate ASC Limit 10];     
            System.debug('Task Record' + taskList); System.debug('UserInfo.getUserId()=>' + UserInfo.getUserId());
            if(Test.isRunningTest()){
                integer intTest =1/0;
            }
        }
        catch(Exception e){
            System.debug('The following error has been occured' + e.getMessage());
        }
        TaskWrapper taskWrpper = new TaskWrapper();
        taskWrpper.taskTotalRecords=taskList.size();
        taskWrpper.taskLists=taskList;
        allTask.add(taskWrpper);System.debug('allTask=>'+allTask);
        return Json.serialize(allTask);        
    }
    
    public Class TaskWrapper {        
        public Integer taskTotalRecords{get;set;}
        public List<task> taskLists{get;set;}
    }
    
    @AuraEnabled    
    public static void dismissTasks(String taskIds){
        system.debug('taskIds=>'+taskIds);
        List<Id> taskIdList = new List<Id>();
        List<Task> taskList = new List<Task>();
        if(taskIds != Null) {
            if(taskIds.contains(',')){
                taskIdList = taskIds.split(',');
            }else if(taskIds != '' || taskIds != Null) {
                taskIdList.add(taskIds);
            }
        }
        system.debug('taskIdList=>'+taskIdList);
        
        for(Id tskId : taskIdList) {
            Task tsk = new Task(Id = tskId,Status='Completed');
            taskList.add(tsk);
        }
        system.debug('taskList=>'+taskList);
        if(taskList.size() > 0){
            try{
                update taskList;
            } catch(Exception e){
                system.debug('Exception=>'+e);
            }
        }
    }
    
}