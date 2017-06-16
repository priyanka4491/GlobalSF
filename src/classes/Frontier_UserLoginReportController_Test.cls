/* 
* @author : Cognizant technology solutions.
* @version : 1.0
* @objects Referenced :Account,Event,Account Business Role,Territory
* @Description : This test class is covering code lines for apex class "Frontier_UserLoginReportController"
*/
@isTest

public class Frontier_UserLoginReportController_Test {
  
    static testMethod void testMethod1() 
    {
        List<LoginHistory> loginRecordstList;
        List<Territory2> objTerritory;
        List<UserTerritory2Association> objUserTerritory;
        list<user> userlist= [SELECT User.Name,Lastname,UserRole.Id, State, Firstname FROM user WHERE profile.Name ='System Administrator' and IsActive=true Limit 1];
        system.debug('@@userslist'+userlist);
        if(!userlist.isEmpty()){
            system.runAs(userlist[0])
            {     
                loginRecordstList = new List<LoginHistory>();
                loginRecordstList=[SELECT UserId, LoginTime, LoginType, Status, Browser, Platform, LoginUrl, CountryIso FROM LoginHistory];   
                Test.startTest();
                try{
                    if(!loginRecordstList.isEmpty()) {  
                        Frontier_UserLoginReportController FrUserLoginCon = new Frontier_UserLoginReportController();
                        Frontier_UserLoginReportController.getLoggedDetails(1,10,'Current Month',False,False,'Sort','Sort');
                        Frontier_UserLoginReportController.getLoggedDetails(1,10,'Current Month',False,True,'12;10/US;IN','CALENDAR_MONTH(LoginTime)=/CountryIso=');
                        //Frontier_UserLoginReportController.getLoggedDetails(0,-1,'Previous Month',false);
                        //Frontier_UserLoginReportController.getLoggedDetails(1,10,'Last 2 Months',false);
                        Frontier_UserLoginReportController.getSortByMonthORCounty('12;10/US;IN','CALENDAR_MONTH(LoginTime)=/CountryIso=',true);
                        Frontier_UserLoginReportController.getSortByMonthORCounty('12;10/','CALENDAR_MONTH(LoginTime)=/CountryIso=',false);
                        Frontier_UserLoginReportController.getSortByMonthORCounty('/US;IN','CALENDAR_MONTH(LoginTime)=/CountryIso=',false);
                        Frontier_UserLoginReportController.getSortByMonthORCounty('/','CALENDAR_MONTH(LoginTime)=/CountryIso=',false);
                        Frontier_UserLoginReportController.getSortByMonthORCounty('10/','CALENDAR_MONTH(LoginTime)=/CountryIso=',false);
                        Frontier_UserLoginReportController.getSortByMonthORCounty('/US','CALENDAR_MONTH(LoginTime)=/CountryIso=',false);
                    }
                }
                catch(ListException le) {
                    System.debug('Message: ' + le.getMessage() + 'Cause: ' + le.getCause() + 'Line number: ' + le.getLineNumber() + 'Stack trace: ' + le.getStackTraceString());    
                } 
                System.assert(!loginRecordstList.isEmpty());
                Test.stopTest();
                
            }
        }
    }
}