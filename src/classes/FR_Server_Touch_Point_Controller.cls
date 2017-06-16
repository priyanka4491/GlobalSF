/* 
*
* @author : Cognizant technology solutions.
* @version : 1.0
* @objects Referenced : Account, Event
* @Description : To insert the touchpoints(Event) from Account detail and Record a Vist page
*/
public without sharing class FR_Server_Touch_Point_Controller {
    @AuraEnabled
    //Method to insert Events that we get from Account detail page and Record visit page
    public static void insertTouchPoint(String notes,String touchPointType, String touchPointReason, String recordType, String StartDate, Id accuID,String contactId,String dueDate) { 
        String[] myDateOnly = StartDate.split(' ');
        String[] strDate = myDateOnly[0].split('-');
        Integer myIntDate = integer.valueOf(strDate[2]);
        Integer myIntMonth = integer.valueOf(strDate[1]);
        Integer myIntYear = integer.valueOf(strDate[0]);
        Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
        Datetime dt = datetime.newInstance(d.year(),d.month(),d.day());
        Map<String,String> iTouchType = new Map<String,String>();
            for (Recordtypes__c apprecord : Recordtypes__c.getAll().values()){
                iTouchType.put(apprecord.Name,apprecord.Value__c);
            }  
        Event iTouch;
        try{
         iTouch = new Event(subject = touchPointReason,
                                 Description = notes,
                                 WhatId = accuID,             
                                 RecordTypeId =  iTouchType.get(recordType),
                                 Type = (touchPointType != null ? touchPointType : 'Call'),
                                 StartDateTime = dt,  
                                 EndDateTime = dt.addHours(+1));  
            if(contactId != 'None'){
                iTouch.WhoId = Id.valueOf(contactId);
            }
        insert iTouch; 
        
        if(dueDate != null || !(String.isBlank(dueDate))){
        String[] followUp = dueDate.split(' ');
        String[] dueDateTask = followUp[0].split('-');
        Integer followUpDate = integer.valueOf(dueDateTask[2]);
        Integer followUpMonth = integer.valueOf(dueDateTask[1]);
        Integer followUpYear = integer.valueOf(dueDateTask[0]);
        Date due = Date.newInstance(followUpYear, followUpMonth, followUpDate);        
        Task newTask;
        
        newTask = new Task(subject = 'Task created on ' + Date.today(),
                                 WhatId = accuID,
                                 ActivityDate = due,  
                                 Status = 'In Progress',
                                 Priority = 'Normal',
                                 Description = notes,
                                 IsReminderSet=true, 
                                 ReminderDateTime = System.Now()+1);
        insert newTask;
        }
        }
        catch(Exception e){
            System.debug('The following error has been occured while inserting new Event record' + e.getMessage());
        }     
        //return iTouch;
    }
    @AuraEnabled
    //Method to get vist type from Task
    public static List<String> getpickval() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.Type.getDescribe();
        List<Schema.PicklistEntry> li = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: li) {
            options.add(f.getLabel());
        }       
        return options;
    }
    @AuraEnabled
    public static List<String> getreasonpickval() {
        List<String> picvalues = new List<String>();
        Schema.DescribeFieldResult subjectResult = Event.Subject.getDescribe();
        List<Schema.PicklistEntry> pickValues = subjectResult.getPicklistValues();
        for (Schema.PicklistEntry reasonLabel: pickValues) {
            picvalues.add(reasonLabel.getLabel());
        }       
        return picvalues;
    }
    @AuraEnabled
    public static String getActivityDetail(String accId){
        List<Account> accounts = [SELECT Id,(SELECT Id,Name FROM Contacts) FROM Account WHERE Id=:accId];
          ActivityWrapper activityWrap = new ActivityWrapper();
        if(!accounts.isEmpty()){
            Account account = accounts[0];
          
        if(account != Null && account.contacts.size() > 0){
            for(Contact con : account.contacts){
                activityWrap.contactList.add(con);
            }
        }        
        activityWrap.Tasktypes.addAll(getpickval());
        activityWrap.VisitReason.addAll(getreasonpickval());
        }
        
        return JSON.serialize(activityWrap);
    }
    
    
    public class ActivityWrapper{
        public List<Contact> contactList;
        public List<String> Tasktypes;
        public List<String> VisitReason;
        public ActivityWrapper(){
            contactList = new List<Contact>();
            Tasktypes = new List<String>();
            VisitReason = new List<String>();
        }
    }    
}