@isTest
public class Frontier_TaskController_Test {
 @testSetup
    static void setup(){
        TestUtilClass.createTestAccount(4);
        TestUtilClass.createTask(4,'InProgress');
        TestUtilClass.createTestUsers('System Administrator',2);
       
    }
    static testmethod void taskRecordManipulation() {
        Task task = [SELECT Id FROM Task LIMIT 1];
        // Load the record upon component Initialization
        Frontier_TaskController.findActivities(1,10,'All Tasks',null,true,false,task.Id);
        // Paginate to the next page without any filter
        Frontier_TaskController.findActivities(1,10,'All Tasks',null,false,true,task.Id);
        // Order the event records based on the field which is triggered
        Frontier_TaskController.findActivities(1,10,'All Tasks','ActivityDate-DESC',false,false,task.Id);
        // Pass the triggered field to the next page for sorting
        Frontier_TaskController.findActivities(1,10,'All Tasks','ActivityDate-ASC',false,true,task.Id);
         Frontier_TaskController.findActivities(1,10,'All Tasks','What.name-ASC',false,true,task.Id);
        
        // Apply the filter under the views
        Frontier_TaskController.findActivities(1,10,'Recently Viewed',null,false,false,task.Id);
        Frontier_TaskController.findActivities(1,10,'Recently Viewed',null,false,true,task.Id);
        Frontier_TaskController.findActivities(1,10,'Recently Viewed','CreatedBy.Name-ASC',false,false,task.Id);
        Frontier_TaskController.findActivities(1,10,'Recently Viewed','CreatedBy.Name-ASC',false,true,task.Id);
        
        
        
        Frontier_TaskController.findActivities(1,10,'New This Week',null,false,false,task.Id);
        Frontier_TaskController.findActivities(1,10,'New This Week',null,false,true,task.Id);
        //Frontier_TaskController.findActivities(1,10,'New This Week','CreatedBy.Name-ASC',false,false,task.Id);
        //Frontier_TaskController.findActivities(1,10,'New This Week','CreatedBy.Name-DESC',false,true,task.Id);
        
        Frontier_TaskController.findActivities(1,10,'My Tasks',null,false,false,task.Id);
        Frontier_TaskController.findActivities(1,10,'My Tasks',null,false,true,task.Id);
        //Frontier_TaskController.findActivities(1,10,'My Tasks','What.Name-ASC',false,false,task.Id);
        //Frontier_TaskController.findActivities(1,10,'My Tasks','What.Name-DESC',false,true,task.Id);  
    }
}