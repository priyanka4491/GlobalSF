Global class FRRestAuth{    
   	 public static HttpResponse getAccessToken(){
        String endpoint = 'Company360Credentials';
        Map<String,EndpointUrlSetting__c> endPointUrlMap = new Map<String,EndpointUrlSetting__c>();
            for (EndpointUrlSetting__c endPointUrl : EndpointUrlSetting__c.getAll().values()){
                endPointUrlMap.put(endPointUrl.Name,endPointUrl);
            }
        String clientId = endPointUrlMap.containsKey(endpoint)?endPointUrlMap.get(endpoint).Client_Id__c:'';
        String clientSecret = endPointUrlMap.containsKey(endpoint)?endPointUrlMap.get(endpoint).Client_Secret__c:'';        
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
    @AuraEnabled
    public static String getGrowerAccs()
    {
        HTTPResponse responsetoken=new HTTPResponse(); 
        responsetoken = getAccessToken();
        String endpoint = 'Company360Credentials';
        String responseResult;
        String outcomeMsg;
        Map<String,EndpointUrlSetting__c> endPointUrlMap = new Map<String,EndpointUrlSetting__c>();
            for (EndpointUrlSetting__c endPointUrl : EndpointUrlSetting__c.getAll().values()){
                endPointUrlMap.put(endPointUrl.Name,endPointUrl);
            }
        SecurityTokenHandlingClass secToken = new SecurityTokenHandlingClass();
        secToken=(SecurityTokenHandlingClass)JSON.deserialize(responsetoken.getBody(),SecurityTokenHandlingClass.class);
        System.debug(secToken.access_token);
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
        } catch (Exception e) {
            System.debug('Exception has been encountered while calling out to Integration:' + e.getMessage());
            //throw new AuraHandledException('Server Callout Error');
            responseResult = 'CalloutError';
        }
        return responseResult;
    }
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
    public class GrowerResponsewrapper{
    //public Integer queueDuration {get;set;} //425   
    //public Integer queryDuration {get;set;} //2472    
    //public cls_results[] results {get;set;}
    public GrowerResponseData[] items {get;set;}
        public GrowerResponsewrapper(){}
    }
    public class GrowerResponseData{
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
        public GrowerResponseData(){}
    }
}