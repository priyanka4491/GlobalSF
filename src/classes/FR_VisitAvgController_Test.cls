/* 
*
* @author : Cognizant technology solutions.
* @version : 1.0
* @objects Referenced : Account , AccountBusinessRole and AccountCommunication
* @Description : Unit test class for FR_VisitAvgController
*/
@isTest(seeAllData=False)
public class FR_VisitAvgController_Test {    
    //Inserting the test data for required test class through TestUtilClass
    @testSetup
    static void setup(){        
        TestUtilClass.createTestUsers('System Administrator', 1);
        TestUtilClass.createTestAccount(5);        
        TestUtilClass.createContact(5);
        
        TestUtilClass.createTestEvent(4);
        TestUtilClass.createTestAccountRole(5);
        TestUtilClass.createTestAccountCommunication(4);
            
    }
    
    //Test the Real time code
    static testMethod void RadlClsManipulationRealtime(){
        Test.StartTest();
        List<User> usrList = TestUtilClass.createTestUsers('Standard User',2);
        System.debug(usrList);
        FR_VisitAvgController.Status = 'Negative'; 
        FR_VisitAvgController.getLastData(7);
        FR_VisitAvgController.getLastData(30);
        system.assertEquals('admUser0@asdf.com',usrList[0].Email);
        Test.StopTest();
    }
}