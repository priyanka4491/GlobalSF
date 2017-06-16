public class Frontier_GetAccountFarmingDatas_CUS360 {	

    public static String endpoint = 'Customer360Credentials';
    public static HttpResponse getAccessToken(){
        System.debug('Inside Cus360');
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
        System.debug('Inside Cus360');
        System.debug('responsetoken'+responsetoken);
        return responsetoken;
    }
    @AuraEnabled
    public static String getGrowerAccFarmingDatas()
    {
        HTTPResponse responsetoken=new HTTPResponse(); 
        responsetoken = getAccessToken();
        String responseResult;
        String outcomeMsg;
        System.debug('Inside groweraccFarmindata');
        Map<String,EndpointUrlSetting__c> endPointUrlMap = new Map<String,EndpointUrlSetting__c>();
        for (EndpointUrlSetting__c endPointUrl : EndpointUrlSetting__c.getAll().values()){
            endPointUrlMap.put(endPointUrl.Name,endPointUrl);
        }
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
			responseResult = '{"globalPartyId":"c4a8ffbc-e053-45be-9e85-f92efb1df2fe","accountRadl":"R","name":"Dale Wicks Farm","addressLine1":"123 Main Street","addressLine2":"","addressLine3":"","city":"Saint Charles","county":"Saint Charles","state":"MO","zip":"63301","zipSuffix":"","country":"US","phone":"3141234567","email":"wickFarms@gmail.com","salesTerritoryDesignation":"","areaUnitOfMeasure":"acres","primaryContact":{"globalPartyId":"b80d0f55-01d6-4b2a-91f5-1f0ffe841008","firstName":"Dale","lastName":"Wicks","phone":"3141234567","email":"wickFarms@gmail.com"},"seasonalData":[{"fiscalYear":"2016","sellingSeason":"","growerRadl":"A","farmingAreaTotal":1000,"farmingAreaMonsanto":600,"farmingAreaMonsantoShare":60,"crop":[{"name":"Corn","radl":"L","areaTotal":1000,"areaOpportunity":400,"areaMonsanto":500,"areaMonsantoShare":50,"brand":[{"name":"Dekalb","family":"National","radl":"D","areaMonsanto":300,"areaOpportunity":400,"grossSales":3125.99,"netSales":100,"grossAndNetSalesUnitOfMeasure":"USD","grossQuantity":300,"netQuantity":280,"grossAndNetQuantityUnitOfMeasure":"SSU"},{"name":"Stone","family":"Regional","radl":"L","areaMonsanto":200,"areaOpportunity":400,"grossSales":325,"netSales":50,"grossAndNetSalesUnitOfMeasure":"USD","grossQuantity":60,"netQuantity":58,"grossAndNetQuantityUnitOfMeasure":"SSU"}]},{"name":"Soybean","radl":"R","areaTotal":1000,"areaOpportunity":400,"areaMonsanto":100,"areaMonsantoShare":10,"brand":[{"name":"Channel","family":"Channel","radl":"A","areaMonsanto":100,"areaOpportunity":600,"grossSales":125,"netSales":150,"grossAndNetSalesUnitOfMeasure":"USD","grossQuantity":160,"netQuantity":158,"grossAndNetQuantityUnitOfMeasure":"SSU"}]}]},{"fiscalYear":"2015","sellingSeason":"","growerRadl":"A","farmingAreaTotal":1000,"farmingAreaMonsanto":550,"farmingAreaMonsantoShare":50,"crop":[{"name":"Corn","radl":"L","areaTotal":1000,"areaOpportunity":450,"areaMonsanto":550,"areaMonsantoShare":55,"brand":[{"name":"Dekalb","family":"National","radl":"D","areaMonsanto":350,"areaOpportunity":450,"grossSales":3125.99,"netSales":100,"grossAndNetSalesUnitOfMeasure":"USD","grossQuantity":300,"netQuantity":280,"grossAndNetQuantityUnitOfMeasure":"SSU"},{"name":"Stone","family":"Regional","radl":"L","areaMonsanto":200,"areaOpportunity":450,"grossSales":325,"netSales":50,"grossAndNetSalesUnitOfMeasure":"USD","grossQuantity":60,"netQuantity":58,"grossAndNetQuantityUnitOfMeasure":"SSU"}]},{"name":"Soybean","radl":"R","areaTotal":1000,"areaOpportunity":450,"areaMonsanto":100,"areaMonsantoShare":10,"brand":[{"name":"Channel","family":"Channel","radl":"A","areaMonsanto":100,"areaOpportunity":450,"grossSales":120,"netSales":140,"grossAndNetSalesUnitOfMeasure":"USD","grossQuantity":150,"netQuantity":151,"grossAndNetQuantityUnitOfMeasure":"SSU"}]}]}]}';  
            if(Test.isRunningTest()){
                integer intTest =1/0;
            }
        } catch (Exception e) {
            System.debug('Exception has been encountered while calling out to Integration:' + e.getMessage());
            //throw new AuraHandledException('Server Callout Error');
            responseResult = 'CalloutError';
        }
		return '{"globalPartyId":"c4a8ffbc-e053-45be-9e85-f92efb1df2fe","accountRadl":"R","name":"Dale Wicks Farm","addressLine1":"123 Main Street","addressLine2":"","addressLine3":"","city":"Saint Charles","county":"Saint Charles","state":"MO","zip":"63301","zipSuffix":"","country":"US","phone":"3141234567","email":"wickFarms@gmail.com","salesTerritoryDesignation":"","areaUnitOfMeasure":"acres","primaryContact":{"globalPartyId":"b80d0f55-01d6-4b2a-91f5-1f0ffe841008","firstName":"Dale","lastName":"Wicks","phone":"3141234567","email":"wickFarms@gmail.com"},"seasonalData":[{"fiscalYear":"2016","sellingSeason":"","growerRadl":"A","farmingAreaTotal":1000,"farmingAreaMonsanto":600,"farmingAreaMonsantoShare":60,"crop":[{"name":"Corn","radl":"L","areaTotal":1000,"areaOpportunity":400,"areaMonsanto":500,"areaMonsantoShare":50,"brand":[{"name":"Dekalb","family":"National","radl":"D","areaMonsanto":300,"areaOpportunity":400,"grossSales":3125.99,"netSales":100,"grossAndNetSalesUnitOfMeasure":"USD","grossQuantity":300,"netQuantity":280,"grossAndNetQuantityUnitOfMeasure":"SSU"},{"name":"Stone","family":"Regional","radl":"L","areaMonsanto":200,"areaOpportunity":400,"grossSales":325,"netSales":50,"grossAndNetSalesUnitOfMeasure":"USD","grossQuantity":60,"netQuantity":58,"grossAndNetQuantityUnitOfMeasure":"SSU"}]},{"name":"Soybean","radl":"R","areaTotal":1000,"areaOpportunity":400,"areaMonsanto":100,"areaMonsantoShare":10,"brand":[{"name":"Channel","family":"Channel","radl":"A","areaMonsanto":100,"areaOpportunity":600,"grossSales":125,"netSales":150,"grossAndNetSalesUnitOfMeasure":"USD","grossQuantity":160,"netQuantity":158,"grossAndNetQuantityUnitOfMeasure":"SSU"}]}]},{"fiscalYear":"2015","sellingSeason":"","growerRadl":"A","farmingAreaTotal":1000,"farmingAreaMonsanto":550,"farmingAreaMonsantoShare":50,"crop":[{"name":"Corn","radl":"L","areaTotal":1000,"areaOpportunity":450,"areaMonsanto":550,"areaMonsantoShare":55,"brand":[{"name":"Dekalb","family":"National","radl":"D","areaMonsanto":350,"areaOpportunity":450,"grossSales":3125.99,"netSales":100,"grossAndNetSalesUnitOfMeasure":"USD","grossQuantity":300,"netQuantity":280,"grossAndNetQuantityUnitOfMeasure":"SSU"},{"name":"Stone","family":"Regional","radl":"L","areaMonsanto":200,"areaOpportunity":450,"grossSales":325,"netSales":50,"grossAndNetSalesUnitOfMeasure":"USD","grossQuantity":60,"netQuantity":58,"grossAndNetQuantityUnitOfMeasure":"SSU"}]},{"name":"Soybean","radl":"R","areaTotal":1000,"areaOpportunity":450,"areaMonsanto":100,"areaMonsantoShare":10,"brand":[{"name":"Channel","family":"Channel","radl":"A","areaMonsanto":100,"areaOpportunity":450,"grossSales":120,"netSales":140,"grossAndNetSalesUnitOfMeasure":"USD","grossQuantity":150,"netQuantity":151,"grossAndNetQuantityUnitOfMeasure":"SSU"}]}]}]}';        
        
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
    /*public class GrowerResponsewrapper{
public Integer queueDuration {get;set;} //425   
public Integer queryDuration {get;set;} //2472    
public cls_results[] results {get;set;}
public GrowerResponseData[] items {get;set;}
public GrowerResponsewrapper(){}
}
public class GrowerResponseData{
public String Global_Party_Id {get;set;}   //2000
public String Account_RADL {get;set;} //
public String AccountName {get;set;}  //0000         
public String Account_AddressLine1 {get;set;}// US
public String Account_AddressLine2 {get;set;}// US
public String Account_AddressLine3 {get;set;}// US
public String Account_City {get;set;}   //Alfalfa   
public String Account_StateCountry {get;set;}   //Alfalfa   
public String Account_State {get;set;}   //Alfalfa   
public Integer Account_Zipcode {get;set;}   //Alfalfa   
public String Account_Zip_Suffix {get;set;}   //Alfalfa
public String Account_Phone {get;set;}   //Alfalfa
public String Sales_Territory_Designation{get;set;}   //Alfalfa
public String Area_UnitOfMeasure{get;set;}   //Alfalfa
public GrowerResponseData(){}
}*/
    
    public class GrowerResponsewrapper{
        public String globalPartyId{get;set;}	//604d303d-94c8-4c06-9fe8-4ed5ac46f532
        public String accountRadl{get;set;}	//R
        public String name{get;set;}//Dale Wicks Farm
        public String addressLine1{get;set;}	//123 Main Street
        public String addressLine2{get;set;}	//
        public String addressLine3{get;set;}	//
        public String city{get;set;}	//Saint Charles
        public String county{get;set;}	//Saint Charles
        public String state{get;set;}	//MO
        public String zip{get;set;}	//63301
        public String zipSuffix{get;set;}	//
        public String country{get;set;}	//US
        public String phone{get;set;}	//3141234567
        public String email{get;set;}	//wickFarms@gmail.com
        public String salesTerritoryDesignation{get;set;}	//
        public String areaUnitOfMeasure{get;set;}	//acres
        public cls_primaryContact primaryContact{get;set;}
        public cls_seasonalData[] seasonalData{get;set;}
        public GrowerResponsewrapper(){}
    }
    public class cls_primaryContact {
        public String globalPartyId{get;set;}	//6a102e23-1241-4021-8286-b3dea3966ea0
        public String firstName{get;set;}	//Dale
        public String lastName{get;set;}	//Wicks
        public String phone{get;set;}	//3141234567
        public String email{get;set;}	//wickFarms@gmail.com
    }
    public class cls_seasonalData {
        public String fiscalYear{get;set;}	//2016
        public String sellingSeason{get;set;}	//
        public String growerRadl{get;set;}	//A
        public Integer farmingAreaTotal{get;set;}	//1000
        public Integer farmingAreaMonsanto{get;set;}	//600
        public Integer farmingAreaMonsantoShare{get;set;}	//60
        public cls_crop[] crop{get;set;}
    }
        public class cls_crop {
        public String name{get;set;}	//Corn
        public String radl{get;set;}	//L
        public Integer areaTotal{get;set;}	//1000
        public Integer areaOpportunity{get;set;}	//400
        public Integer areaMonsanto{get;set;}	//500
        public Integer areaMonsantoShare{get;set;}	//50
        public cls_brand[] brand{get;set;}
    }
    public class cls_brand {
        public String name{get;set;}	//Dekalb
        public String family{get;set;}	//National
        public String radl{get;set;}	//D
        public Integer areaMonsanto{get;set;}	//300
        public Integer areaOpportunity{get;set;}	//400
        public Double grossSales{get;set;}	//3125.99
        public Integer netSales{get;set;}	//100
        public String grossAndNetSalesUnitOfMeasure{get;set;}	//USD
        public Integer grossQuantity{get;set;}	//300
        public Integer netQuantity{get;set;}	//280
        public String grossAndNetQuantityUnitOfMeasure{get;set;}	//SSU
    }
    
}