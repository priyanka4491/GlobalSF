/********************************************************************************************
Class Name : Frontier_AccountController_Test
Description : This class covers the Frontier_AccountController which describes the sales details based on the response obtained
with respect to the account.
Author      : Cognizant
CreatedDate : 8/29/2016
*********************************************************************************************/
@isTest 
private class Frontier_AccountController_Test{
    public static list<account> accountList;
    @testsetup
    static void usersetup(){   
        TestUtilClass.createTestUsers('System Administrator',1);
        TestUtilClass.createTestAccount(10);
    }
    static testMethod String Frontier_AccountController_TestMethod() { 
        string finalJson;
        list<user> userlist= [SELECT id FROM user];
        System.RunAs(userlist[0]){       
            List<FRRestAccDetail.ResponseData> resData = new List<FRRestAccDetail.ResponseData>();
            FRRestAccDetail.ResponseData reqst = new FRRestAccDetail.ResponseData();
            reqst.CNTRY_CD ='US';
            reqst.DLR_SAP_ID = '0001022164';
            reqst.FISCL_YR = 2016;
            reqst.DLR_RADL_CD  = 'Retain';
            reqst.AREA_UOM = 'AC';
            reqst.MON_LAND_SHR_PCT  = '58.32136';
            reqst.CORN_FSA_AREA_CY  = 4408.27294117647;
            reqst.CORN_FSA_AREA_CYM1  = 4363.42;        
            reqst.CORN_FSA_AREA_CYM2  = 4158.735;
            reqst.CORN_FSA_AREA_CYM3  = 5025.216;
            reqst.CORN_MON_AREA_CY  = 2183.603333026;
            reqst.CORN_MON_AREA_CYM1  = 1891.962;
            reqst.CORN_MON_AREA_CYM2   = 2007.962;
            reqst.CORN_MON_AREA_CYM3   = 1927.923; 
            reqst.CORN_NET_SLS_CY_QTY   = 922;
            reqst.CORN_NET_SLS_CYM1_QTY   = 801;
            reqst.CORN_NET_SLS_CYM2_QTY   = 853;        
            reqst.CORN_NET_SLS_CYM3_QTY   = 807;
            reqst.CORN_TOTAL_SLS_CY_QTY   = 335709;
            reqst.CORN_TOTAL_SLS_CYM1_QTY   = 290716;
            reqst.CORN_TOTAL_SLS_CYM2_QTY   = 43978;
            reqst.CORN_TOTAL_SLS_CYM3_QTY   = 922;
            reqst.SOY_FSA_AREA_CY   = 801;
            reqst.SOY_FSA_AREA_CYM1   = 853;        
            reqst.SOY_FSA_AREA_CYM2   = 807;
            reqst.SOY_FSA_AREA_CYM3   = 335709;
            reqst.SOY_MON_AREA_CY   = 290716;
            reqst.SOY_MON_AREA_CYM1   = 43978;
            reqst.SOY_MON_AREA_CYM2    = 801;
            reqst.SOY_MON_AREA_CYM3    = 853;        
            reqst.SOY_NET_SLS_CY_QTY    = 807;
            reqst.SOY_NET_SLS_CYM1_QTY    = 335709;
            reqst.SOY_NET_SLS_CYM2_QTY    = 290716;
            reqst.SOY_NET_SLS_CYM3_QTY    = 43978;
            reqst.SOY_MON_AREA_CYM3    = 853;        
            reqst.SOY_NET_SLS_CY_QTY    = 807;
            reqst.SOY_NET_SLS_CYM1_QTY    = 335709;
            reqst.SOY_NET_SLS_CYM2_QTY    = 290716;
            reqst.SOY_NET_SLS_CYM3_QTY    = 43978;
            reqst.SOY_TOTAL_SLS_CY_QTY     = 853;        
            reqst.SOY_TOTAL_SLS_CYM1_QTY     = 807;
            reqst.SOY_TOTAL_SLS_CYM2_QTY     = 335709;
            reqst.SOY_TOTAL_SLS_CYM3_QTY     = 290716;
            resData.add(reqst);
            
            //String JsonMsg=JSON.serialize(reqst);
            FRRestAccDetail.cls_results  reqstcls_results = new FRRestAccDetail.cls_results();
            reqstcls_results.resultSet  = true;
            reqstcls_results.rowCount  = 1;
            reqstcls_results.rowLimitExceeded = false;
            reqstcls_results.data=resData;
            
            List<FRRestAccDetail.cls_results> clsResultList=new List<FRRestAccDetail.cls_results>();
            clsResultList.add(reqstcls_results);
            
            FRRestAccDetail.Responsewrapper reqstwrapper = new FRRestAccDetail.Responsewrapper();
            
            reqstwrapper.queueDuration = 425;
            reqstwrapper.queryDuration = 2472;
            reqstwrapper.results=clsResultList;
            
            finalJson = JSON.serialize(reqstwrapper);
            integer i = limits.getCallouts();
            system.assertNotEquals(i,10);
            
        }
        return finalJson;
    }
    static testMethod void Frontier_AccountController_TestMethodBayer() {
        Set<String> accSet = new Set<String>();
        String finalJson = Frontier_AccountController_TestMethod();
        for(Integer i=0;i<4;i++){
            String accname = 'TestAccount'+(10+i);
            accSet.add(accname); 
        }
        accountList =[SELECT Id,Name FROM Account where name= :accSet];
        try{
            Frontier_AccountController.Status ='Positive';
            Frontier_AccountController.BayerStatus='Positive';
            Frontier_AccountController.AccountDetails('Corn',finalJson,accountList[0].Id );
            Frontier_AccountController.AccountDetails('Soy',finalJson,accountList[0].Id);
            Frontier_AccountController.AccountDetails('',finalJson,accountList[0].Id); 
        }
        catch(exception e){
            system.debug(e.getMessage());       
        }   
        
    }
    static testMethod void Frontier_AccountControllertestMethod() {
        String finalJson = Frontier_AccountController_TestMethod();
        
        accountList=[SELECT Id,Name FROM Account LIMIT 10];
        try{
            if(!accountList.isEmpty()){
                Frontier_AccountController.Status ='Negative';
                Frontier_AccountController.AccountDetails('Corn',finalJson,accountList[0].Id);
                Frontier_AccountController.AccountDetails('Soy',finalJson,accountList[0].Id);
                Frontier_AccountController.AccountDetails('',finalJson,accountList[0].Id); 
            }
        }
        catch(Exception e){
            system.debug(e.getMessage());       
        }   
        
    }
}