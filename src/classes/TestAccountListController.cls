/* 
*
* @author : Cognizant technology solutions.
* @version : 1.0
* @objects Referenced :Account,Event,Account Communications,Account Business Role 
* @Description : This test class is covering code lines for apex class "AccountListController"
*/

@isTest
Public class TestAccountListController {
    @testSetup
    static void setup(){
        TestUtilClass.createTestUsers('System Administrator',2);
        TestUtilClass.createTestAccount(10);
        TestUtilClass.createTestGrowerAccount(2);
        TestUtilClass.createContact(4);
        TestUtilClass.createTestEvent(2);
        TestUtilClass.createTestAccountRole(5);
        TestUtilClass.createTestAccountCommunication(5);
        
    }
    static testmethod void getDetails() {
        list<user> userlist= [select id,profile.name from user where profile.Name ='System Administrator' and IsActive=true Limit 1];
        if(!userlist.isEmpty()){
            system.runAs(userlist[0]){     
                list<account> accountList=[SELECT Id,Name FROM Account LIMIT 10];
                List<Account_Communication__c> accCommunication;
                try { 
                    if(!accountList.isEmpty()){
                    RecordType strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account_Communication__c' and DeveloperName = 'Account_Communication_Address_Role_Business_Role' LIMIT 1];
                    Account_Business_Role__c bussinessRole =[SELECT Id FROM Account_Business_Role__c where Account_SFID__c=:accountList[0].Id AND Archive_Ind__c = 'N'
                                                             LIMIT 1]; 
                    bussinessRole.Business_Unit_Descr__c='National';
                    update bussinessRole;
                    
                    accCommunication= [SELECT Street_Addr__c,Parent_SFID__c,RecordTypeId FROM Account_Communication__c 
                         WHERE Account_SFID__c=: accountList[0].id  AND Archive_Ind__c = 'N'];
                    
                    // Update the Account Communication fields.
                        if(!accCommunication.isEmpty()){
                            accCommunication[0].recordTypeId = strRecordTypeId.Id;
                            accCommunication[0].Account_Business_Role_SFID__c=bussinessRole.Id;
                            accCommunication[0].Parent_SFID__c= accCommunication[1].Id;
                            accCommunication[1].Parent_SFID__c =  accCommunication[2].Id; 
                            accCommunication[1].Role_Descr__c ='Business';
                            // Make the update call.
                            update accCommunication;
                        }
                   } 
                }
                catch(DmlException e) {
                    System.debug('An unexpected error has occurred: ' + e.getMessage());
                }
                
                Test.startTest(); 
                try{                                  
                    if(!accountList.isEmpty()){
                        AccountListController.getAccounts(accountList[0].Name,1,-1);
                        AccountListController.getAccounts(accountList[0].Name,3,1);  
                        AccountListController.sortBy('Develop',3,1);
                        AccountListController.sortBy('',3,-1); 
                        Frontier_GrowerAccountListController.getAccounts(accountList[0].Name,1,-1,accountList[0].Id);
                        Frontier_GrowerAccountListController.getAccounts(accountList[0].Name,3,1,accountList[0].Id);  
                        Frontier_GrowerAccountListController.sortBy('Develop',3,1,accountList[0].Id);
                        Frontier_GrowerAccountListController.sortBy('',3,-1,accountList[0].Id);
                        Frontier_GrowerAccountListController.getAllGrowerAccounts(accountList[0].Name,3,1);
                        Frontier_GrowerAccountListController.getAllGrowerAccounts(accountList[0].Name,1,-1);
                        Frontier_GrowerAccountListController.sortByRADL('Develop',3,1);
                        Frontier_GrowerAccountListController.sortByRADL('',3,1);
                    }
                }
                catch(Exception le) {
                    System.debug('Message: ' + le.getMessage() + 'Cause: ' + le.getCause() + 'Line number: ' + le.getLineNumber() + 'Stack trace: ' + le.getStackTraceString());    
                }
                System.assert(!accountList.isEmpty(),'Accounts Created');
                Test.stopTest();
            }
        }
    }
}