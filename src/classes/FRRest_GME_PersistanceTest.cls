/* ************************************************************************************************************
 * Category             :   Apex Class
 * Name                 :   FRRest_GME_PersistanceTest
 * Description          :   This test class is covering code lines for apex class "FRRest_GME_Persistance"
 * Author               :   Cognizant Technology Solutions
 * ************************************************************************************************************/
@isTest
public class FRRest_GME_PersistanceTest {

@testsetup
    static void accountsetup()
    {   
            TestUtilClass.createTestUsers('System Administrator',2);
            TestUtilClass.createTestAccount(4);
            TestUtilClass.createTestAccountRole(4);
       TestUtilClass.createTestAccountCommunication(4);

    }
        public static testMethod void testingAccs()
        {
            Test.startTest();
            //[select id,Role_Descr__c,Service_Level_Class_Descr__c,SAP_ID__c,Account_SFID__c from Account_Business_Role__c Limit 1];
            String response = '{"queueDuration":3,"queryDuration":319,"results":[{"resultSet":true,"data":[{"DLR_SAP_ID":"00010222120","DLR_RADL_CD":"Develop"},{"DLR_SAP_ID":"0001022262","DLR_RADL_CD":"Develop"},{"DLR_SAP_ID":"0001022329","DLR_RADL_CD":"Develop"},{"DLR_SAP_ID":"0001022173","DLR_RADL_CD":"Light Touch"},{"DLR_SAP_ID":"0001022192","DLR_RADL_CD":"Acquire"},{"DLR_SAP_ID":"0001022164","DLR_RADL_CD":"Light Touch"},{"DLR_SAP_ID":"0001022334","DLR_RADL_CD":"Retain"}],"rowCount":7,"rowLimitExceeded":false}]}';
            /*List<FRRestAccDetail.Responsewrapper> liResponses = new List<FRRestAccDetail.Responsewrapper>();
            liResponses.add((FRRestAccDetail.Responsewrapper)JSON.deserialize(response,FRRestAccDetail.Responsewrapper.Class));*/
            FRRest_GME_Persistance.updateAccountInfo(response);
            //System.assertEquals('00010222120',ab[0].SAP_ID__c);
            Test.stopTest();
        }
}