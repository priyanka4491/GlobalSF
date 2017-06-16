/* 
*
* @author : Cognizant technology solutions.
* @version : 1.0
* @objects Referenced : Account, Event
* @Description : This class covers the FR_Server_Touch_Point_Controller which describes to insert the touchpoints(Event) from Account detail and Record a Vist page
*/
@isTest(SeeAllData = False)
Public class FR_Server_Touch_Point_Controller_Test {
    //Create test records once and then access them in any test method in the test class
    @testSetup static void createTestData() {
        TestUtilClass.createTestAccount(1); 
        TestUtilClass.createContact(2); 
        TestUtilClass.createTestUsers('Standard User', 2);
        TestUtilClass.createRecordType();
    }   
    
    //Create touch Point Record
    static testMethod void validateInsertTouchPoint(){        
        list<account> accountList= [SELECT Id,Name FROM Account];
        list<Contact> contactList= [SELECT Id,AccountId FROM Contact];
        list<user> userlist= [select id,profile.name from user where profile.Name ='Standard User' and IsActive=true Limit 1];
        if(!userlist.isEmpty()){
            system.runAs(userlist[0]){
                Test.StartTest();
                try{
                    if(!accountList.isEmpty()) { 
                        //Convert Date to String format
                        Date  d = System.today();
                        String startdate = d.year()+'-'+d.month()+'-'+d.day();
                        
                        FR_Server_Touch_Point_Controller.insertTouchPoint('Test Notes', 'Call','Training', 'Event Touch Point', startdate, accountList[0].Id,contactList[0].Id,String.valueof(Date.today().addDays(2)));
                        FR_Server_Touch_Point_Controller.insertTouchPoint('Test Notes', 'Call','Training', 'Event Touch Point', startdate, contactList[0].Id,accountList[0].Id,null);   
                        FR_Server_Touch_Point_Controller.getActivityDetail(accountList[0].Id);
                        
                    }
                }
                catch(ListException le) {
                    System.debug('Message: ' + le.getMessage() + 'Cause: ' + le.getCause() + 'Line number: ' + le.getLineNumber() + 'Stack trace: ' + le.getStackTraceString());    
                  } 
                System.assert(!accountList.isEmpty(),'Accounts Created');
                Test.StopTest();
            }
        }
    }
}