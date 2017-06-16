/***********************************************************************************
* @author : Cognizant technology solutions.
* @version : 1.0
* @objects Referenced :Account,Event
* @Description : Scheduler for Reminder Email which tasks that are not closed for last 7 days
**********************************************************************************/
global class FR_BatchEmailReminderSchedular implements Schedulable{
    global void execute(SchedulableContext sc) {
        Frontier_BatchRemainderEmail task = new Frontier_BatchRemainderEmail(); 
        Database.executebatch(task);
    }
}