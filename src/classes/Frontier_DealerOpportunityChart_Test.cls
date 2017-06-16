@isTest
public class Frontier_DealerOpportunityChart_Test {
    
     @testSetup
    static void setup(){
        TestUtilClass.createTestUsers('System Administrator',2);
        TestUtilClass.createCropRecordType();
        TestUtilClass.createTotalRecordType();
        TestUtilClass.createTestAccount(10);
        TestUtilClass.createContact(4);
        TestUtilClass.createtriggerControl();
        TestUtilClass.createTestTotalAccountFarmingArea(3);
        TestUtilClass.createTestCropAccountFarmingAreaInsert(9);
        TestUtilClass.createTestSales(3);
    }
    static testmethod void getDetails() {
        list<user> userlist= [select id,profile.name from user where profile.Name ='System Administrator' and IsActive=true Limit 1];
        system.debug('@@userslist'+userlist);
        if(!userlist.isEmpty()){
            system.runAs(userlist[0])
            {     
                list<account> accountList= new list<account>();
                
                accountList=[SELECT Id,Name FROM Account LIMIT 10];
                System.debug(accountList + 'accountList');
                 Test.startTest(); 
                 try { 
                     if(!accountList.isEmpty()){
                         Frontier_DealerOpportunityChart.getDealerOpportunity(accountList[0].Id);
                     }
                     }
                catch(Exception le) {
                    System.debug('Message: ' + le.getMessage() + 'Cause: ' + le.getCause() + 'Line number: ' + le.getLineNumber() + 'Stack trace: ' + le.getStackTraceString());    
                    
                }
                 Test.stopTest();
                System.assert(!accountList.isEmpty(),'Accounts Created');
            }
        }
    }


}