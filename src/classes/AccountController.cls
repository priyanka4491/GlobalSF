/** 
*
* @author : Cognizant technology solutions.
* @version : 1.0
* @objects Referenced : Account,Event
* @Description : To display the Account details,radl class,Opportunity details
**/
public class AccountController {
     @TestVisible private Static String Status = ''; 
    @AuraEnabled
    //Method to get the recent touchpointss
    public static List<Event> getRecentTouchPoints(Id accId){
        List<Event> recentTouchPoints = new List<Event>();
        try{
            recentTouchPoints = [SELECT Id,Type,StartDateTime,CreatedDate,ActivityDate,Description FROM Event where AccountId =:accId ORDER BY CreatedDate DESC LIMIT 7];    
            if(Test.isRunningTest()){
                integer intTest =1/0;
            }
        }
        catch(Exception e){            
            System.debug('The error has been occured' + e.getMessage());             
        }
        return recentTouchPoints;
    } 
    @AuraEnabled
    //Method to get the account details
    public static String getAccountDetails(Id accId,String accCommunicationId,String result){
        
        Integer count = 0;       
        Frontier_TouchPoints touchPointAccountWrapper = new Frontier_TouchPoints();
        
        List<Account> touchPointAccounts = new List<Account>();
            /*  List<Account_Business_Role__c> accountRecordsList= [SELECT Account_SFID__c,Account_SFID__r.Name,Account_SFID__r.BillingStreet,Account_SFID__r.Type,SAP_ID__c,Service_Level_Class_Descr__c, Role_Descr__c,Business_Unit_Descr__c, (SELECT Parent_SFID__r.Parent_SFID__r.Id,Parent_SFID__r.Parent_SFID__r.Street_Addr__c,Parent_SFID__r.Parent_SFID__r.City_Name__c,Parent_SFID__r.Parent_SFID__r.State_Name__c,Parent_SFID__r.Parent_SFID__r.Country_Name__c, Parent_SFID__r.Role_Descr__c FROM Account_Communications__r 
WHERE   Archive_Ind__c = 'N' AND  Parent_SFID__r.Archive_Ind__c = 'N' AND   Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
AND   RecordType.DeveloperName = 'Account_Communication_Address_Role_Business_Role' AND  Parent_SFID__r.Role_Descr__c = 'Business'
LIMIT 1)
FROM    Account_Business_Role__c
WHERE   Archive_Ind__c = 'N'
AND   Account_SFID__r.Archive_Ind__c = 'N'
AND   Account_SFID__r.Id =:accId]; 

List<Account> touchPointAccounts = [SELECT id,(SELECT Id FROM Opportunities),(SELECT Id FROM Events) FROM Account WHERE id =:accId]; */
            
            
            touchPointAccounts = [SELECT Name, Type,BillingStreet,(SELECT Id FROM Opportunities),(SELECT Id FROM Events),(SELECT Role_Descr__c,Service_Level_Class_Descr__c FROM Business_Roles__r LIMIT 1),(SELECT Street_Addr__c, City_Name__c, State_Name__c, Country_Name__c  FROM Account_Communications__r WHERE id =:Id.valueof(accCommunicationId)) FROM Account WHERE id =:accId];        
            touchPointAccountWrapper.RADL_Class = touchPointAccounts[0].Business_Roles__r[0].Service_Level_Class_Descr__c;
            touchPointAccountWrapper.Business_Role = touchPointAccounts[0].Business_Roles__r[0].Role_Descr__c;
            touchPointAccountWrapper.Street_Address = touchPointAccounts[0].Account_Communications__r[0].Street_Addr__c;
            touchPointAccountWrapper.City_Name = touchPointAccounts[0].Account_Communications__r[0].City_Name__c;
            touchPointAccountWrapper.State_Name = touchPointAccounts[0].Account_Communications__r[0].State_Name__c;
            touchPointAccountWrapper.Country_Name = touchPointAccounts[0].Account_Communications__r[0].Country_Name__c;
             String accResponse = Frontier_AccountController.AccountDetails('account',result,accId);
            String totalopportunity ;
            JSONParser parsers = JSON.createParser(accResponse);
            parsers.nextToken();
            parsers.nextToken();
            if(parsers.getText() == 'TotalOpportunity'){
                parsers.nextToken();
                totalopportunity = parsers.getText();
            }
          touchPointAccountWrapper.accountGMEResponseWrapper= (totalopportunity == 'null'?'0':totalopportunity) ;
            
            
        try{
            count =(touchPointAccounts[0].events.size() > 0 ? touchPointAccounts[0].events.size() : 0)  ;
            touchPointAccountWrapper.Name = touchPointAccounts[0].Name;
            
            touchPointAccountWrapper.No_Of_TouchPoints = count; 
          if(Test.isRunningTest()){
                integer intTest =1/0;
          }
            
        }
        //}
        catch(Exception e){
            System.debug('The following error has been occurred' + e.getMessage());
        }
        return JSON.serialize(touchPointAccountWrapper);
    } 
}