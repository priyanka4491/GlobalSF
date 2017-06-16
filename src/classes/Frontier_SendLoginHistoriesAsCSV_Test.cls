@isTest
public class Frontier_SendLoginHistoriesAsCSV_Test {
    Public static Map<Id, User> usermap;
    Public static Set<String> countryIsoSet;    
    public static Map<Id, Territory2> territoryMap;
    public static set<Id> userIdset;
    public static testMethod void sendLoginHistoryAsCSV() 
    {
    	Integer noOfRecordsToSkip=(Integer.valueOf(1)-1)*Integer.valueOf(10);
        System.debug('Page Number'+1+'pageSize'+10);        
        Set<Id> accountIds = new Set<Id>();
        List<LoginHistory> loginRecordstList = new List<LoginHistory>();
        String userId = Userinfo.getUserId();
        usermap = new Map<Id, User>();
        countryIsoSet = new Set<String>();
        territoryMap = new Map<Id, Territory2>();        
        Map<Id, Set<Id>> territoryUserMap = new Map<Id, Set<Id>>();
        userIdset = new Set<Id>();
        List<LoginHistory> logRecords;
        Boolean MonthOrCountrySort;
        //Get ther user records
        for(User ref : [SELECT Id, User.Name,UserRole.Name,Lastname,UserRole.Id, User.State, Title, Firstname FROM User WHERE isActive = true
                         AND userRole.Name='Account Manager']){
                             System.debug('userdetails'+ref);
                             usermap.put(ref.Id,ref);
                             userIdset.add(ref.Id);
                         }        
        // Get the user territory records
        if(!usermap.isEmpty()){
            for(UserTerritory2Association UserTerritory : [SELECT Id, UserId, Territory2Id FROM UserTerritory2Association WHERE UserId =: usermap.keySet()]){
                if(!territoryUserMap.containsKey(UserTerritory.Territory2Id)){
                    territoryUserMap.put(UserTerritory.Territory2Id,new Set<Id>{UserTerritory.UserId});
                }
                else{
                    territoryUserMap.get(UserTerritory.Territory2Id).add(UserTerritory.UserId);
                }
            }
        }
        //Get the territory records owned by the user
        if(!territoryUserMap.isEmpty()){
            for(Territory2 territory : [SELECT id, name,ParentTerritory2.Name,Description FROM Territory2 WHERE Id IN :territoryUserMap.Keyset()]) {
                if(territoryUserMap.containsKey(territory.Id)){
                    for(Id userIdVal : territoryUserMap.get(territory.Id)){
                        territoryMap.put(userIdVal,territory);               
                    }
                }
            }
        }
        String queryString ='SELECT UserId, LoginTime, LoginType, Status, Browser, Platform, LoginUrl, CountryIso FROM LoginHistory WHERE UserId IN:userIdset';
        Frontier_SendLoginHistoriesAsCSV fslh = new Frontier_SendLoginHistoriesAsCSV(queryString,userIdset,'',territoryMap,userMap);           	        
        }    
}