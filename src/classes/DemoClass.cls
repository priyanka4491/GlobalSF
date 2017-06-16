@isTest(SeeAllData = True)
public class DemoClass {

    public static testmethod void doRun(){
        User objeUser = [Select Id from User where Id= '0052C000000UMjT'];

System.runAs(objeUser){
    List<Account> accList =  [SELECT Id from Account];
    system.debug('********************'+accList.size());
    Set<Id> accIds = new Set<Id>();
    for(Account acc : accList){
        accIds.add(acc.Id);
    }
    System.debug('Account List'+accList.size());
    List<Event> eventList = [SELECT Id FROM Event WHERE WhatId IN:accIds];
    UserRecordAccess usrAccess = [SELECT RecordId, HasReadAccess, HasTransferAccess, MaxAccessLevel FROM UserRecordAccess WHERE UserId = '0052C000000UMjT'
     AND RecordId =: eventList[0].Id];
     
    System.debug('Event Count'+eventList.size());
    System.debug('User Access'+usrAccess);
}

    }
}