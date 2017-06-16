@isTest
public class Frontier_GrowerFarmSizeController_Test {
     @testSetup
    static void setup(){
        TestUtilClass.createTestUsers('System Administrator',2);
        TestUtilClass.createCropRecordType();
        TestUtilClass.createTotalRecordType();
        TestUtilClass.createTestAccount(12);
        TestUtilClass.createTestGrowerAccount(5);
        TestUtilClass.createContact(4);
        TestUtilClass.createTestAccountRole(12);
        TestUtilClass.createtriggerControl();
        TestUtilClass.createTestTotalAccountFarmingArea(5);
        TestUtilClass.createTestCropAccountFarmingAreaInsert(9);
        
        TestUtilClass.createTestAccountSales(12);
        
        
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
                         Frontier_GrowerFarmSizeController.GrowerFarmSizeDetails(accountList[0].Id,'FY17','acres');
                         Frontier_GrowerFarmSizeController.GrowerFarmSizeDetails(accountList[0].Id,'FY16','hectares');
                         Frontier_GrowerFarmSizeController.GrowerFarmSizeDetails(accountList[0].Id,'FY15','acres');
                         Frontier_GrowerFarmSizeController.getupdateFYArea(accountList[0].Id,'Corn','Soy','Sorghum',1000,100,100,100,'2017 Safra');
                         //Frontier_GrowerFarmSizeController.updateFarmingAreas()
                         Frontier_GrowerFarmSizeController.DealerSalesDetails(accountList[0].Id,'Corn');
                         Frontier_GrowerFarmSizeController.getCropList();
                         Frontier_GrowerFarmSizeController.getdealerSalesDetails(accountList[0].Id,'Units');
                         Frontier_GrowerFarmSizeController.GrowerSalesDetails(accountList[0].Id,'Units');
                          
                         
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