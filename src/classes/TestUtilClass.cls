/* ************************************************************************************************************
* Category             :   Apex Factory Class
* Name                 :   TestUtilClass
* Description          :   This is utility class for creating test data for the test class wherever required.
* Author               :   Cognizant Technology Solutions
* ************************************************************************************************************/
@isTest
public class TestUtilClass {
   Public static list<account> accts;
    Public static list<account> growerAccts;
    Public static list<Program__c> programList;
    public static List<Account_Program__c> accountProgramList;
    public static List<Product2> ProductList;
    public static List<Touchpoint__c> touchpointList;
    Public static List<Account_Business_Role__c> accBusiness;
    public static List<Account_Farming_Area__c> accCropFarmingArea;
    Public static list<Contact> contactList;
    Public static List<User> listUsers;
    Public static List<Territory2> territoryList;
    Public static List<Group> groupList;
    Public static List<LoginHistory> logHistory;
    public static List<Account_Farming_Area__c> accTotalFarmingArea;
    Public static List<User> listadminusers {get;set;}
    public static String adminProfile;
    //Create Test Records for Account
    public static List<Account> createTestAccount(Integer numAccts) {
        accts = new list<Account>();
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i, Archive_Ind__c = 'N',BillingLatitude=13.082680,BillingLongitude=80.270718,Account_Global_Party_ID__c='00001'+i);
            accts.add(a);
        }
        try{
            if(!accts.isEmpty()){
                insert accts; 
            }  
        }
        catch(DMLException e){
            System.debug('Exception Occured when createTestAccount'+e.getMessage());
        }     
        return accts;
    }  
    public static List<Account> createTestGrowerAccount(Integer numAccts) {
        growerAccts = new list<Account>();
        RecordType strRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account'
                                      AND DeveloperName = 'Account_Individual' LIMIT 1];
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i, Archive_Ind__c = 'N',BillingLatitude=13.082680,BillingLongitude=80.270718,
                                   Recordtypeid=strRecordTypeId.id,Dealer_SFID__c=accts[0].id,Account_Global_Party_ID__c='00002'+i);
            growerAccts.add(a);
        }
        try{
            if(!growerAccts.isEmpty()){
                insert growerAccts; 
            }  
        }
        catch(DMLException e){
            System.debug('Exception Occured when createTestAccount'+e.getMessage());
        }     
        return growerAccts;
    }  
    
    // Create Test records for Program
    public static List<Program__c> createTestProgram(Integer numPrograms) {
       programList = new List<Program__c>(); 
        RecordType strRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Program__c'
                                      AND DeveloperName = 'Program' LIMIT 1];
        for(Integer i=0;i<numPrograms;i++) {
            Program__c a = new Program__c(Name='TestProgram' + i,Account_Type__c=(i>2 ?'Dealer':'Grower'),Budget__c=100,
                                   Recordtypeid=strRecordTypeId.id);
            programList.add(a);
        }
        try{
            if(!programList.isEmpty()){
                insert programList; 
            }  
        }
        catch(DMLException e){
            System.debug('Exception Occured when createTestAccount'+e.getMessage());
        }     
        return programList;
    }
    // Create Test records for Account Sales
    public static List<Account_Sales__c> createTestAccountSales(Integer numaccSales) {
        List<Account_Sales__c> accSalesList = new List<Account_Sales__c>(); 
       // RecordType strRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Program__c'
                                      //AND DeveloperName = 'Program' LIMIT 1];
        List<Territory2> territoryList = new List<Territory2>();
        List<UserTerritory2Association> userTerritoryList = new List<UserTerritory2Association>();
        userTerritoryList = [SELECT Id, IsActive, RoleInTerritory2, Territory2Id, UserId FROM 
                             UserTerritory2Association WHERE UserId =: UserInfo.getUserId()];
        if(!userTerritoryList.isEmpty()){
            territoryList = [SELECT Id, Name, DeveloperName, Division__c FROM 
                             Territory2 WHERE Id =: userTerritoryList[0].Territory2Id];
        }
        for(Integer i=0;i<numaccSales;i++) {
            Account_Sales__c a = new Account_Sales__c(Name='TestAccountSales' + i,Account_SFID__c=accts[0].id,Account_Business_Role_SFID__c=accBusiness[i].id,
                                                     Brand_Name__c='Channel',Business_Unit_Descr__c=(i>=1?'National':'Regional'),Crop__c='Corn',
                                                     Net_Sales_Qty__c=100,Opportunity__c=150,Order_Qty__c=100,Selling_Season_Descr__c='SUMMER',
                                                     Unit_Of_Measure__c='Units',Year__c=(i<=2?'2017':(i<=4 && i>2?'2016':'2015')));
            accSalesList.add(a);
        }
        try{
            if(!accSalesList.isEmpty()){
                insert accSalesList; 
            }  
        }
        catch(DMLException e){
            System.debug('Exception Occured when createTestAccount'+e.getMessage());
        }     
        return accSalesList;
    }
    
   
    // Create business role for the respective account
   
    
    public static List<LoginHistory> createLoginHistory(List<User> users)
    {        
        return logHistory;
    }   
    
    
    //Create Test Records for Events
    public static List<Event> createTestEvent(Integer noOfEvents){ 
        List<Event> eventList = new List<Event>(); 
        // Add Events 
        for (Integer i=0;i<noOfEvents;i++){ 
            eventList.add(new Event(Description ='Test notes',Subject='Training',StartDateTime = DateTime.Now().addDays(-1), 
                                    WhatId = ((accts.size() == 4 && i <= 3 ? accts[i].Id:accts[0].Id)), 
                                    Type ='Phone Call',whoId = contactList[0].Id,ActivityDate = Date.Today().addDays(2),
                                    EndDateTime = DateTime.Now().addDays(5))); 
        } 
        try{
            if(!eventList.isEmpty()){        
                insert eventList;
            }
        }
        catch(Exception e){
            System.debug('Exception Occured when createTestEvent'+e.getMessage());
        }
        return eventList; 
    }
    //Create Test Records for Touchpoint
    public static List<Touchpoint__c> createTestTouchpoint(Integer noOftouchpoints){ 
        touchpointList = new List<Touchpoint__c>(); 
        // Add Events 
        for (Integer i=0;i<noOftouchpoints;i++){ 
            touchpointList.add(new Touchpoint__c(Name='TestTouchpoint'+i,Account_SFID__c=accts[0].id,Date__c=System.today(),TouchPoint_Status__c=(i<=1?'Scheduled':(i<=3?'Cancelled':'Completed')),TouchPointTypes__c='1:1 visit')); 
        } 
        try{
            if(!touchpointList.isEmpty()){        
                insert touchpointList;
            }
        }
        catch(Exception e){
            System.debug('Exception Occured when createTestEvent'+e.getMessage());
        }
        return touchpointList; 
    }
    //Create Test Records for Tasks
    public static List<Task> createTask(Integer noOfTask){ 
        List<Task> taskList = new List<Task>();         
        // Add Events 
        for (Integer i=0;i<noOfTask;i++){ 
            taskList.add(new Task(Description ='Test notes',Type ='Call',ActivityDate = Date.Today(),
                                  WhatId = ((accts.size() == 4 && i <= 3 ? accts[i].Id:accts[0].Id)),Status=touchpointList[i].Touchpoint_Status__c,Program_SFID__c=programList[0].id,TouchPoint_SFID__c=touchpointList[i].id));
        } 
        try{
            if(!taskList.isEmpty()){        
                insert taskList;
            }
        }
        catch(Exception e){
            System.debug('Exception Occured when createTask'+e.getMessage());
        }
        return taskList; 
    }
    //Create Test Records for Contact
    public static list<Contact> createContact(Integer numOfContacts){
        contactList = new list<Contact>();
        if(!accts.isEmpty()){
            for(Integer i=0;i<numOfContacts;i++) {
                Contact con = new Contact(FirstName='Test' + i,LastName='Contact'+i); 
                contactList.add(con);
            }
            try{
                if(!contactList.isEmpty()){
                    insert contactList; 
                }  
                System.debug('Contacts list ---' + contactList);
            }
            catch(DMLException e){
                System.debug('Exception Occured when creating Contact'+e.getMessage());
            } 
        }
        return contactList;
    }
   
              
    //Create Test Records for Account Contact
    public static list<Account_Contact__c> createAccountContact(Integer numOfAccountContacts){
       list<Account_Contact__c> AccountcontactList = new list<Account_Contact__c>();
        RecordType strRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account_Contact__c'
                                      AND DeveloperName = 'Account_Contact_Account_Contact_Relationship' LIMIT 1];
        if(!accts.isEmpty() && !contactList.isEmpty()){
            for(Integer i=0;i<numOfAccountContacts;i++) {
                Account_Contact__c con = new Account_Contact__c(Account_SFID__c=(i<=1?accts[0].id:growerAccts[0].id),
                                                             Contact_SFID__c=contactList[i].id,is_Primary_Contact__c=true,Status_Descr__c='Active',
                                                              Recordtypeid=strRecordTypeId.id); 
                AccountcontactList.add(con);
            }
            try{
                if(!AccountcontactList.isEmpty()){
                    insert AccountcontactList; 
                }  
                System.debug('Account Contacts list ---' + AccountcontactList);
            }
            catch(Exception e){
                System.debug('Exception Occured when creating Contact'+e.getMessage());
            } 
        }
        return AccountcontactList;
    }
    // Create Test Territory Records
    @future
    public static void CreateTestTerritory(Integer noofTerritory){        
        Territory2Model territoryModel = new Territory2Model();
        territoryModel .DeveloperName='ModelName'; // required field
        territoryModel.Name = 'Name'; // required field
        
        insert territoryModel ;   
        for (Integer i=0;i<noofTerritory;i++){ 
            territoryList.add(new Territory2(DeveloperName = 'TestTerritory',Territory2ModelId=territoryModel.Id, 
                                             Name='TestTerritory'));
        }     
        try{
            if(!territoryList.isEmpty()){        
                insert territoryList;                
            }
        }
        catch(Exception e){
            System.debug('Exception Occured when createTask'+e.getMessage());
        }      
        // return territoryList; 
    }
    // Create test records for the user territory
    @future
    public static void CreateUserTerritory2Association(Integer noofUserTerritory){       
        List<UserTerritory2Association> userTerritoryAssociationList = new List<UserTerritory2Association>();
        for (Integer i=0;i<noofUserTerritory;i++){ 
            userTerritoryAssociationList.add(new UserTerritory2Association(Territory2Id= territoryList[0].Id,
                                                                           UserId= listUsers[0].Id,RoleInTerritory2='Sales / Marketing Manager'));
        }    
        try{
            if(!userTerritoryAssociationList.isEmpty()){        
                insert userTerritoryAssociationList;
            }
        } 
        catch(Exception e){
            System.debug('Exception Occured when createTask'+e.getMessage());
        }    
        //return userTerritoryAssociationList; 
    }
    
    
    // Create account sharing records to provide sharing access to the account
    public static List<AccountShare> createAccountShare(){ 
        List<AccountShare> accountShares = new List<AccountShare>();
        //List<Group> grouplist=[Select Id, RelatedId from Group where Type='Territory'];
        if(accts.size()>0){
            for(Account acc : accts){
                AccountShare accountShare = new AccountShare();
                accountShare.AccountId = accts[0].Id;
                accountShare.UserOrGroupId = groupList[0].Id;
                accountShare.AccountAccessLevel = 'Edit';
                accountShare.ContactAccessLevel = 'Edit';
                accountShare.CaseAccessLevel = 'Edit';
                accountShare.OpportunityAccessLevel = 'Edit';
                accountShares.add(accountShare);
            }
        }
        try{
            if(!accountShares.isEmpty()){
                insert accountShares;
            }
        } 
        catch(Exception e){
            System.debug('Exception Occured when createTask'+e.getMessage());
        }
        return accountShares;
    }
    // create test users
    public static List<User> createTestUsers(String profileName,Integer noOfUser){
        adminProfile = profileName;
        String Country = 'en_US';
        String OrgID =Userinfo.getOrganizationId();    
        listUsers = new List<User>();       
        Profile admProfile = [select id,name from Profile where Name =: profileName];
        listadminusers = new List<User>();
        listadminusers = [Select Id, Name, ProfileId From User Where ProfileId =: admProfile.Id Limit 1];
        //User u1=[Select Id,Name from User where Id=:userInfo.getUserId()];
        
            //Create Test Records for List of users             
            for(integer i=0;i<noOfUser;i++){
                listUsers.add( new User(ProfileId = admProfile.id,isActive = True,FederationIdentifier = '199'+i+'7876'+i,
                                        LastName = 'Test1+i',FirstName='Test',Alias = 'test2',Email = 'admUser'+i+'@asdf.com',
                                        Username = 'admUser'+ OrgID + i +'@asdf.com',TimeZoneSidKey = 'GMT',LanguageLocaleKey = Country,EmailEncodingKey = 'UTF-8',LocaleSidKey = Country));
            }     
            try{
                if(!listUsers.isEmpty()){
                    insert listUsers;
                }
            }      
            catch(Exception e){
                System.debug('Error Message' + e.getMessage());
            }   
        
        return listUsers;
    }
    
    
    // Create test account communication records
    public static List<Account_Communication__c> createTestAccountCommunication(Integer numBusinessRolesperAccount){
        Profile admProfile = [select id,name from Profile where Name = 'System Administrator'];
        
                List<Account_Communication__c> accCommunication = new List<Account_Communication__c>();

        if(!listUsers.isEmpty() && adminProfile == 'System Administrator'){
            System.runAs(listUsers[0]){
        //Create Test Records for Account Communication
        // Add Account Communication
        RecordType strRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account_Communication__c'
                                      AND DeveloperName = 'Account_Communication_Address_Role_Business_Role' LIMIT 1];
        
        for (Integer i=0;i<numBusinessRolesperAccount;i++) {
            accCommunication.add(new Account_Communication__c(Street_Addr__c='701 RAILROAD HWY',City_Name__c='UNDERWOOD',
                                                              State_Name__c='IA',Country_Name__c='US',Archive_Ind__c = 'N',
                                                              Account_SFID__c=(i<=2?(accts.size() == 4 && i <= 3 ? accts[i].Id:accts[0].Id):(growerAccts.size() == 4 && i <= 3 ? growerAccts[i].Id:growerAccts[0].Id)),
                                                              Recordtypeid=strRecordTypeId.id));
        }
        // Insert Business Role for all test accounts
        try{
            if(!accCommunication.isEmpty()){        
                insert accCommunication;
            }
        }
        catch(Exception e){
            System.debug('Exception Occured when createTestAccountCommunication'+e.getMessage());
        }
        }
        }
        return accCommunication;
    }
    
     public static List<Account_Communication__c> createTestAccountCommunicationPhoneandEmail(Integer numBusinessRolesperAccount,String recordtypeName,String recordtypeNameParent,String recordtypeNameChild){
        Profile admProfile = [select id,name from Profile where Name = 'System Administrator'];
        
                List<Account_Communication__c> accCommunication = new List<Account_Communication__c>();
                List<Account_Communication__c> accCommunicationList = new List<Account_Communication__c>();
                List<Account_Communication__c> accCommunicationChildList = new List<Account_Communication__c>();



        if(!listUsers.isEmpty() && adminProfile == 'System Administrator'){
            System.runAs(listUsers[0]){
        //Create Test Records for Account Communication
        // Add Account Communication
        RecordType strRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account_Communication__c'
                                      AND DeveloperName =: recordtypeName LIMIT 1];
        
        for (Integer i=0;i<numBusinessRolesperAccount;i++) {
            accCommunication.add(new Account_Communication__c(Street_Addr__c='701 RAILROAD HWY',City_Name__c='UNDERWOOD',
                                                              State_Name__c='IA',Country_Name__c='US',Archive_Ind__c = 'N',Email_Addr__c='abc@gmail.com',
                                                              Account_SFID__c=(i<=2?(accts.size() == 4 && i <= 3 ? accts[i].Id:accts[0].Id):(growerAccts.size() == 4 && i <= 3 ? growerAccts[i].Id:growerAccts[0].Id)),
                                                              Recordtypeid=strRecordTypeId.id));
        }
        // Insert Business Role for all test accounts
        try{
            if(!accCommunication.isEmpty()){        
                insert accCommunication;
            }
        }
        catch(Exception e){
            System.debug('Exception Occured when createTestAccountCommunication'+e.getMessage());
        }
        RecordType strRecordTypeIdParent = [SELECT Id FROM RecordType WHERE SobjectType = 'Account_Communication__c'
                                      AND DeveloperName =: recordtypeNameParent LIMIT 1];
         for (Integer i=0;i<numBusinessRolesperAccount;i++) {
            accCommunicationList.add(new Account_Communication__c(Account_SFID__c=(i<=2?(accts.size() == 4 && i <= 3 ? accts[i].Id:accts[0].Id):(growerAccts.size() == 4 && i <= 3 ? growerAccts[i].Id:growerAccts[0].Id)),
                                                              Archive_Ind__c = 'N',Recordtypeid=strRecordTypeIdParent.id,Parent_SFID__c=accCommunication[0].id));
        }
               try{
            if(!accCommunicationList.isEmpty()){        
                insert accCommunicationList;
            }
        }
        catch(Exception e){
            System.debug('Exception Occured when createTestAccountCommunication'+e.getMessage());
        }
         RecordType strRecordTypeIdChild = [SELECT Id FROM RecordType WHERE SobjectType = 'Account_Communication__c'
                                      AND DeveloperName =: recordtypeNameChild LIMIT 1];
         for (Integer i=0;i<numBusinessRolesperAccount;i++) {
            accCommunicationChildList.add(new Account_Communication__c(Account_SFID__c=(i<=2?(accts.size() == 4 && i <= 3 ? accts[i].Id:accts[0].Id):(growerAccts.size() == 4 && i <= 3 ? growerAccts[i].Id:growerAccts[0].Id)),
                                                              Archive_Ind__c = 'N',Recordtypeid=strRecordTypeIdChild.id,Parent_SFID__c=accCommunicationList[0].id));
        }
                  try{
            if(!accCommunicationChildList.isEmpty()){        
                insert accCommunicationChildList;
            }
        }
        catch(Exception e){
            System.debug('Exception Occured when createTestAccountCommunication'+e.getMessage());
        }
        }
        }
        return accCommunicationChildList;
    }
    
     public static List<Account_Business_Role__c> createTestAccountRole(Integer numBusinessRolesperAccount){
         
        List<String> Radlclass = new List<String>{'Develop','Acquire','Retain','Light Touch'};
        //Profile admProfile = [select id,name from Profile where Name = 'System Administrator'];
        
            //Create Business Role for Account
        accBusiness = new List<Account_Business_Role__c>();  
          if(!listUsers.isEmpty() && adminProfile == 'System Administrator'){
            System.runAs(listUsers[0]){
        // Add Account Business Role
        for(Integer i=0;i<numBusinessRolesperAccount;i++) {
            Id accid = accts[i].Id;
            accBusiness.add(new Account_Business_Role__c(Service_Level_Class_Descr__c= (i >= 0 && i <= 2 ? Radlclass[i]:'Light Touch') ,
                                                         SAP_ID__c='0001022212'+i,Archive_Ind__c = 'N',Role_Descr__c=(i<=6 ? 'Partner':'Customer'),
                                                         Account_SFID__c=(i<=2?(i >= 0 && i <= 2 ? accts[i].Id:accts[0].Id):(i >= 0 && i <= 2 ? growerAccts[i].Id:growerAccts[0].Id))));
        }
        
        try{
            // Insert Business Role for all test accounts
            if(!accBusiness.isEmpty()){        
                insert accBusiness;
            }
        }
        catch(Exception e){
            System.debug('Exception Occured when createTestAccountRole '+e.getMessage());
        }}}
        return accBusiness;
    }
    // Create Test records for Account Program
    public static List<Account_Program__c> createTestAccountProgram(Integer numaccountPrograms) {
       accountProgramList = new List<Account_Program__c>();
        User currentUser = new User();
        currentUser  = [SELECT Id FROM User Where Id =:UserInfo.getUserId()]; 
        if(currentUser != null){
            System.runAs(currentUser){
        for(Integer i=0;i<numaccountPrograms;i++) {
            Account_Program__c a = new Account_Program__c(Account_SFID__c =(i<=2?accts[i].id:growerAccts[i].id),Program_SFID__c=programList[0].id,
                                                         Planning_Status__c = (i<=1?'Planned':'Post-Plan'),Execution_Status__c=(i<=1?'In Execution':(i<=3?'Not Started':(i<=5?'Cancelled':'Completed'))),Service_Level_Class_Descr__c=accBusiness[i].Service_Level_Class_Descr__c);
            accountProgramList.add(a);
        }
             
        try{
            if(!accountProgramList.isEmpty()){
                insert accountProgramList; 
            } 
           
        }
        catch(DMLException e){
            System.debug('Exception Occured when createTestAccount'+e.getMessage());
        }  
            }
        }
       
        return accountProgramList;
    }
     //create Test Records for Product
    public static List<Product2> createTestProduct(Integer numProducts) {
       ProductList = new List<Product2>();
       
        for(Integer i=0;i<numProducts;i++) {
            Product2 a = new Product2(ProductCode='TestProduct' + i,Name='Product'+i);
            ProductList.add(a);
        }
             
        try{
            if(!ProductList.isEmpty()){
                insert ProductList; 
            } 
           
        }
        catch(DMLException e){
            System.debug('Exception Occured when createTestAccount'+e.getMessage());
        }  
           
       
        return ProductList;
    }
    //create Test Records for Account Product
    public static List<AccountProduct__c> createTestAccountProduct(Integer numaccountProducts) {
      List<AccountProduct__c> accountProductList = new List<AccountProduct__c>();
        User currentUser = new User();
        currentUser  = [SELECT Id FROM User Where Id =:UserInfo.getUserId()]; 
        if(currentUser != null){
            System.runAs(currentUser){
        for(Integer i=0;i<numaccountProducts;i++) {
            AccountProduct__c a = new AccountProduct__c(Qty__c=2,Account_SFID__c =(i<=2?accts[0].id:growerAccts[i].id),Product_SFID__c=productList[i].id);
            accountProductList.add(a);
        }
             
        try{
            if(!accountProductList.isEmpty()){
                insert accountProductList; 
            } 
           
        }
        catch(DMLException e){
            System.debug('Exception Occured when createTestAccount'+e.getMessage());
        }  
            }
        }
       
        return accountProductList;
    }
    public static List<Account_Farming_Area__c> createTestTotalAccountFarmingArea(Integer numAccountFarmingArea){
       accTotalFarmingArea = new List<Account_Farming_Area__c>();  
        RecordType totoalRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account_Farming_Area__c'
                                      AND DeveloperName = 'Account_Farming_Area_Total_Farming_Area' LIMIT 1];
        if(!listUsers.isEmpty() && adminProfile == 'System Administrator'){
            System.runAs(listUsers[0]){
                for(Integer i=0;i<numAccountFarmingArea;i++) {
                    accTotalFarmingArea.add(new Account_Farming_Area__c(Name='MonsantoFarmingArea '+ i ,
                                                         Account_SFID__c=accts[0].Id,Recordtypeid=totoalRecordTypeId.id,
                                                            Inbound_Total_Farm_Area_Qty__c=10000,Total_Farming_Area_Qty__c=10000,
                                                             Inbound_Area_Use_UOM_Descr__c='Acre',
                                                             Year__c=(i==0?2017:(i==1?2016:2015)),Year_Type__c='Fiscal Year'
                                                            
                                                         ));
                    
                }  
                 try{
            if(accTotalFarmingArea.size() > 0){        
                insert accTotalFarmingArea;
            }
        }
        catch(Exception e){
            System.debug('Exception Occured '+e.getMessage());
        }
            }
        }
     return accTotalFarmingArea;
    }
    public static List<Account_Farming_Area__c> createTestCropAccountFarmingAreaInsert(Integer numAccountFarmingArea){
       accCropFarmingArea = new List<Account_Farming_Area__c>();  
        RecordType strRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account_Farming_Area__c'
                                      AND DeveloperName = 'Account_Farming_Area_Crop_Farming_Area' LIMIT 1];
        if(!listUsers.isEmpty() && adminProfile == 'System Administrator' && !accTotalFarmingArea.isEmpty()){
            System.runAs(listUsers[0]){
                for(Integer i=0;i<numAccountFarmingArea;i++) {
                    accCropFarmingArea.add(new Account_Farming_Area__c(Name='MonsantoFarmingArea '+ i ,
                                                         Account_SFID__c=(i<=1?accts[0].Id:growerAccts[0].id),Recordtypeid=strRecordTypeId.id,
                                                            Parent_SFID__c=(i<=2?accTotalFarmingArea[0].id:(i<=5?accTotalFarmingArea[1].id:accTotalFarmingArea[2].id)),Area_Usage_Descr__c=(i==0?'Corn':(i==1?'Soy':'Sorghum')),
                                                           Area_Qty__c=100 ,Inbound_Area_Qty__c=100,Inbound_Area_Use_UOM_Descr__c='Acre',
                                                             Year__c=(i<=1?2017:(i<=3?2016:2015)),Year_Type__c='Fiscal Year',
                                                            Selling_Season_Descr__c='SUMMER'    
                                                           
                                                         ));
                    
                }  
                 try{
            if(!accCropFarmingArea.isEmpty()){        
                insert accCropFarmingArea;
                
            }
            system.debug('============++++' +accCropFarmingArea);
                 }
        catch(Exception e){
            System.debug('Exception Occured '+e.getMessage());
        }
            }
        }
     return accCropFarmingArea;
    }
     public static List<Account_Farming_Area__c> createTestCropAccountFarmingArea(Integer numAccountFarmingArea){
       accCropFarmingArea = new List<Account_Farming_Area__c>();  
        RecordType strRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account_Farming_Area__c'
                                      AND DeveloperName = 'Account_Farming_Area_Crop_Farming_Area' LIMIT 1];
        if(!listUsers.isEmpty() && adminProfile == 'System Administrator' && !accTotalFarmingArea.isEmpty()){
            System.runAs(listUsers[0]){
                for(Integer i=0;i<numAccountFarmingArea;i++) {
                    accCropFarmingArea.add(new Account_Farming_Area__c(Name='MonsantoFarmingArea '+ i ,
                                                         Account_SFID__c=accts[0].Id,Recordtypeid=strRecordTypeId.id,
                                                            Parent_SFID__c=accTotalFarmingArea[0].id,Area_Usage_Descr__c=(i==0?'Corn':(i==1?'Soy':'Sorghum')),
                                                           Area_Qty__c=(i<=1?100:20000),Inbound_Area_Qty__c=(i>=4?20000:100),Selling_Season_Descr__c='SUMMER'        
                                                         ));
                    
                }  
                 try{
            if(!accCropFarmingArea.isEmpty()){        
                insert accCropFarmingArea;
                
            }
            system.debug('============++++' +accCropFarmingArea);
                 }
        catch(Exception e){
            System.debug('Exception Occured '+e.getMessage());
        }
            }
        }
     return accCropFarmingArea;
    }
  /*  public static List<Account_Sales__c> createTestSales(Integer numSales){
        List<Account_Sales__c> accSales = new List<Account_Sales__c>();
        if(!listUsers.isEmpty() && adminProfile == 'System Administrator' && !accTotalFarmingArea.isEmpty()){
            System.runAs(listUsers[0]){
                for(Integer i=0;i<numSales;i++) {
                    accSales.add(new Account_Sales__c(Name='MonsantoFarmingArea '+ i ,
                                                         Account_SFID__c=accts[0].Id,Brand_Name__c='Channel',Budget__c=100,
                                                         Crop__c='Corn',Net_Sales_Qty__c=100,Opportunity__c=150,
                                                          Order_Qty__c=200,Year__c=(i==0?'2017':(i==1?'2016':'2015'))
                                                         ));
                    
                }  
                 try{
            if(!accSales.isEmpty()){        
                insert accSales;
                
            }
            system.debug('============++++' +accSales);
                 }
        catch(Exception e){
            System.debug('Exception Occured '+e.getMessage());
        }
            }
        }
     return accSales;
    }*/
    
    public static List<User> createTestUsers(Integer userRequired, String ProfileRequired)
    {
        if(!listUsers.isEmpty() && adminProfile == 'System Administrator'){
            System.runAs(listUsers[0]){
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;                   
        for(Integer i=0;i<userRequired;i++) {
            User u = new User(ProfileId = [SELECT Id FROM Profile WHERE Name =: ProfileRequired].Id,
                              LastName = 'last',
                              Email = 'DeveloperMonsanto@monsanto.com',
                              Username = 'DeveloperMonsanto@monsanto.com' +i+ System.currentTimeMillis(),
                              CompanyName = 'TEST',
                              IsActive = True,
                              Title = 'title',
                              Alias = 'alias',
                              TimeZoneSidKey = 'America/Los_Angeles',
                              EmailEncodingKey = 'UTF-8',
                              LanguageLocaleKey = 'en_US',
                              LocaleSidKey = 'en_US',
                              UserRoleId = r.Id);
            listUsers.add(u);
        }           
        try{
            if(!listUsers.isEmpty()){
                insert listUsers; 
            }  
        }
        catch(DMLException e){
            System.debug('Exception Occured when createTestAccount'+e.getMessage());
        }}}
        return listUsers;
    }
    
    // Create test record with fake end point url
    public static void createEndPoint(){
        EndpointUrlSetting__c endPointUrl = new EndpointUrlSetting__c();
        endPointUrl.Name = 'callout:Frontier_Named_Credentials';
        endPointUrl.Authorization_Url__c = 'https://test.amp.monsanto.com/as/token.oauth2?client_id=Global-Sales-Portal&client_secret=Wa8otHw859LG4yLQxQLEkfpzlHAxw1uirDgdv0ov5NRd1VQYrMJcTnwuqJUhCtFM&grant_type=client_credentials';
        endPointUrl.Callback_Url__c = '//'+'frontier-dealer-radl-mvp/queries';
        insert endPointUrl;
    }
    // Create test record with the appropriate record type    
    public static void createRecordType(){
        Recordtypes__c recordtype = new Recordtypes__c();
        recordtype.Name = 'Event Touch Point';
        recordtype.Value__c = [select id from Recordtype where Developername='Event_Touch_Point' limit 1].id;
        insert recordtype;
    }
    public static void createEndPointCustomer360(){
        EndpointUrlSetting__c endPointUrl = new EndpointUrlSetting__c();
        endPointUrl.Name = 'Customer360Credentials';
        endPointUrl.Authorization_Url__c = 'https://api01-np.agro.services/customer360-identity-demo/v1/radl-parties?globalPartyIdentifier=1';
        endPointUrl.Auth_Token_URL__c = 'https://test.amp.monsanto.com/as/token.oauth2';
        endPointUrl.Client_Id__c='DATA-CUSTOMER360-SVC';
        endPointUrl.Client_Secret__c='OYatpgTO3P9jUtbnfmw9bNaelveZY7MjgnmXzuQwxMjmotyLc4';
        insert endPointUrl;
    }
    
    public static void createEndPointCompany360(){
        EndpointUrlSetting__c endPointUrl = new EndpointUrlSetting__c();
        endPointUrl.Name = 'Company360Credentials';
        endPointUrl.Authorization_Url__c = 'https://api01-np.agro.services/company360/0.0.1/commercial/net-sales-rc-grower';
        endPointUrl.Auth_Token_URL__c = 'https://test.amp.monsanto.com/as/token.oauth2';
        endPointUrl.Client_Id__c='Company360';
        endPointUrl.Client_Secret__c='boxb8iBJ6T8HkCmZzvgjQW4uLTMkdc9Is9Xi5PNOCFX6jT8ssbRTPs9HMRCLVvua';
        insert endPointUrl;
    } 
    public static void createtriggerControl(){
        TriggerControl__c triggerControl = new TriggerControl__c();
        triggerControl.Name='Trigger: FarmingAreaValidation';
        triggerControl.Execute_Trigger__c = true;
        insert triggerControl;
    } 
     public static void createCropRecordType(){
        Recordtypes__c recordtype = new Recordtypes__c();
        recordtype.Name = 'AccountFarmingAreaCropFarmingArea';
        recordtype.Value__c = [select id from Recordtype where Developername='Account_Farming_Area_Crop_Farming_Area' limit 1].id;
        insert recordtype;
    }
     public static void createTotalRecordType(){
        Recordtypes__c recordtype = new Recordtypes__c();
        recordtype.Name = 'AccountFarmingAreaTotalFarmingArea';
        recordtype.Value__c = [select id from Recordtype where Developername='Account_Farming_Area_Total_Farming_Area' limit 1].id;
        insert recordtype;
    }
    
}