/* 

    * @author : Cognizant technology solutions.
    * @version : 1.0
    * @objects Referenced : Task
    * @Description : To send remainder email before 7 days of due date

*/

@isTest
public class Frontier_BatchRemainderEmail_Test {
    
    public static testMethod void batchReminderEmail(){        
        Test.startTest();
        List<Account> accList = TestUtilClass.createTestAccount(2);
        List<Task> taskList = TestUtilClass.createTask(5,'In Progress');
        Database.executeBatch(new Frontier_BatchRemainderEmail());
        Test.stopTest();
    }

}