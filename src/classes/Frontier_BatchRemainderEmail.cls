/* 

    * @author : Cognizant technology solutions.
    * @version : 1.0
    * @objects Referenced : Task
    * @Description : To send remainder email before 7 days of due date

*/

global class Frontier_BatchRemainderEmail implements Database.Batchable<sObject>,Database.Stateful{
    
    global Map<string,List<Task>> ownerEmailAndTaskListMap = new Map<String,List<Task>>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        string query = 'SELECT Id,Subject, ActivityDate, WhatId, What.Name,Description,ownerId,owner.Email,owner.Name FROM Task where Status= \'In Progress\' AND (ActivityDate = NEXT_N_DAYS:6 OR ActivityDate = TODAY)';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Task> taskList){
    
        for(Task tsk : taskList) {
            //if(tsk.owner.Email == 'vijay.ramesh@monsanto.com' || tsk.owner.Email == 'anand.bazawada@monsanto.com' || tsk.owner.Email == 'charith.devulapalle@monsanto.com'){
                if(ownerEmailAndTaskListMap.get(tsk.owner.Email) == Null){
                    ownerEmailAndTaskListMap.put(tsk.owner.Email,new List<Task>{tsk});
                }else {
                    ownerEmailAndTaskListMap.get(tsk.owner.Email).add(tsk);
                }
            //}
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for(String emailId : ownerEmailAndTaskListMap.keySet()) {
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.toAddresses = new String[] { emailId };
            email.setSenderDisplayName('Monsanto Admin Team');
            email.setSubject('Follow Up Reminder');
            string activityData = '';
            string salesrep ='';
           
            for(Task tsk : ownerEmailAndTaskListMap.get(emailId)){
                salesrep = tsk.owner.Name;
                Date actDate = Date.valueOf(tsk.ActivityDate);
                String Description = tsk.Description != Null ? tsk.Description:'' ;
                activityData += ' <tr><td style="border:2px Solid black;">'+DateTime.newInstance(actDate.year(),actDate.month(),actDate.day()).format('YYYY-MM-dd')+'</td><td style="border:2px Solid black;">'+tsk.What.Name+'</td><td style="border:2px Solid black;">'+Description+'</td></tr>';
            }
            email.setHtmlBody('Hi '+salesrep +',<br /><br /> Please find your Follow Up Reminders below,<br /><br /><table style="border-collapse:collapse;"><thead><tr><th style="border:2px Solid black;"><strong>Follow-up Date</strong></th><th style="border:2px Solid black;"><strong>Account Name</strong></th><th style="border:2px Solid black;"><strong>Description</strong></th></tr></thead><tbody>'+activityData+'</tbody></table><br /> Thanks,<br /> Monsanto Admin Team' );
            emailList.add(email);
        }
        try{
            Messaging.sendEmail(emailList);
           
        } catch(Exception e) {
            system.debug('Exception =>'+e);
        }
    }
}