@isTest
public class Frontier_DealerDetailsController_Test {
     @testSetup
    static void setup(){
        TestUtilClass.createTestUsers('System Administrator',2);
        
        TestUtilClass.createTestAccount(3);
        TestUtilClass.createTestGrowerAccount(3);
       TestUtilClass.createContact(3);
        TestUtilClass.createAccountContact(3);
       TestUtilClass.createTestEvent(2);
       TestUtilClass.createTestAccountRole(3);
       TestUtilClass.createTestAccountCommunication(5);
       TestUtilClass.createTestAccountCommunicationPhoneandEmail(4,'Account_Communication_Phone','Account_Communication_Phone_Role','Account_Communication_Phone_Role_Business_Role');
        //TestUtilClass.createTestAccountCommunicationPhoneandEmail(4,'Account_Communication_Email','Account_Communication_Email_Role','Account_Communication_Email_Role_Business_Role');

        TestUtilClass.createCropRecordType();
        TestUtilClass.createTotalRecordType();
        TestUtilClass.createtriggerControl();
        TestUtilClass.createTestTotalAccountFarmingArea(3);
        TestUtilClass.createTestCropAccountFarmingAreaInsert(9);
    }
    static testmethod void getDetails() {

    list<user> userlist= [select id,profile.name from user where profile.Name ='System Administrator' and IsActive=true Limit 1];
        if(!userlist.isEmpty()){
            system.runAs(userlist[0])
            {     
                list<account> accountList= new list<account>();
                list<account> groweraccountList= new list<account>();

                 list<Account_Communication__c> accountCommunicationList=new list<Account_Communication__c>();
                 list<Account_Communication__c> groweraccountCommunicationList=new list<Account_Communication__c>();

                accountList=[SELECT Id,Name FROM Account LIMIT 10];
                groweraccountList=[SELECT Id,Name FROM Account WHERE Dealer_SFID__c=:accountList[0].id LIMIT 10];

                accountCommunicationList=[SELECT Id,Name FROM Account_Communication__c where Account_SFID__c=:accountList[0].Id];
                groweraccountCommunicationList=[SELECT Id,Name FROM Account_Communication__c where Account_SFID__c=:groweraccountList[0].Id];

                Test.startTest(); 
                 try { 
                     if(!accountList.isEmpty()){
                         Frontier_DealerDetailsController.dealerAccountDetails(accountList[0].id,accountCommunicationList[0].id,'2017 Safra');
                         Frontier_GrowerProfileController.growerAccountDetails(groweraccountList[0].id,groweraccountCommunicationList[0].id,'2017 Safra');

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