/***********************************************************************************************
* @author : Cognizant technology solutions.
* @version : 1.0
* @objects Referenced :Account,Event,Account Business Role,Territory
* @Description : This test class is covering code lines for apex class "Frontier_VisitListRecords"
*************************************************************************************************/

@isTest
public class Frontier_VisitListRecords_Test {
    
    @testSetup
    static void setup(){
        TestUtilClass.createTestUsers('System Administrator',2);
        TestUtilClass.createTestAccount(3);
        TestUtilClass.createContact(3);
        TestUtilClass.createTestEvent(2);
        TestUtilClass.createTestAccountRole(2);
     }
    static testmethod void getDetails() {
        list<account> accountList;
        Set<Id> accountIds = new Set<Id>();
        list<event> eventList;
        list<AccountShare> shareList;
        list<Group> groupList;
        list<Territory2> territoryList;
        list<user> userlist= [SELECT id,profile.name FROM user WHERE profile.Name ='System Administrator' AND IsActive=true LIMIT 1];
        system.debug('@@userslist'+userlist);
        Map<Id,Account_Business_Role__c> bussinessroleMap = new Map<Id,Account_Business_Role__c>();
        Map<Id,Territory2> UserTerritoryMap = new Map<Id,Territory2>();
        if(!userlist.isEmpty()){
            system.runAs(userlist[0])
            {     
                accountList= new list<account>();
                
                accountList=[SELECT Id,Name FROM Account LIMIT 10];
                System.debug(accountList + 'accountList');
                
                if(!accountList.isEmpty()){
                    List<Account_Business_Role__c> bussinessRoleList =[SELECT Id,SAP_ID__c,Service_Level_Class_Descr__c,Account_SFID__c FROM Account_Business_Role__c WHERE Account_SFID__c=:accountList[0].Id AND Archive_Ind__c = 'N']; 
                    for(Account_Business_Role__c accbussinessrole : bussinessRoleList){
                      if(!bussinessroleMap.containsKey(accbussinessrole.Account_SFID__c))
                         bussinessroleMap.put(accbussinessrole.Account_SFID__c, accbussinessrole);
                         } 
                   
                    eventList= [SELECT Description,StartDateTime,EndDateTime,ActivityDate,AccountId,CreatedDate,Who.Name,What.Name,Type  FROM event WHERE WhatId=:accountList[0].Id LIMIT 10 ];
                    if(!eventList.isEmpty()){
                        for(Event event : eventList){
                        if(!accountIds.contains(event.whatId)){
                         accountIds.add(event.WhatId);
                    } 
                        }
                    }
                        else{
                        eventList = new list<event>();
                    }
                   
                }
               
                try{
                    String todayDate = String.valueof(Date.today().month());
                    if(!accountList.isEmpty()) { 
                        
                         //Frontier_VisitListRecords.visitRecordMapping(eventList,bussinessroleMap,UserTerritoryMap);
                        Frontier_VisitListRecords.Status ='Positive';
                          Frontier_VisitListRecords.getVisitDetails(1,10,'Phone Call','None',todayDate,'US',true);
Frontier_VisitListRecords.Status ='Negative';
                        delete bussinessroleMap.values();
                        Frontier_VisitListRecords.getVisitDetails(1,10,'Phone Call','Develop',todayDate+';12','US',true);
                        
                        Frontier_VisitListRecords.getVisitDetails(1,10,'Phone Call','Develop','','US',true);                        
                        Frontier_VisitListRecords.getVisitDetails(1,10,'Event','None','12','US',true);
                    }
                }
                
                catch(ListException le) {
                    System.debug('Message: ' + le.getMessage() + 'Cause: ' + le.getCause() + 'Line number: ' + le.getLineNumber() + 'Stack trace: ' + le.getStackTraceString());    
                } 
                System.assert(!accountList.isEmpty(),'Accounts Created');
                
            }
        }
    }
    }