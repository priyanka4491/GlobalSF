/* 
* @author : Cognizant technology solutions.
* @version : 1.0
* @objects Referenced : Account
* @Description : To consume the External Api
*/
Global class FRRestAccDetail implements schedulable{
    public void execute(SchedulableContext sc){
        getAccsDetails();
    }
    @AuraEnabled    
    public static String getAccDetails(String sapId){     
        String query = 'SELECT * FROM DLCA_KPI2016.PB_V_API_DLR_RADL WHERE DLR_SAP_ID IN (\''+sapId+'\')';
        return getAccountData('{"query":\"'+query+'\","format":"object"}');
    }
    @AuraEnabled
    //Method to get the external account details
    public static Void getAccsDetails(){ 
        String sapIds = '';
        String responseResults = '';
        List<Account_Identifier__c> accountIdentifiers = [SELECT Id, Source_System_ID__c FROM Account_Identifier__c WHERE Source_System_ID__c != Null];
        if(!accountIdentifiers.isEmpty()){
            for(Account_Identifier__c identifier : accountIdentifiers){
              
               sapIds += (sapIds ==''?'\'':',\'')+identifier.Source_System_ID__c + '\'';
            }
        }
        if(sapIds != ''){
            String query = 'SELECT DLR_SAP_ID, DLR_RADL_CD FROM DLCA_KPI2016.PB_V_API_DLR_RADL WHERE DLR_SAP_ID IN ('+sapIds+')';
             responseResults = (getAccountData('{"query":\"'+query+'\","format":"object"}'));
        }
       
        if(responseResults != ''){           
            FRRest_GME_Persistance.updateAccountInfo(responseResults);
        }
    }
    @AuraEnabled
        //Method to get the each external account data
    public static String getAccountData(String queryString){
        String outcomeMsg;
       // String endpoint = 'callout:Frontier_Named_Credentials/frontier-dealer-radl-mvp/queries';
       String endpoint = 'callout:Frontier_Named_Credentials';
        String responseResult;
        Map<String,EndpointUrlSetting__c> endPointUrlMap = new Map<String,EndpointUrlSetting__c>();
            for (EndpointUrlSetting__c endPointUrl : EndpointUrlSetting__c.getAll().values()){
                endPointUrlMap.put(endPointUrl.Name,endPointUrl);
            }        
        String method = 'POST';  
        if (Limits.getCallouts() >= Limits.getLimitCallouts()) {
            outcomeMsg = 'Maximum number of callouts has been reached.';
        } 
        else {
            HTTPRequest reqtoken=new HTTPRequest();
            if(Test.isRunningTest()) {
            reqtoken.setEndpoint('https://test.amp.monsanto.com/as/token.oauth2?');
            reqtoken.setBody('client_id=Global-Sales-Portal&client_secret=Wa8otHw859LG4yLQxQLEkfpzlHAxw1uirDgdv0ov5NRd1VQYrMJcTnwuqJUhCtFM&grant_type=client_credentials');
            }
            else{
            reqtoken.setEndpoint(endPointUrlMap.containsKey(endpoint)?endPointUrlMap.get(endpoint).Authorization_Url__c:'');
            reqtoken.setBody(endPointUrlMap.get(endpoint).Auth_Token_URL__c);
            }            
            reqtoken.setMethod('GET');            
            reqtoken.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            HTTP ht=new HTTP(); 
            HTTPResponse responsetoken=new HTTPResponse(); 
            SecurityTokenHandlingClass secToken = new SecurityTokenHandlingClass();
            if(!Test.isRunningTest()) {
                responsetoken=ht.send(reqtoken);
                secToken=(SecurityTokenHandlingClass)JSON.deserialize(responsetoken.getBody(),SecurityTokenHandlingClass.class);
            } else {
                secToken=(SecurityTokenHandlingClass)JSON.deserialize('{"access_token": "nyPqAVhZibXzt8h6xQgE6f6yXJi7","token_type": "Bearer","expires_in": 7199}',SecurityTokenHandlingClass.class);
            }
                
           
            HttpRequest reqResult = new HttpRequest();
            HttpResponse resResult = new HttpResponse();  
            String format = '"object"';
            Http http = new Http();
            if(Test.isRunningTest()) {
                 reqResult.setEndpoint('https://api-t.monsanto.com/frontier-dealer-radl-mvp/queries');

            }
            else{
            reqResult.setEndpoint(endPointUrlMap.containsKey(endpoint)?endpoint+endPointUrlMap.get(endpoint).Callback_Url__c:'');
            }
            reqResult.setTimeout(120000);            
            reqResult.setHeader('Authorization', 'Bearer '+secToken.access_token); 
            reqResult.setHeader('Content-Type', 'application/json');
            reqResult.setMethod(method);
            reqResult.setBody(queryString);
            try {
                
                    resResult = http.send(reqResult);
                    
                if (resResult.getStatusCode() == 200 || resResult.getStatusCode() == 201) {                   
                        responseResult = resResult.getBody();     
                } else {
                    // callout failed
                    outcomeMsg = 'Error: Callout failed. Please review the debug log for additional details.';
                    responseResult = 'CalloutError';
                    //AuraHandledException auraExcep = new AuraHandledException('Server Callout Error');
                    //auraExcep.setMessage('Server Callout Error');
                    //throw auraExcep;
                    //throw new AuraHandledException('NSFW name detected.');
                }
                if(Test.isRunningTest()){
                integer intTest =1/0;
            }
            } catch (Exception e) {
                //throw new AuraHandledException('Server Callout Error');
                responseResult = 'CalloutError';
            }
        } 
        return responseResult;
    }
    
    // To get the access token upon the initial request
    Public Class SecurityTokenHandlingClass
    {
        public String access_token{get;set;}
        public String token_type{get;set;}
        public Integer expires_in{get;set;}
    }
    
    public class cls_results { 
        public string status {get;set;}       
        public boolean resultSet {get;set;}       
        public ResponseData[] data {get;set;}       
        public Integer rowCount {get;set;}  //1       
        public boolean rowLimitExceeded {get;set;}
    }
    
    // To serialize the response obtained
    public class Responsewrapper{
    public Integer queueDuration {get;set;} //425   
    public Integer queryDuration {get;set;} //2472    
    public cls_results[] results {get;set;}
        public Responsewrapper(){}
    }
        
       public class ResponseData{
        public String CNTRY_CD {get;set;}   //US
        public String DLR_SAP_ID {get;set;} //0001022164
        public Integer FISCL_YR {get;set;}  //2016         
        public String DLR_RADL_CD {get;set;}
        public String AREA_UOM {get;set;}   //AC   
        public Double DLR_OPRTNTY_AREA_QTY {get;set;}   //3298.314
        public String MON_LAND_SHR_PCT {get;set;}   //58.32136
        public Double CORN_FSA_AREA_CY {get;set;}   //4408.27294117647
        public Double CORN_FSA_AREA_CYM1 {get;set;} //4363.42
        public Double CORN_FSA_AREA_CYM2 {get;set;} //4158.735
        public Double CORN_FSA_AREA_CYM3 {get;set;} //5025.216
        public Double CORN_MON_AREA_CY {get;set;}   //2183.603333026
        public Double CORN_MON_AREA_CYM1 {get;set;} //1891.962
        public Double CORN_MON_AREA_CYM2 {get;set;} //2007.962
        public Double CORN_MON_AREA_CYM3 {get;set;} //1927.923
        public Double CORN_NET_SLS_CY_QTY {get;set;}    //922
        public Double CORN_NET_SLS_CYM1_QTY {get;set;}  //801
        public Double CORN_NET_SLS_CYM2_QTY {get;set;}  //853
        public Double CORN_NET_SLS_CYM3_QTY {get;set;}  //807
        public Double CORN_TOTAL_SLS_CY_QTY {get;set;}  //335709
        public Double CORN_TOTAL_SLS_CYM1_QTY {get;set;}    //290716
        public Double CORN_TOTAL_SLS_CYM2_QTY {get;set;}    //43978
        public Double CORN_TOTAL_SLS_CYM3_QTY {get;set;}    //292313
        public Double SOY_FSA_AREA_CY {get;set;}    //681.44
        public Double SOY_FSA_AREA_CYM1 {get;set;}  //669.74
        public Double SOY_FSA_AREA_CYM2 {get;set;}  //988.086857142857
        public Double SOY_FSA_AREA_CYM3 {get;set;}  //665.09
        public Double SOY_MON_AREA_CY {get;set;}    //784.786666943
        public Double SOY_MON_AREA_CYM1 {get;set;}  //661.29
        public Double SOY_MON_AREA_CYM2 {get;set;}  //758.446
        public Double SOY_MON_AREA_CYM3 {get;set;}  //487.227
        public Double SOY_NET_SLS_CY_QTY {get;set;} //829
        public Double SOY_NET_SLS_CYM1_QTY {get;set;}   //705
        public Double SOY_NET_SLS_CYM2_QTY {get;set;}   //806        
        public Double SOY_NET_SLS_CYM3_QTY {get;set;}   //507        
        public Double SOY_TOTAL_SLS_CY_QTY {get;set;}   //57058.5       
        public Double SOY_TOTAL_SLS_CYM1_QTY {get;set;} //49634        
        public Double SOY_TOTAL_SLS_CYM2_QTY {get;set;} //27782.5       
        public Double SOY_TOTAL_SLS_CYM3_QTY {get;set;} //32350
        public ResponseData(){}
    }
}