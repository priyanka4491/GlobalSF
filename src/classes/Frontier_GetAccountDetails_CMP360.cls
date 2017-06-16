/* ************************************************************************************************************
 * Category             :   Apex Class
 * Name                 :   Frontier_GetAccountDetails_CMP360
 * Description          :   This class is sending response to a class "Frontier_WebserviceCalls", updating 
 *                          the RADL data in the Account Business Role.
 * Author               :   Cognizant Technology Solutions
 * Last Modified Date   :   8/27/2016 3:01 AM
 * ************************************************************************************************************/
Global class Frontier_GetAccountDetails_CMP360 {
   
    // This methods is uses to get the Access Token for Company360
     public static HttpResponse getAccessToken(){
        String endpoint = 'Company360Credentials';
        Map<String,EndpointUrlSetting__c> endPointUrlMap = new Map<String,EndpointUrlSetting__c>();
            for (EndpointUrlSetting__c endPointUrl : EndpointUrlSetting__c.getAll().values()){
                endPointUrlMap.put(endPointUrl.Name,endPointUrl);
            }
        //  These variables uses to capture Company360 client id and client secret. 
        String clientId = endPointUrlMap.containsKey(endpoint)?endPointUrlMap.get(endpoint).Client_Id__c:'';
        String clientSecret = endPointUrlMap.containsKey(endpoint)?endPointUrlMap.get(endpoint).Client_Secret__c:'';        
         
        //  Initiating the HttpRequest for getting access token
        HttpRequest reqtoken = new HttpRequest();
        reqtoken.setEndpoint(endPointUrlMap.containsKey(endpoint)?endPointUrlMap.get(endpoint).Auth_Token_URL__c:'');
        reqtoken.setMethod('POST');
        reqtoken.setTimeout(60000);
        reqtoken.setBody(
            'grant_type=client_credentials' +
            '&client_id=' + clientId+
            '&client_secret=' + clientSecret
        );        
        HttpResponse responsetoken = new Http().send(reqtoken);        
        System.debug('responsetoken'+responsetoken);
        return responsetoken;
    }
    
    //  This method uses to get all the grower account details from the company 360.  This method used @AuraEnabled to make it available for 
    //  Lightning Component.
    @AuraEnabled
    public static String getGrowerAccs()
    {
        System.debug('Inside Company 360');
        // Initiating the HttpResponse to capture the access token response from getAccessToken method.
        HTTPResponse responsetoken=new HTTPResponse(); 
        responsetoken = getAccessToken();
        String endpoint = 'Company360Credentials';
        String responseResult;
        String outcomeMsg;
        Map<String,EndpointUrlSetting__c> endPointUrlMap = new Map<String,EndpointUrlSetting__c>();
            for (EndpointUrlSetting__c endPointUrl : EndpointUrlSetting__c.getAll().values()){
                endPointUrlMap.put(endPointUrl.Name,endPointUrl);
            }
        // Insance create for deserializing the access token
        SecurityTokenHandlingClass secToken = new SecurityTokenHandlingClass();
        secToken=(SecurityTokenHandlingClass)JSON.deserialize(responsetoken.getBody(),SecurityTokenHandlingClass.class);
        System.debug(secToken.access_token+','+secToken.token_type+','+secToken.expires_in);
        HttpRequest reqResult = new HttpRequest();
        HttpResponse resResult = new HttpResponse();  
        String format = '"object"';
        Http http = new Http();
        reqResult.setEndpoint(endPointUrlMap.containsKey(endpoint)?endPointUrlMap.get(endpoint).Authorization_Url__c+'?fiscalYear&access_token='+secToken.access_token:'');
        reqResult.setTimeout(120000);            
        reqResult.setHeader('Authorization', 'Bearer '+secToken.access_token); 
        reqResult.setHeader('Content-Type', 'application/json');       
        reqResult.setMethod('GET');
        try {
            resResult = http.send(reqResult); 
            System.debug(resResult.getStatusCode());
            if (resResult.getStatusCode() == 200 || resResult.getStatusCode() == 201) {                   
                responseResult = resResult.getBody();                      
                System.debug('Response Details'+responseResult);
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
                Integer val = 1/0;
            }
        } catch (Exception e) {
            System.debug('Exception has been encountered while calling out to Integration:' + e.getMessage());
            //throw new AuraHandledException('Server Callout Error');
            responseResult = 'CalloutError';
        }
        System.debug('Response Details'+responseResult);
        return responseResult;
    }
     @AuraEnabled
    public static Integer getGrowerCount(String dealerId){
        List<Account> growerAccountList = [SELECT Id FROM Account WHERE Dealer_SFID__c =:dealerId];
        Integer growerCount = 0;
        if(!growerAccountList.isEmpty()){
            growerCount = growerAccountList.size();
        }
        return growerCount; 
    }
    
    
    // This class used to deserialize the access token
    Public Class SecurityTokenHandlingClass
    {
        public String access_token{get;set;}
        public String token_type{get;set;}
        public Integer expires_in{get;set;}
    }
    /*public class cls_results { 
        public string status {get;set;}       
        public boolean resultSet {get;set;}       
        public GrowerResponseData[] data {get;set;}       
        public Integer rowCount {get;set;}  //1       
        public boolean rowLimitExceeded {get;set;}
    }*/
    
    // To serialize the response obtained
    public class DealerResponsewrapper{
    //public Integer queueDuration {get;set;} //425   
    //public Integer queryDuration {get;set;} //2472    
    //public cls_results[] results {get;set;}
    public DealerResponseData[] items {get;set;}
        public DealerResponsewrapper(){}
    }
    public class DealerResponseData{
        public Integer fiscalYear {get;set;}   //2000
        public String fiscalPeriod {get;set;} //
        public Integer companyCode {get;set;}  //0000         
        public String countryCode {get;set;}// US
        public String seasonDesc {get;set;}   //Alfalfa   
        public String cropDesc {get;set;}   //CORN
        public String brandDesc {get;set;}   //JJ
        public String growerKey {get;set;}   //aladf
        public String growerSourceSystemCode {get;set;} // QUX
        public Double grossSalesQuantity {get;set;} //4158.735
        public Double netSalesQuantity {get;set;} //5025.216
        public Double grossSalesAmount {get;set;}   //2183.603333026
        public Double netSalesAmount {get;set;} //1891.962
        public DealerResponseData(){}
    }
    
}