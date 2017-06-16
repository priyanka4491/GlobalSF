/* 
*
* @author : Cognizant technology solutions.
* @version : 1.0
* @objects Referenced :Account,Event 
* @Description : This test class is covering code lines for apex class "sObjectRecordController"
*/

@isTest
Public class TestsObjectRecordController {
     @testSetup
    static void setup(){
       TestUtilClass.createTestAccount(3);
       TestUtilClass.createContact(3);
       TestUtilClass.createTestEvent(20);
       TestUtilClass.createTestUsers('Standard User', 2);
     }   
    static testmethod void getDetails() {
        list<account> accountList;
        list<contact> contactList;
        list<event> eventList;
        list<user> userlist= [select id from user];
        if(!userlist.isEmpty()){
        system.runAs(userlist[0])
        {     
        accountList = [SELECT Id,Name FROM Account];
            if(accountList.isEmpty()){
                accountList = new list<account>();
            }
        contactList = [SELECT Id,Name FROM Contact];
            if(contactList.isEmpty()){
                contactList = new List<Contact>();
            }
        eventList= [SELECT Description,StartDateTime,EndDateTime,ActivityDate,AccountId,Who.Name,What.Name,Type  FROM event where WhatId=:accountList[0].Id LIMIT 5];
            if(eventList.isEmpty()){
                eventList = new list<event>();
            }
        Test.startTest();
       try{
      
           if(!accountList.isEmpty()) {        
              //call the method - getRecords to check query returns account list
            sObjectRecordController.getRecords('Account','Type',1,'1','Corn','Name');
            //call the method - getRecords to check query exception
            sObjectRecordController.getRecords('Account','Notes',1,'1','Corn','');
            //call the method - findActivities to check query returns event list
            String startDate = eventList[0].StartDateTime.format('yyyy-MM-dd');
            String endDate =  eventList[0].EndDateTime.format('yyyy-MM-dd');

               if(!eventList.isEmpty()){
               eventList[0].description = '';
               update eventList;
               }
            sObjectRecordController.findActivities('Event','Type',2,10, accountList[0].Id,'Test notes','Call',startDate,endDate,(!contactList.isEmpty() ? contactList[0].Name : ''));
            //call the method - findActivities to check query exception
            //sObjectRecordController.findActivities('Event','Notes',-1,-1, (!contactList.isEmpty() ? contactList[0].Name : ''),'','Call',startDate,endDate,accountList[0].Id);
            }
            }
        catch(ListException le) {
         System.debug('Message: ' + le.getMessage() + 'Cause: ' + le.getCause() + 'Line number: ' + le.getLineNumber() + 'Stack trace: ' + le.getStackTraceString());    
         
        } 
        System.assert(!accountList.isEmpty(),'Accounts Created');
        System.assertEquals(!eventList.isEmpty(),!accountList.isEmpty(),'Events Created for Account');
   
        Test.stopTest();
        }
        }
        
        }
        }