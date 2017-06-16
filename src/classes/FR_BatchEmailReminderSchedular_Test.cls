/****************************************************************************************************** 
* @author : Cognizant technology solutions.
* @version : 1.0
* @objects Referenced :Account,Event
* @Description : This test class is covering code lines for apex class "FR_BatchRemainderEmailScheduler"
*******************************************************************************************************/
@isTest
global class FR_BatchEmailReminderSchedular_Test {
public static String CRON_EXP = '0 00 23 * * ?';
    
    static testmethod void test(){
        Test.startTest();
        String jobId = System.schedule('Frontier_ScheduleApexClassTest',
                                       CRON_EXP, 
                                       new FR_BatchEmailReminderSchedular());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        System.assertEquals(CRON_EXP, ct.CronExpression);        
        System.assertEquals(0, ct.TimesTriggered);       
        Test.stopTest();
        
    }
}