/*****************************************************************************************
* @author : Cognizant technology solutions.
* @version : 1.0
* @objects Referenced :Account,Event
* @Description : This test class is used to cover the code of "Frontier_EventListController"
********************************************************************************************/
@isTest
public class Frontier_EventListController_Test {
    
    @testSetup
    static void setup(){
        TestUtilClass.createTestUsers('System Administrator',2);
        TestUtilClass.createTestAccount(4);
        TestUtilclass.createContact(4);
        TestUtilClass.createTestEvent(4);
        TestUtilClass.createTestAccountRole(4);
    }
    static testmethod void eventRecordManipulation() {
        
        
        String todayDate = String.valueof(Date.today().month());
        List<User> userLists = [SELECT Id FROM User];
        if(!userLists.isEmpty()){
            System.runAs(userLists[0]){
                list<Territory2> lstterritoryType   = [SELECT id,name,ParentTerritory2Id,ParentTerritory2.Name,Description FROM Territory2];
                Test.startTest();
                // Load the record upon component Initialization
                Frontier_EventListController.findActivities(1,10,null,true,false,true,'Call',todayDate,'Acquire',userLists[0].Id+';'+userLists[1].Id,lstterritoryType[0].Id+';'+lstterritoryType[1].Id);
                // Paginate to the next page without any filter
                Frontier_EventListController.findActivities(1,10,null,false,true,false,'Call',todayDate,'Acquire',userLists[0].Id,lstterritoryType[0].Id);
                // Order the event records based on the field which is triggered
                Frontier_EventListController.findActivities(1,10,'ActivityDate-DESC',false,false,true,'Call',todayDate,'Acquires','','');
                // Pass the triggered field to the next page for sorting
                Frontier_EventListController.findActivities(1,10,'ActivityDate-ASC',false,true,true,'Call',todayDate,'Acquire','','');
                Frontier_EventListController.findActivities(1,10,'Name-DESC',false,false,true,'Call',todayDate,'Acquires','','');
                // Pass the triggered field to the next page for sorting
                Frontier_EventListController.findActivities(1,10,'Name-ASC',false,true,true,'Call',todayDate,'Acquire','','');
                
                // Apply the filter under the views
                Frontier_EventListController.findActivities(1,10,null,false,false,false,'Call',todayDate,'Acquire','','');
                Frontier_EventListController.findActivities(1,10,null,false,true,false,'Call',todayDate,'Acquire','','');
                Frontier_EventListController.findActivities(1,10,'Type-ASC',false,false,true,'Call',todayDate,'Acquire','','');
                Frontier_EventListController.findActivities(1,10,'Type-DESC',false,true,true,'Call',todayDate,'Acquire','','');
                Frontier_EventListController.findActivities(1,10,'Team-DESC',false,false,true,'Call',todayDate,'Acquire','','');
                Frontier_EventListController.findActivities(1,10,'Team-ASC',false,true,true,'Call',todayDate,'Acquire','','');
                Frontier_EventListController.findActivities(1,10,'Service_Level_Class_Descr__c-DESC',false,false,true,'Call',todayDate,'Acquire','','');
                Frontier_EventListController.findActivities(1,10,'Service_Level_Class_Descr__c-ASC',false,true,true,'Call',todayDate,'Acquire','','');
                
                
                Test.stopTest();
            }
        } 
    }
    static testmethod void eventManipulation() {
        
        
        String todayDate = String.valueof(Date.today().month());
        List<User> userLists = [SELECT Id FROM User];
        if(!userLists.isEmpty()){
            System.runAs(userLists[0]){
                list<Territory2> lstterritoryType   = [SELECT id,name,ParentTerritory2Id,ParentTerritory2.Name,Description FROM Territory2];
                Test.startTest();
                Frontier_EventListController.findActivities(1,10,null,false,false,false,'Call',todayDate,'Acquire','','');
                Frontier_EventListController.findActivities(1,10,null,false,true,false,'Call',todayDate,'Acquire','','');
                Frontier_EventListController.findActivities(1,10,'CreatedBy.Name-ASC',false,false,false,'Call',todayDate,'Acquire','','');
                Frontier_EventListController.findActivities(1,10,'CreatedBy.Name-DESC',false,true,false,'Call',todayDate,'Acquire','','');
                
                Frontier_EventListController.findActivities(1,10,null,false,false,false,'Call',todayDate,'Acquire','','');
                Frontier_EventListController.findActivities(1,10,null,false,true,false,'Call',todayDate,'Acquire','','');
                Frontier_EventListController.findActivities(1,10,'What.Name-DESC',false,false,false,'Call',todayDate,'Acquire','','');
                Frontier_EventListController.findActivities(1,10,'What.Name-ASC',false,true,false,'Call',todayDate,'Acquire','','');
                Frontier_EventListController.findActivities(1,10,'Comment-ASC',false,true,true,'Call',todayDate,'Acquire','','');
                Frontier_EventListController.findActivities(1,10,'Comment-DESC',false,true,true,'Call',todayDate,'Acquire','','');
                
                
                Test.stopTest();
            }
        }
    }
}