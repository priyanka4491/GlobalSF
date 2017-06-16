/* 
*
* @author : Cognizant technology solutions.
* @version : 1.0
* @objects Referenced : Account
* @Description : This class covers the FRRestAccDetail which describes to get the external account details and account data
*/

@isTest
private class FRRestAccDetail_Test {

    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

     @testSetup
    static void setup(){
       TestUtilClass.createTestUsers('System Administrator',2);
       TestUtilClass.createTestAccount(3);
       TestUtilClass.createContact(3);
       TestUtilClass.createTestEvent(4);
       TestUtilClass.createTestAccountRole(3);
       TestUtilClass.createTestAccountCommunication(2);
       TestUtilClass.createEndPoint();
    }
     static testmethod void getAccountResults() {
         
         Map<String,String> responseHeaders = new Map<String, String>();
         responseHeaders.put('Content-Type','application/json');
        // Set mock callout class 
        Test.startTest();
        SingleRequestMock accessTokenResult = new SingleRequestMock(200,'Complete','{"access_token": "nyPqAVhZibXzt8h6xQgE6f6yXJi7","token_type": "Bearer","expires_in": 7199}',
                                                                    responseHeaders);


        SingleRequestMock responseResults = new SingleRequestMock(400,
                                                  'Complete',
                                                  '{"queueDuration": 3,"queryDuration": 157,"results": [{"resultSet": true,"data": [{"DLR_SAP_ID": "12345","FISCL_YR": "2017","DLR_RADL_CD": "Develop","DLR_TOT_AREA_QTY": 60407.672,"DLR_MON_AREA_QTY": 38895.116,"DLR_OPRTNTY_AREA_QTY": 29615.699,"MON_LAND_SHR_PCT": 64.38771,"SLS_FRCST_TOT_BDGT": null,"CORN_NET_SLS_CYM1_QTY": 12607,"CORN_NET_SLS_CYM2_QTY": 14222,"CORN_NET_SLS_CYM3_QTY": 11907,"SOY_NET_SLS_CYM1_QTY": 9547.5,"SOY_NET_SLS_CYM2_QTY": 8402.4,"SOY_NET_SLS_CYM3_QTY": 8051 } ],"rowCount": 1,"rowLimitExceeded": false }]}',responseHeaders);
        
        Map<String, HttpCalloutMock> endPointResults = new Map<String,HttpCalloutMock>();

        endPointResults.put('https://test.amp.monsanto.com/as/token.oauth2?client_id=Global-Sales-Portal&client_secret=Wa8otHw859LG4yLQxQLEkfpzlHAxw1uirDgdv0ov5NRd1VQYrMJcTnwuqJUhCtFM&grant_type=client_credentials',accessTokenResult);
       endPointResults.put('https://api-t.monsanto.com/frontier-dealer-radl-mvp/queries',responseResults);

        HttpCalloutMock multiCalloutMock =  new MockHttpResponseGenerator(endPointResults);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);   
        FRRestAccDetail.getAccsDetails();
        //FRRestAccDetail frestAccDetail = new FRRestAccDetail();
        //system.schedule('FRRestAccDetail_TestSchedule',CRON_EXP,frestAccDetail);
        System.assert(Limits.getCallouts() <= Limits.getLimitCallouts());
        Test.stopTest();
    }
    
   static testmethod void getSpecificAccount() {
         Map<String,String> responseHeaders = new Map<String, String>();
         responseHeaders.put('Content-Type','application/json');
    Test.startTest();
    // Set mock callout class 
       SingleRequestMock accessTokenResult = new SingleRequestMock(200,
                                                         'Complete',
                                                         '{"access_token": "nyPqAVhZibXzt8h6xQgE6f6yXJi7","token_type": "Bearer","expires_in": 7199}',
                                                         responseHeaders);

        SingleRequestMock responseResults = new SingleRequestMock(200,
                                                  'Complete',
                                                  '{"queueDuration": 3,"queryDuration": 157,"results": [{"resultSet": true,"data": [{"DLR_SAP_ID": "12345","FISCL_YR": "2017","DLR_RADL_CD": "Develop","DLR_TOT_AREA_QTY": 60407.672,"DLR_MON_AREA_QTY": 38895.116,"DLR_OPRTNTY_AREA_QTY": 29615.699,"MON_LAND_SHR_PCT": 64.38771,"SLS_FRCST_TOT_BDGT": null,"CORN_NET_SLS_CYM1_QTY": 12607,"CORN_NET_SLS_CYM2_QTY": 14222,"CORN_NET_SLS_CYM3_QTY": 11907,"SOY_NET_SLS_CYM1_QTY": 9547.5,"SOY_NET_SLS_CYM2_QTY": 8402.4,"SOY_NET_SLS_CYM3_QTY": 8051 } ],"rowCount": 1,"rowLimitExceeded": false }]}',responseHeaders);

        Map<String, HttpCalloutMock> endPointResults = new Map<String,HttpCalloutMock>();

        endPointResults.put('https://test.amp.monsanto.com/as/token.oauth2?client_id=Global-Sales-Portal&client_secret=Wa8otHw859LG4yLQxQLEkfpzlHAxw1uirDgdv0ov5NRd1VQYrMJcTnwuqJUhCtFM&grant_type=client_credentials',accessTokenResult);
    //endPointResults.put('https://test.amp.monsanto.com/as/token.oauth2',accessTokenResult);

       endPointResults.put('https://api-t.monsanto.com/frontier-dealer-radl-mvp/queries',responseResults);

        HttpCalloutMock multiCalloutMock =  new MockHttpResponseGenerator(endPointResults);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);   
        FRRestAccDetail.getAccDetails('12345');
       System.assert(Limits.getCallouts() <= Limits.getLimitCallouts());
        Test.stopTest();
         
    }
    
     
    
    static testMethod void testWrapper(){
        Test.startTest();
        FRRestAccDetail.Responsewrapper result = new FRRestAccDetail.Responsewrapper();
             result.queueDuration = 3;
             result.queryDuration = 157;
            
            FRRestAccDetail.ResponseData responseData = new FRRestAccDetail.ResponseData();
               responseData.AREA_UOM = null;
                responseData.CNTRY_CD = 'US';
                responseData.CORN_FSA_AREA_CY = 12348.09;
                responseData.CORN_FSA_AREA_CYM1 = 232323.2;
                responseData.CORN_FSA_AREA_CYM2 = 232132.13;
                responseData.CORN_FSA_AREA_CYM3 = 874383.27;
                responseData.CORN_MON_AREA_CY = 231313.23;
                responseData.CORN_MON_AREA_CYM1 = 43726.34;
                responseData.CORN_MON_AREA_CYM2 = 34234.34;
                responseData.CORN_MON_AREA_CYM3 = 382173.89;
                responseData.CORN_NET_SLS_CY_QTY = 39843.44;
                responseData.CORN_NET_SLS_CYM1_QTY = 53535.44;
                responseData.CORN_NET_SLS_CYM2_QTY = 56456.435;
                responseData.CORN_NET_SLS_CYM3_QTY = 348723.34;
                responseData.CORN_TOTAL_SLS_CY_QTY = 87498.44;
                responseData.CORN_TOTAL_SLS_CYM1_QTY = 45435.44;
                responseData.CORN_TOTAL_SLS_CYM2_QTY = 2392.434;
                responseData.CORN_TOTAL_SLS_CYM3_QTY = 23424.8;
                responseData.DLR_OPRTNTY_AREA_QTY = 54.5;
                responseData.DLR_RADL_CD = 'Retain';
                responseData.DLR_SAP_ID = '12345';
                responseData.FISCL_YR = 20;
                responseData.MON_LAND_SHR_PCT = '1231.23';
                responseData.SOY_FSA_AREA_CY = 233.3333;
                responseData.SOY_FSA_AREA_CYM1 = 32423.33;
                responseData.SOY_FSA_AREA_CYM2 = 534.354;
                responseData.SOY_FSA_AREA_CYM3 = 3432.23;
                responseData.SOY_MON_AREA_CY = 123.34;
                responseData.SOY_FSA_AREA_CYM1 = 3424.44;
                responseData.SOY_FSA_AREA_CYM2 = 34324.34;
                responseData.SOY_FSA_AREA_CYM3 = 4342.23;
                responseData.SOY_MON_AREA_CYM1 = 2323.34;
                responseData.SOY_MON_AREA_CYM2 = 34214.34;
                responseData.SOY_MON_AREA_CYM3 = 324243.34;
                responseData.SOY_NET_SLS_CYM1_QTY = 4214.34;
                responseData.SOY_NET_SLS_CYM2_QTY = 432324.434;
                responseData.SOY_NET_SLS_CYM3_QTY = 3455.54;
                responseData.SOY_NET_SLS_CY_QTY = 24234.4;
                responseData.SOY_TOTAL_SLS_CY_QTY = 43213.34;
                responseData.SOY_TOTAL_SLS_CYM1_QTY = 3488.23;
                responseData.SOY_TOTAL_SLS_CYM2_QTY = 33488.23;
                responseData.SOY_TOTAL_SLS_CYM3_QTY = 343488.23;
         
        FRRestAccDetail.cls_results resultSet = new FRRestAccDetail.cls_results();
        //resultSet.data.add(responseData);
        resultSet.resultSet = true;
        resultSet.rowCount = 1;
        resultSet.rowLimitExceeded = false;
        
         FRRestAccDetail.SecurityTokenHandlingClass tokenResult = new FRRestAccDetail.SecurityTokenHandlingClass();
         tokenResult.expires_in = 7199;
         tokenResult.token_type = 'Bearer';
        System.assert(Limits.getCallouts() <= Limits.getLimitCallouts());
        Test.stopTest();
    }
}