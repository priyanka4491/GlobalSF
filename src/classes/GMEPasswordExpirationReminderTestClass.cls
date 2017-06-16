@isTest(SeeAllData=true)
private class GMEPasswordExpirationReminderTestClass {
    public static string CRON_EXP = '0 0 0 15 3 ? 2022';
    private static testmethod void test(){
                List<User> listOfUsers = new List<User>();
                Date d=Date.today()+7-90;
                Test.startTest();
                String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP, new GMEPasswordExpirationReminder());
                CronTrigger ct = [select Id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id=:jobid];
                system.assertEquals(CRON_EXP,ct.CronExpression);
                system.assertEquals(0,ct.TimesTriggered);
                system.assertEquals('2022-03-15 00:00:00',String.valueOf(ct.NextFireTime));
                listOfUsers=[select id,name,Email,LastPasswordChangeDate from User where LastPasswordChangeDate=:d and (username like 'conductor.integration.service@monsanto.com%' or username like 'help.idm@monsanto.com%')];
                system.assertEquals(listOfUsers.size(),0);
                Test.stopTest();
                                }
            }