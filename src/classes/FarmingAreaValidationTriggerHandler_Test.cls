@isTest
public class FarmingAreaValidationTriggerHandler_Test {
    public static List<Account_Farming_Area__c> accTotalFarmingArea;
     @testSetup
    static void setup(){
        TestUtilClass.createtriggerControl();
         TestUtilClass.createCropRecordType();
        TestUtilClass.createTotalRecordType();
        TestUtilClass.createTestUsers('System Administrator',2);
        TestUtilClass.createTestAccount(10);
        TestUtilClass.createTestAccountRole(2);
        TestUtilClass.createTestTotalAccountFarmingArea(1);
        TestUtilClass.createTestCropAccountFarmingAreaInsert(5);
        TestUtilClass.createTestCropAccountFarmingArea(5);
        
        
       
    }
     static testMethod void testFarmingMethod(){
         List<Account_Farming_Area__c> accFarming = [Select id,Parent_SFID__c,  Inbound_Area_Qty__c,Area_Qty__c from Account_Farming_Area__c];
        // update accFarming;
         try{
         if(!accFarming.isEmpty()){
             for(Account_Farming_Area__c accFar : accFarming){
                 if(accFar.Parent_SFID__c != null){
                     accFar.Inbound_Area_Qty__c = 20200;
                     accFar.Area_Qty__c = 20000;
                 }
             }
         }
         update accFarming;
         }         
         
          catch(Exception e){
            System.debug('Exception Occured when createTestAccountCommunication'+e.getMessage());
        }

    }
}