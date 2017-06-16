/*************************************************************************************** 
* @author : Cognizant Technology Solutions.
* @version : 1.0
* @objects Referenced : Task
* @Description : To display the login history details. Provided the option to send email
to the sales rep with the login history records included as an attachment to the email
****************************************************************************************/
public without sharing class Frontier_UserLoginReportController {
    
    public static List<LoginHistory> logRecords;
    Public static Map<Id, User> usermap;
    public static Map<Id, Territory2> territoryMap;
    public static Set<String> countryIsoSet = new Set<String>();
    public static Set<Id> userIdset = new Set<Id>(); 
    
    public Frontier_UserLoginReportController(){
        logRecords = new List<LoginHistory>();
        usermap = new Map<Id, User>();
        territoryMap = new Map<Id, Territory2>();
        countryIsoSet = new Set<String>();
    }
    
    @AuraEnabled
    public static string getLoggedDetails(Integer pageNumber,Integer pageSize,String logviews,Boolean isExport,Boolean MonthOrCountrySort,String selectedMonthOrCountry,String selectedMonthOrCountryField){
        // Determine the page size
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
        System.debug('Page Number'+pageNumber+'pageSize'+pageSize);        
        Set<Id> accountIds = new Set<Id>();
        List<LoginHistory> loginRecordstList = new List<LoginHistory>();
        String userId = Userinfo.getUserId();
        usermap = new Map<Id, User>();
        countryIsoSet = new Set<String>();
        territoryMap = new Map<Id, Territory2>();        
        Map<Id, Set<Id>> territoryUserMap = new Map<Id, Set<Id>>();
        
        //Get ther user records
        for(User user : [SELECT User.Name,UserRole.Name,Lastname,UserRole.Id, User.State, Title, Firstname FROM User WHERE isactive = true
                         AND userRole.Name='Account Manager']){
                             usermap.put(user.Id,user);
                             userIdset.add(user.Id);
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
        if(!MonthOrCountrySort) {
            String queryString ='SELECT UserId, LoginTime, LoginType, Status, Browser, Platform, LoginUrl, CountryIso FROM LoginHistory WHERE UserId IN:userIdset';
            if(isExport){            
                Database.executeBatch(new Frontier_SendLoginHistoriesAsCSV(queryString,userIdSet,'',territoryMap,userMap));
                system.debug('TerritoryMap=>'+territoryMap.size());
            }
            try{
                logRecords  = Database.query(queryString); 
                if(Test.isRunningTest()){
                    integer intTest =1/0;
                    System.debug('Log Records'+logRecords.size());
                }
            }
            catch(Exception e){
                System.debug('Error Occurred:'+ e.getMessage());
            }
            System.debug(queryString + 'queryString');
            
        }else if(MonthOrCountrySort){
            getSortByMonthORCounty(selectedMonthOrCountry,selectedMonthOrCountryField,False);
        }
        String loginWrapList;
        if(!MonthOrCountrySort) {
            for(LoginHistory logHis : logRecords){
                if(logHis.CountryIso != Null){
                    countryIsoSet.add(logHis.CountryIso);
                }
            }
        }
        //Obtain the limited login history records for every page
        if(!logRecords.isEmpty()){
            for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < logRecords.size();i++){                
                loginRecordstList.add(logRecords[i]);
            }
            if(!loginRecordstList.isEmpty()){
                loginWrapList = loginRecordMapping(loginRecordstList,userMap,territoryMap,false);
            }
        }
        // Export the login history records
        
        system.debug('loginWrapList=>'+loginWrapList);
        return loginWrapList;
    }
    
    // Map the login records to the loginHistory Wrapper
    public static String loginRecordMapping(List<LoginHistory> loginRecordstList,Map<Id,User> usermaps,Map<Id, Territory2> territoryMaps,Boolean isExport){
        
        List<historyWrapper> loginHistories = new List<historyWrapper>();    
        for(LoginHistory log : loginRecordstList){
            historyWrapper loginWrap = new historyWrapper();
            if(!usermaps.isEmpty() && usermaps.containskey(log.UserId)) {
                loginWrap.UserName = usermaps.get(log.UserId).Name;
                loginWrap.State = (usermaps.get(log.UserId).State != Null?usermaps.get(log.UserId).State:'');
                loginWrap.UserRole = (usermaps.get(log.UserId).UserRole.Name != Null ? usermaps.get(log.UserId).UserRole.Name : '');
                loginWrap.UserTitle = (usermaps.get(log.UserId).Title != Null?usermaps.get(log.UserId).Title:'');
            }
            loginWrap.ParentTerritory = (!territoryMaps.isEmpty() && territoryMaps.containsKey(log.UserId)? territoryMaps.get(log.UserId).ParentTerritory2.Name : '');
            loginWrap.LoginTime = log.LoginTime;
            loginWrap.Month = Util.getMonth(log.LoginTime);
            loginWrap.LoginType = log.LoginType;
            loginWrap.Status = log.Status;
            loginWrap.Browser = log.Browser;
            loginWrap.Platform = log.Platform;
            loginWrap.LoginUrl = log.LoginUrl;
            loginWrap.CountryIso = log.CountryIso;
            loginWrap.Count =  (isExport?loginRecordstList.size():logRecords.size());
            if(!countryIsoSet.isEmpty()){
                loginWrap.countrySet= new List<String>(countryIsoSet); 
            }
            else{
                loginWrap.countrySet= new List<String>();
            }
            loginHistories.add(loginWrap);
            
        }
        
        if(loginHistories.isEmpty()){
            loginHistories = new List<historyWrapper>();
        }
        return JSON.serialize(loginHistories);
    }
    //Get Login History Records as CSV File and send email to the sales rep
    //@AuraEnabled 
    //@future
    /*public static void exportVisits(String loginHistoryList){
String generatedCSVFile = '';        
String fileRow = '';
string csvHeader='User Name,Title, State,Parent Territory,LoginTime,LoginMonth,LoginType,Status,Browser,Platform,LoginURL,CountryISO\n';
String plainTextBody = '';
plainTextBody += 'Hi '+Userinfo.getName()+',\n\n';
plainTextBody += 'Please find attachment for requested User Login Report . \n\n\n';
plainTextBody += 'Thanks , \n';
plainTextBody += 'Global Sales Portal , \n';
system.debug('loginHistoryList=>'+loginHistoryList);
List<historyWrapper> loginHistory = (List<historyWrapper>)System.JSON.deserialize(loginHistoryList, List<historyWrapper>.class);
for(historyWrapper loginHistoryWrap  : loginHistory){             
//if(Limits.getHeapSize() < 275000){
fileRow = '';
fileRow = fileRow + ','+loginHistoryWrap.UserName+','+loginHistoryWrap.UserTitle+','+loginHistoryWrap.State+ ','+loginHistoryWrap.ParentTerritory+ ','+loginHistoryWrap.LoginTime;
fileRow = fileRow + ','+loginHistoryWrap.Month+ ','+loginHistoryWrap.LoginType+ ','+loginHistoryWrap.Status+ ','+loginHistoryWrap.Browser;
fileRow = fileRow + ','+loginHistoryWrap.Platform+ ','+loginHistoryWrap.LoginUrl+ ','+loginHistoryWrap.CountryIso;            
fileRow = fileRow.replaceFirst(',','');
generatedCSVFile = generatedCSVFile + fileRow + '\n';
//}
//else{
//break;
//}
}
loginHistory = null;
generatedCSVFile = csvHeader + generatedCSVFile; 
String csvName = 'User Login History.csv';
String subject = 'User Login History';
List<String> toAddress = new List<String>{UserInfo.getUserEmail()};
Util.sendEmail(csvName,subject,toAddress,plainTextBody,generatedCSVFile);     
} */   
    
    public class historyWrapper{
        public Integer Count;
        public String UserName;
        public String UserRole;
        public String UserTitle;
        public String State;
        public DATETIME LoginTime;
        public String Month;
        public String LoginType;
        public String Status;
        Public String Browser;
        public String Platform;
        public String LoginUrl;
        public String CountryIso; 
        public String ParentTerritory;
        public List<String> countrySet;
        public historyWrapper(){            
        }
    }    
    
    @AuraEnabled
    public static string getSortByMonth(String MonthORCountry,String MonthORCountryField){
        String query ='';
        system.debug('Month=>'+MonthORCountry);
        system.debug('Month=>'+MonthORCountryField);
        String CalenderMonthORCountry;
        if(MonthORCountry != ''){
            if(!MonthORCountry.contains(';')){
                if(MonthORCountryField == 'CountryIso='){
                    MonthORCountry = '\''+MonthORCountry+'\'';
                }
                CalenderMonthORCountry= MonthORCountryField+MonthORCountry;
            }else{
                CalenderMonthORCountry='(';
                for(String mon :  MonthORCountry.split(';')){
                    if(MonthORCountryField == 'CountryIso='){
                        mon = '\''+mon+'\'';
                    }
                    if(CalenderMonthORCountry == '('){
                        CalenderMonthORCountry+= MonthORCountryField+mon;
                    }else{
                        CalenderMonthORCountry += ' OR '+MonthORCountryField+mon;
                    }
                }
                CalenderMonthORCountry += ')';
            }
        }
        return CalenderMonthORCountry; 
    }
    
    @AuraEnabled
    public static string getSortByMonthORCounty(String MonthORCountry,String MonthORCountryField,Boolean isExport){
        
        List<String> MonthORCountryList = new List<string>();
        List<String> MonthORCountryFieldList = new List<string>();
        List<LoginHistory> loginHistoryList = new List<LoginHistory>();
        
        String query = '';
        string sortingFields = '';
        Boolean sortEnabled = false;
        String log = getLoggedDetails(1,10,'Current Month',False,False,'Sort','Sort');
        
        
        if(MonthORCountry.contains('/') && MonthORCountryField.contains('/')){
            MonthORCountryList = MonthORCountry.split('/'); 
            MonthORCountryFieldList = MonthORCountryField.split('/');          
        }
        
        //both Month And Country Filter Empty
        if(MonthORCountryList.isEmpty() && MonthORCountryList.isEmpty()){
            query ='SELECT UserId, LoginTime, LoginType, Status, Browser, Platform, LoginUrl, CountryIso FROM LoginHistory WHERE UserId IN:userIdSet ORDER BY LoginTime';
            
        }else if(MonthORCountryList.size() == 2){//both month And Country 
            sortingFields = getSortByMonth(MonthORCountryList[0],MonthORCountryFieldList[0]);
            if(sortingFields != Null) {
                sortingFields += 'AND '+getSortByMonth(MonthORCountryList[1],MonthORCountryFieldList[1]);
            } else {
                sortingFields = getSortByMonth(MonthORCountryList[1],MonthORCountryFieldList[1]);
            }
            sortEnabled = true;
            
        }else if(MonthORCountryList[0] != ''){ //Only Month Sort
            sortingFields = getSortByMonth(MonthORCountryList[0],MonthORCountryFieldList[0]);
            sortEnabled = true;
            
        }else if(MonthORCountryList[1] != ''){//only Country Sort
            sortingFields = getSortByMonth(MonthORCountryList[1],MonthORCountryFieldList[1]);
            sortEnabled = true;
        }
        
        if(sortEnabled == true){
            query = 'SELECT UserId, LoginTime, LoginType, Status, Browser, Platform, LoginUrl, CountryIso FROM LoginHistory WHERE  '+sortingFields+' AND UserId IN:userIdSet';
        }
        if(isExport){            
            Database.executeBatch(new Frontier_SendLoginHistoriesAsCSV(query,userIdSet,sortingFields,territoryMap,userMap));
            System.debug('UserIdSet Size'+userIdSet.size()+'sortingFields'+sortingFields+'TerritoryMap'+territoryMap.size()+'User Map'+userMap.size());
        }
        system.debug('sortingFields =>'+sortingFields );
        logRecords = new List<LoginHistory>();
        logRecords = Database.query(query);
        Integer recordSize = logRecords.size()<15?logRecords.size():15;
        if(!logRecords.isEmpty()){
            for(Integer i = 0; i < recordSize;i++){                
                loginHistoryList.add(logRecords[i]);
            }
        }
        for(LoginHistory logHis : logRecords){
            if(logHis.CountryIso != Null){
                countryIsoSet.add(logHis.CountryIso);
            }
        }
        system.debug('countryIsoSet=>'+countryIsoSet);
        String MonthORCountrySortLoginHistoryRecords = loginRecordMapping(loginHistoryList,userMap,territoryMap,false);
        system.debug('MonthSortLoginHistoryRecords=>'+MonthORCountrySortLoginHistoryRecords );
        system.debug('loginHistoryList=>'+logRecords);
        return MonthORCountrySortLoginHistoryRecords ;
    }
    
}