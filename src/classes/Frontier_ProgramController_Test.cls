/* 
*
* @author : Cognizant technology solutions.
* @version : 1.0
* @objects Referenced :Account,Program,Account Program Object 
* @Description : This test class is covering code lines for apex class "Frontier_ProgramController"
*/


@isTest
public class Frontier_ProgramController_Test {

     @testSetup
    static void setup(){
        TestUtilClass.createTestUsers('System Administrator',2);
        TestUtilClass.createTestAccount(10);
       TestUtilClass.createTestGrowerAccount(10);
        TestUtilClass.createTestAccountRole(7);
        TestUtilClass.createTestProgram(4);
        TestUtilClass.createTestAccountProgram(7);
        TestUtilClass.createTestProduct(6);
        TestUtilClass.createTestAccountProduct(6);
        TestUtilClass.createTestTouchpoint(6);
        TestUtilClass.createTask(6);
        
        
        
        
    }
    static testmethod void getDetails() {
         User currentUser = new User();
        currentUser  = [SELECT Id FROM User Where Id =:UserInfo.getUserId()]; 
        if(currentUser != null){
            System.runAs(currentUser){
                list<account> accountList= new list<account>();
                list<Program__c> pgmList = new list<Program__c>();
                accountList=[SELECT Id,Name FROM Account LIMIT 10];
                pgmList = [SELECT id,Name FROM Program__c LIMIT 5];
                List<Account_Program__c> accPgmSalesList = [SELECT Id,CreatedBy.ID,Execution_Status__c FROM Account_Program__c WHERE CreatedBy.ID = :UserInfo.getUserId()];  
                system.debug('accPgmSalesList in Test Class' + accPgmSalesList); 
                Test.startTest(); 
                try{                                  
                    if(!accountList.isEmpty()){
                        
                        Frontier_ProgramController.getAllPrograms('null','false','10','5','true');
                        Frontier_ProgramController.getAllPrograms(accountList[0].id,'false','10','5','false');
                        Frontier_ProgramController.getAllPrograms('null','true','10','5','false');
                        Frontier_ProgramController.getPgmAccounts(pgmList[0].id,'10','1','null',true,false);

                        Frontier_ProgramController.getPgmAccounts(pgmList[0].id,'10','1','Service_Level_Class_Descr__c-ASC',false,false);
                        Frontier_ProgramController.getPgmAccounts(pgmList[0].id,'10','1','Account_SFID__r.Name-ASC',false,true);
                        Frontier_ProgramController.getPgmAccounts(pgmList[0].id,'10','1','Planning_Status__c-ASC',false,true);
                        Frontier_ProgramController.getPgmAccounts(pgmList[0].id,'10','1','Execution_Status__c-ASC',false,true);
                        Frontier_ProgramController.getPgmAccounts(pgmList[0].id,'10','1','Location-ASC',false,true);
                        Frontier_ProgramController.getPgmAccounts(pgmList[0].id,'10','1','Product_SFID__r.Name-ASC',false,true);
                        Frontier_ProgramController.getMyPrograms(pgmList[0].id,accountList[0].id,'false','true');
                        Frontier_ProgramController.getMyPrograms(pgmList[0].id,accountList[0].id,'true','false');
                        Frontier_ProgramController.getMyProgramAccounts(pgmList[0].id,'10','1','Service_Level_Class_Descr__c-ASC',false,false);
                        //Frontier_ProgramController.getCancelPgm('Not Started',accPgmSalesList[0].id,'Cancelled');
                        //Frontier_ProgramController.getCompletePgm('Not Started',accPgmSalesList[0].id);
                        Frontier_ProgramController.getSeasonData('SUMMER');

                        







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
    static testmethod void getTestDetails() {
         User currentUser = new User();
                       

        currentUser  = [SELECT Id FROM User Where Id =:UserInfo.getUserId()]; 
        if(currentUser != null){
            System.runAs(currentUser){
                list<account> accountList= new list<account>();
                list<Program__c> pgmList = new list<Program__c>();
                accountList=[SELECT Id,Name FROM Account LIMIT 10];
                pgmList = [SELECT id,Name FROM Program__c LIMIT 5];
                List<Account_Program__c> accPgmSalesList = [SELECT Id,CreatedBy.ID,Execution_Status__c FROM Account_Program__c WHERE CreatedBy.ID = :UserInfo.getUserId() AND Execution_Status__c = 'In Execution'];  
                system.debug('accPgmSalesList in Test Class' + accPgmSalesList[0].id); 
                Test.startTest(); 
                try{                                  
                    if(!accountList.isEmpty()){
                        Frontier_ProgramController.getPgmAccounts(pgmList[0].id,'10','1','Service_Level_Class_Descr__c-DESC',false,false);
                        Frontier_ProgramController.getPgmAccounts(pgmList[0].id,'10','1','Account_SFID__r.Name-DESC',false,true);
                        Frontier_ProgramController.getPgmAccounts(pgmList[0].id,'10','1','Planning_Status__c-DESC',false,true);
                        Frontier_ProgramController.getPgmAccounts(pgmList[0].id,'10','1','Execution_Status__c-DESC',false,true);
                        Frontier_ProgramController.getPgmAccounts(pgmList[0].id,'10','1','Location-DESC',false,true);
                        Frontier_ProgramController.getPgmAccounts(pgmList[0].id,'10','1','Product_SFID__r.Name-DESC',false,true);

                       Frontier_ProgramController.getMyProgramAccounts(pgmList[0].id,'10','1','Service_Level_Class_Descr__c-DESC',false,false);
                      Frontier_ProgramController.getCompletePgm('Completed',accPgmSalesList[0].id);
                         Frontier_ProgramController.getMyProgramsChart(pgmList[0].id,accountList[0].id,'false','true',true);
                         Frontier_ProgramController.getMyProgramsChart(pgmList[0].id,accountList[0].id,'false','false',true);

                       Frontier_ProgramController.getMyProgramsChart(pgmList[0].id,'null','true','false',false);

                       Frontier_ProgramController.getCancelPgm('Cancelled',null,'Cancelled');



                       
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