/* 
*
* @author : Cognizant technology solutions.
* @version : 1.0
* @objects Referenced :Account,Event,Account communication,Account Bussiness Role 
* @Description : This test class is covering code lines for apex class "AccountController"
*/

@isTest
Public class TestAccountController {
    public static list<account> accountList;
    public static list<event> eventList;
    public static list<Account_Communication__c> accountCommunicationList;
    @testSetup
    static void setup(){
       TestUtilClass.createTestUsers('System Administrator',2);
       TestUtilClass.createTestAccount(3);
       TestUtilClass.createContact(3);
       TestUtilClass.createTestEvent(2);
       TestUtilClass.createTestAccountRole(2);
       TestUtilClass.createTestAccountCommunication(2);
      
        
           
    }
    static testmethod List<Account> getAccountList() {
        list<user> userlist= [select id,profile.name from user where profile.Name ='System Administrator' and IsActive=true Limit 1];
        system.debug('@@userslist'+userlist);
        if(!userlist.isEmpty()){
        system.runAs(userlist[0])
        {     
        
       
       
        list<Account_Business_Role__c> bussinessRoleList= new list<Account_Business_Role__c>();
            try{
        accountList=[SELECT Id,Name FROM Account LIMIT 10 ];       
        
        eventList=[SELECT Description  FROM event where WhatId=:accountList[0].Id LIMIT 10 ];
        
        accountCommunicationList=[SELECT Id,Name FROM Account_Communication__c where Account_SFID__c=:accountList[0].Id LIMIT 10];
        bussinessRoleList=[SELECT Id,Name FROM Account_Business_Role__c where Account_SFID__c=:accountList[0].Id LIMIT 10 ];

            }
            //String response = '{"queueDuration":3,"queryDuration":319,"results":[{"resultSet":true,"data":[{"DLR_SAP_ID":"0001022212","DLR_RADL_CD":"Develop"},{"DLR_SAP_ID":"0001022262","DLR_RADL_CD":"Develop"},{"DLR_SAP_ID":"0001022329","DLR_RADL_CD":"Develop"},{"DLR_SAP_ID":"0001022173","DLR_RADL_CD":"Light Touch"},{"DLR_SAP_ID":"0001022192","DLR_RADL_CD":"Acquire"},{"DLR_SAP_ID":"0001022164","DLR_RADL_CD":"Light Touch"},{"DLR_SAP_ID":"0001022334","DLR_RADL_CD":"Retain"}],"rowCount":7,"rowLimitExceeded":false}]}';
        
            
        
        catch(Exception le) {
         System.debug('Message: ' + le.getMessage() + 'Cause: ' + le.getCause() + 'Line number: ' + le.getLineNumber() + 'Stack trace: ' + le.getStackTraceString());    
            
        }
        System.assert(!accountList.isEmpty(),'Accounts Created');
        System.assert(!eventList.isEmpty(),'Events Created');
        
        System.assertEquals(!eventList.isEmpty(),!accountList.isEmpty(),'Events Created for Account');
        System.assertEquals(!accountCommunicationList.isEmpty(),!accountList.isEmpty(),'Account Communications Created for Account');
        //System.assertEquals(!bussinessRoleList.isEmpty(),!accountList.isEmpty(),'Bussiness Role Created for Account');
        
           
           
    }
    }
        return accountList;
    }
    static testmethod void getAccountBayers() {
         List<Account> accList = getAccountList();
       Test.startTest();
        try{
         String response ='{"queueDuration":2,"queryDuration":4109,"results":[{"resultSet":true,"data":[{"CNTRY_CD":"US","SLS_DIST_NM":"IOWA","DLR_SAP_ID":"0001028024","FISCL_YR":"2017","DLR_RADL_CD":"Develop","AREA_UOM":"AC","DLR_TOT_AREA_QTY":23627.412,"DLR_MON_AREA_QTY":11578.804,"DLR_OPRTNTY_AREA_QTY":10507.088,"MON_LAND_SHR_PCT":49.00581,"SLS_FRCST_TOT_BDGT":null,"CORN_FSA_AREA_CY":null,"CORN_FSA_AREA_CYM1":16806.72,"CORN_FSA_AREA_CYM2":15413.84,"CORN_FSA_AREA_CYM3":10483.24,"CORN_MON_AREA_CY":null,"CORN_MON_AREA_CYM1":8198.58,"CORN_MON_AREA_CYM2":7635.07,"CORN_MON_AREA_CYM3":6974.48,"CORN_NET_SLS_CY_QTY":null,"CORN_NET_SLS_CYM1_QTY":3315.10,"CORN_NET_SLS_CYM2_QTY":3108.01,"CORN_NET_SLS_CYM3_QTY":2845.00,"CORN_TOTAL_SLS_CY_QTY":null,"CORN_TOTAL_SLS_CYM1_QTY":1139775.70,"CORN_TOTAL_SLS_CYM2_QTY":1004278.75,"CORN_TOTAL_SLS_CYM3_QTY":980057.00,"SOY_FSA_AREA_CY":null,"SOY_FSA_AREA_CYM1":6820.70,"SOY_FSA_AREA_CYM2":6174.41,"SOY_FSA_AREA_CYM3":7860.68,"SOY_MON_AREA_CY":null,"SOY_MON_AREA_CYM1":3380.23,"SOY_MON_AREA_CYM2":4509.31,"SOY_MON_AREA_CYM3":4008.21,"SOY_NET_SLS_CY_QTY":null,"SOY_NET_SLS_CYM1_QTY":3647.00,"SOY_NET_SLS_CYM2_QTY":4879.00,"SOY_NET_SLS_CYM3_QTY":4356.00,"SOY_TOTAL_SLS_CY_QTY":null,"SOY_TOTAL_SLS_CYM1_QTY":227566.00,"SOY_TOTAL_SLS_CYM2_QTY":315505.00,"SOY_TOTAL_SLS_CYM3_QTY":328097.00}],"rowCount":1,"rowLimitExceeded":false}]}';
          
        
        if(!accList.isEmpty()){
          AccountController.Status = 'Positive';
         AccountController.getRecentTouchPoints(accList[0].Id);
            Accountcontroller.getAccountDetails(accList[0].Id,accountCommunicationList[0].Id,response);
          Accountcontroller.getAccountDetails(accountCommunicationList[0].Id,accList[0].Id,response);
         
    }
        }
        catch(Exception le) {
         System.debug('Message: ' + le.getMessage() + 'Cause: ' + le.getCause() + 'Line number: ' + le.getLineNumber() + 'Stack trace: ' + le.getStackTraceString());    
            
        }
        
         Test.stopTest();
    } 
    static testmethod void getAccounts() {
         List<Account> accList = getAccountList();
       Test.startTest();
        try{
         String response ='{"queueDuration":2,"queryDuration":4109,"results":[{"resultSet":true,"data":[{"CNTRY_CD":"US","SLS_DIST_NM":"IOWA","DLR_SAP_ID":"0001028024","FISCL_YR":"2017","DLR_RADL_CD":"Develop","AREA_UOM":"AC","DLR_TOT_AREA_QTY":23627.412,"DLR_MON_AREA_QTY":11578.804,"DLR_OPRTNTY_AREA_QTY":10507.088,"MON_LAND_SHR_PCT":49.00581,"SLS_FRCST_TOT_BDGT":null,"CORN_FSA_AREA_CY":null,"CORN_FSA_AREA_CYM1":16806.72,"CORN_FSA_AREA_CYM2":15413.84,"CORN_FSA_AREA_CYM3":10483.24,"CORN_MON_AREA_CY":null,"CORN_MON_AREA_CYM1":8198.58,"CORN_MON_AREA_CYM2":7635.07,"CORN_MON_AREA_CYM3":6974.48,"CORN_NET_SLS_CY_QTY":null,"CORN_NET_SLS_CYM1_QTY":3315.10,"CORN_NET_SLS_CYM2_QTY":3108.01,"CORN_NET_SLS_CYM3_QTY":2845.00,"CORN_TOTAL_SLS_CY_QTY":null,"CORN_TOTAL_SLS_CYM1_QTY":1139775.70,"CORN_TOTAL_SLS_CYM2_QTY":1004278.75,"CORN_TOTAL_SLS_CYM3_QTY":980057.00,"SOY_FSA_AREA_CY":null,"SOY_FSA_AREA_CYM1":6820.70,"SOY_FSA_AREA_CYM2":6174.41,"SOY_FSA_AREA_CYM3":7860.68,"SOY_MON_AREA_CY":null,"SOY_MON_AREA_CYM1":3380.23,"SOY_MON_AREA_CYM2":4509.31,"SOY_MON_AREA_CYM3":4008.21,"SOY_NET_SLS_CY_QTY":null,"SOY_NET_SLS_CYM1_QTY":3647.00,"SOY_NET_SLS_CYM2_QTY":4879.00,"SOY_NET_SLS_CYM3_QTY":4356.00,"SOY_TOTAL_SLS_CY_QTY":null,"SOY_TOTAL_SLS_CYM1_QTY":227566.00,"SOY_TOTAL_SLS_CYM2_QTY":315505.00,"SOY_TOTAL_SLS_CYM3_QTY":328097.00}],"rowCount":1,"rowLimitExceeded":false}]}';
          
        
        if(!accList.isEmpty()){
          AccountController.Status = 'Negative';
         AccountController.getRecentTouchPoints(accList[0].Id);
            Accountcontroller.getAccountDetails(accList[0].Id,accountCommunicationList[0].Id,response);
          Accountcontroller.getAccountDetails(accountCommunicationList[0].Id,accList[0].Id,response);
         
    }
        }
        catch(Exception le) {
         System.debug('Message: ' + le.getMessage() + 'Cause: ' + le.getCause() + 'Line number: ' + le.getLineNumber() + 'Stack trace: ' + le.getStackTraceString());    
            
        }
        
         Test.stopTest();
    } 
}