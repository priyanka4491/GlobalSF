@isTest
public class Frontier_TaskRemainderTest {
	
    @testSetup
    static void setup(){
        TestUtilClass.createTestAccount(3);
        TestUtilClass.createTask(3,'In Progress');
    }
    
    public static testmethod void taskRemainder(){
        
        List<Task> taskList = [Select Id,status From Task];
        Frontier_TaskRemainder.getallTask();
        Frontier_TaskRemainder.dismissTasks(String.valueOf(taskList[0].Id));
        Frontier_TaskRemainder.dismissTasks(String.valueOf(taskList[0].Id)+','+String.valueOf(taskList[1].Id));
        system.debug('taskList[0].status=>'+taskList[0].status);
        system.assertEquals(taskList[0].status, 'In Progress');
        Frontier_TaskRemainder.dismissTasks(String.valueOf(taskList[0].Id)+','+String.valueOf(taskList[0].Id));//for handling exception

        
    }
}