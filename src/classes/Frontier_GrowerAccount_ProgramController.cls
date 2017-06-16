public without sharing class Frontier_GrowerAccount_ProgramController {
    public static String fieldToTrigger ='';
    public static Id currentUserId = UserInfo.getUserId();
    public static Frontier_SortDirection sortFields = new  Frontier_SortDirection();
    public static string triggerFields;
    
    @AuraEnabled
    public static void saveActivityComments(Id accountId, Id activityId, String activityComments)
        {
            Task activityTask = new Task();
            activityTask = [SELECT Id, WhatId, Description From Task Where Id =: activityId AND  WhatId =: accountId];
            activityTask.Description = activityComments;
            System.debug('updated activity'+activityTask);
            update activityTask;
        }

    @AuraEnabled
    public static List<String> getProgramList(String accId, Integer pageNumber,Integer pageSize,String triggeredField,Boolean isInitialize,Boolean isPageChange){
        fieldToTrigger = triggeredField;
        //Frontier_SortDirection sortFields = new  Frontier_SortDirection();
        List<Account_Program__c> listProgram = new List<Account_Program__c>();
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
        List<Account_Program__c> programListAfterSkip = new List<Account_Program__c>();
        List<String> programList = new List<String>();
        List<Program__c> pgmList= new List<Program__c>();
        if(!isInitialize){ 
            if(triggeredField != Null && sortFields.ProgramName == triggeredField){
                sortFields.ProgramName = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');  
            }else if(triggeredField != Null && sortFields.Planning == triggeredField){
                sortFields.Planning = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }else if(triggeredField != Null && sortFields.Execution == triggeredField){
                sortFields.Execution = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
        }else if(isInitialize){
            sortFields = new Frontier_SortDirection();               
        } 
        String query = 'SELECT Id, Submitted__c, Account_SFID__r.Id, Program_SFID__r.Id, Program_SFID__r.Name, Planning_Status__c, Execution_Status__c  FROM Account_Program__c WHERE createdById =:currentUserId AND Account_SFID__r.Id = :accId';
        if(triggeredField != Null){
            query = Util.getQuery(query,' ORDER BY ','CreatedDate  DESC',triggeredField); 
        }
        try{
        listProgram = Database.query(query);
        }
        catch(Exception e){
            System.debug('Error Occured on Account Program ==========>'+e.getMessage());
        }
        if(!listProgram.isEmpty()){
            for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < listProgram.size();i++){
                programListAfterSkip.add(listProgram[i]);
            }
        }
        programList.add((String.valueOf(listProgram.size())));
        programList.add((JSON.serialize(programListAfterSkip)));  
        programList.add(JSON.serialize(sortFields));
        return programList;
    }
    @AuraEnabled
    public static String getMyPrograms(Id programId){
        Id DealerId =null;
        String isAllDealer = 'false';
        String isMyPrograms = 'false';
        String response = Frontier_ProgramController.getMyPrograms(programId,DealerId,isAllDealer,isMyPrograms);
        return response;
    }
    
    @AuraEnabled    
    public static List<String> getProgramEvents(Id programId,Id accId,Integer pageSize,Integer pageNumber,String triggeredField,Boolean isInitialize,Boolean isPageChange) {
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
        List<Task> programEventListAfterSkip = new List<Task>();
        List<String> programEventList = new List<String>();
        List<Task> pgmEventList= new List<Task>();
        Set<Id> pgmActvySet = new  Set<Id>(); 
        Set<Id> taskIdSet = new Set<Id>();
        List<Task> touchStatusList = new List<Task>();
        List<Program_Activity__c > programActivityList  = new List<Program_Activity__c >();
        List<Program_Activity__c > programActivityListAfterSkip = new List<Program_Activity__c >();
         
        if(!isInitialize){            
            if(triggeredField != Null && sortFields.ProgramEventName == triggeredField){
                sortFields.ProgramEventName = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');  
            }
            else if(triggeredField != Null && sortFields.Status == triggeredField){
                sortFields.Status = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
            else if(triggeredField != Null && sortFields.EventActivityDate == triggeredField){
                sortFields.EventActivityDate = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
            else if(triggeredField != Null && sortFields.Phase == triggeredField){
                sortFields.Phase = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }            
        }         
        String query = 'SELECT Id,Subject,WhatId, TouchPoint_SFID__r.Date__c,Phase__c,Status,Program_SFID__r.Name,Program_Activity_SFID__c ,Program_Activity_SFID__r.Name,Program_SFID__c,Touchpoint_SFID__c FROM Task  WHERE Program_SFID__c =:programId AND WhatId =:accId AND createdById= :currentUserId';
        String progActivityQuery = 'SELECT Id,Name,Phase__c FROM Program_Activity__c  WHERE Program_SFID__c =:programId  AND Id NOT IN :pgmActvySet';
        if(triggeredField != Null){
            query = Util.getQuery(query,' ORDER BY ','CreatedDate  DESC',triggeredField); 
        }
        try{
            pgmEventList = Database.query(query);
        }
        catch(Exception e){
            System.debug('Error occured on getting the program activity====>'+e.getMessage());
        }
        if(!pgmEventList.isEmpty()){
            for(Task  tsk :pgmEventList){
                pgmActvySet.add(tsk.Program_Activity_SFID__c );
            }
        }
        try{
            programActivityList  = Database.query(progActivityQuery);
        }
        catch(Exception e){
            System.debug('Error occured on getting the program activity========>'+e.getMessage());
        }
        if(!pgmEventList.isEmpty()){
            for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < pgmEventList.size();i++){   
                programEventListAfterSkip.add(pgmEventList[i]);
            }
        }
        
        programEventList.add(String.valueOf(pgmEventList.size()));
        programEventList.add((JSON.serialize(programEventListAfterSkip)));  
        programEventList.add((JSON.serialize(sortFields)));
       
        return programEventList;      
    }
    
 @AuraEnabled
    public static List<String> getProgramAccounts (String programId, String growerFlag, String daccId, String pageSize,String pageNumber,String triggeredField,Boolean isInitialize,Boolean isPageChange,String accountTarget)
    {
                        system.debug('triggerFields start-----------'+triggeredField);

        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
        List<Account_Program__c> accProgramListAfterSkip = new List<Account_Program__c>();
        List<Account> groweracc = new List<Account>();
        Set<Id> growerIdSet = new Set<Id>();
        String query;
        List<String> accountProgramList = new List<String>();
        
        
       List<programDetailWrapper> accountProgramListWrapper = new List<programDetailWrapper>();
        Map<Id,List<String>> accountProductMap = new Map<Id,List<String>>();

        List<Account_Business_Role__c> accountRecordsList = new List<Account_Business_Role__c>();
        if(!isInitialize){            
            if(triggeredField != Null && sortFields.AccountsName == triggeredField){
                sortFields.AccountsName = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');  
            }
            else if(triggeredField != Null && sortFields.Execution == triggeredField){
                sortFields.Execution = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
            else if(triggeredField != Null && sortFields.Planning == triggeredField){
                sortFields.Planning = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
            else if(triggeredField != Null && sortFields.Location == triggeredField){
                sortFields.Location = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }  
            else if(triggeredField != Null && sortFields.AccountRADL == triggeredField){
                sortFields.AccountRADL = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            } 
            else if(triggeredField != Null && sortFields.ProductName == triggeredField){
                sortFields.ProductName = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }   
        } 
        else if(isInitialize){
                sortFields = new Frontier_SortDirection();               
            }
        triggerFields = triggeredField;

        List<Account_Program__c> listAccountPrograms = new List<Account_Program__c>(); 
        Id UserId =UserInfo.getUserId();
        if(growerFlag == 'grower'){
           groweracc = [ SELECT Id, Dealer_SFID__c FROM Account WHERE Dealer_SFID__c = :daccId];
            System.debug('groweracc' + groweracc); 
            for(Account grower : groweracc){
                growerIdSet.add(grower.Id);
            }
            query = 'SELECT Id, Name, Account_SFID__c, Submitted__c, Service_Level_Class_Descr__c, Account_SFID__r.Name, Account_SFID__r.BillingCity, Account_SFID__r.BillingState, Cancel_Reason__c, Execution_Status__c, Planning_Status__c, Program_SFID__c, Program_SFID__r.Name ,Program_SFID__r.Available__c, Program_SFID__r.Allocated__c, Program_SFID__r.Consumed__c,Program_SFID__r.CS_Growth__c, Program_SFID__r.Growth__c,Program_SFID__r.Volume_Growth__c, Program_SFID__r.Program_Coverage__c, CreatedDate FROM Account_Program__c WHERE Program_SFID__c =: programId AND Account_SFID__c IN :growerIdSet AND CreatedById =:currentUserId'; 
        }
        else if(growerFlag == 'growerfalse' || growerFlag == 'default'){
            query = 'SELECT Id, Name, Account_SFID__c, Submitted__c, Service_Level_Class_Descr__c, Account_SFID__r.Name, Account_SFID__r.BillingCity, Account_SFID__r.BillingState, Cancel_Reason__c, Execution_Status__c, Planning_Status__c, Program_SFID__c, Program_SFID__r.Name ,Program_SFID__r.Available__c, Program_SFID__r.Allocated__c, Program_SFID__r.Consumed__c,Program_SFID__r.CS_Growth__c, Program_SFID__r.Growth__c,Program_SFID__r.Volume_Growth__c, Program_SFID__r.Program_Coverage__c, CreatedDate FROM Account_Program__c WHERE Program_SFID__c =: programId AND CreatedById =:currentUserId';
        }
        
        
        
        try{
            listAccountPrograms = Database.query(query);
        }
        catch(Exception e){
            system.debug('Error Occured on getting the account programs. =========>'+e.getMessage());
        }
        
        if(!listAccountPrograms.isEmpty()){
            for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < listAccountPrograms.size();i++){   
                accProgramListAfterSkip.add(listAccountPrograms[i]);
            }
        }
        
        Set<Id> acctIdSet = new Set<Id>();
        for(Account_Program__c accProgram : accProgramListAfterSkip){
            acctIdSet.add(accProgram.Account_SFID__c);
        }
        List<AccountProduct__c> accountProductList  = new List<AccountProduct__c>();
        accountProductList = [SELECT Account_SFID__c,Account_SFID__r.Id,Charge_Type__c,Product_SFID__c,Product_SFID__r.Name,Qty__c FROM AccountProduct__c WHERE Account_SFID__c IN :acctIdSet AND CreatedById =:currentUserId];
        system.debug('accountProductList' +accountProductList);
        if(!accountProductList.isEmpty()){
            for(AccountProduct__c accProduct : accountProductList){
                if(!accountProductMap.containsKey(accProduct.Account_SFID__c)){
                    accountProductMap.put(accProduct.Account_SFID__c,new List<String>{accProduct.Product_SFID__r.Name});
                }
                else{
                   accountProductMap.get(accProduct.Account_SFID__c).add(accProduct.Product_SFID__r.Name); 
                }
            }
        }
       system.debug('accountProductMap'+accountProductMap);

        system.debug('accProgramListAfterSkip'+accProgramListAfterSkip);
        if(!accProgramListAfterSkip.isEmpty()){
        for(Account_Program__c accProgram : accProgramListAfterSkip){
             programDetailWrapper accountProgramWrapper = new programDetailWrapper();
             accountProgramWrapper.Id = accProgram.Account_SFID__c;
             accountProgramWrapper.AccountProgramId = accProgram.id;
             accountProgramWrapper.Name = accProgram.Account_SFID__r.Name;
             accountProgramWrapper.ProgramId = accProgram.Program_SFID__c;
             accountProgramWrapper.SubmittedFlag = accProgram.Submitted__c;
             accountProgramWrapper.ExecutionStatus = accProgram.Execution_Status__c;
             accountProgramWrapper.PlanningStatus = accProgram.Planning_Status__c;
             accountProgramWrapper.Location = accProgram.Account_SFID__r.BillingCity;
             accountProgramWrapper.RADL = accProgram.Service_Level_Class_Descr__c;
            //accountProgramWrapper.Count = (listAccountPrograms.size() > 0 ? listAccountPrograms.size(): 0);
            if(!accountProductMap.isEmpty() && accountProductMap.containsKey(accProgram.Account_SFID__c)){
                for(String prodName : accountProductMap.get(accProgram.Account_SFID__c)){
                if(accountProgramWrapper.ProductName == ''){
                    accountProgramWrapper.ProductName += prodName;
                }
                else{
                   accountProgramWrapper.ProductName += ','+ prodName;

                }
            }
            }
            else{
                accountProgramWrapper.ProductName = '';
            }
            system.debug('accountProgramWrapper' +accountProgramWrapper);
            accountProgramListWrapper.add(accountProgramWrapper);
  
        }
        }
        if(accountProgramListWrapper.isEmpty()){
            accountProgramListWrapper = new List<programDetailWrapper>();
        }
        if(triggeredField != Null){
            accountProgramListWrapper.sort();
            system.debug('accountProgramListWrapper Sort' +accountProgramListWrapper);

        }
        if(accountTarget != null){
            String accListQuery;
            String finalwhere ='';
            if(accountTarget == 'Dealer' || String.valueof(accountTarget).replaceAll( '\\s+', '') == 'Dealer-Dealer'){
                finalwhere = ' AND (Role_Descr__c = \'Partner\')';
            }
            else if(accountTarget == 'Grower' || accountTarget.contains('Grower')){
               finalwhere =  ' AND (Role_Descr__c=\'Customer\' AND Role_Category_Descr__c = \'Consumer\' AND Business_Unit_Descr__c = \'Customer\')';
            }
            
            System.debug('accountTarget' + accountTarget);
            System.debug('finalwhere' + finalwhere);
            if(finalwhere != ''){                
                accListQuery = 'SELECT Account_SFID__c,Account_SFID__r.Name,Service_Level_Class_Descr__c,'                                
                    +'Role_Descr__c,Business_Unit_Descr__c,' 
                    +'(SELECT Source_System_ID__c FROM Account_Identifiers__r LIMIT 1),'
                    +'(SELECT Parent_SFID__r.Parent_SFID__r.Id,Parent_SFID__r.Parent_SFID__r.Street_Addr__c,Parent_SFID__r.Parent_SFID__r.City_Name__c,'      
                    +'Parent_SFID__r.Parent_SFID__r.State_Name__c,Parent_SFID__r.Parent_SFID__r.Country_Name__c,'   
                    +'Parent_SFID__r.Role_Descr__c FROM Account_Communications__r' 
                    +' WHERE   Archive_Ind__c = \'N\' AND  Parent_SFID__r.Archive_Ind__c = \'N\' AND   Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = \'N\''
                    +' AND   RecordType.DeveloperName = \'Account_Communication_Address_Role_Business_Role\' AND  Parent_SFID__r.Role_Descr__c = \'Business\''
                    +' LIMIT 1)'
                    +' FROM  Account_Business_Role__c'
                    +' WHERE Account_SFID__c =: acctIdSet' 
                    +' AND   Archive_Ind__c = \'N\''
                    +' AND   Account_SFID__r.Archive_Ind__c = \'N\'' + finalwhere;                
                try{
                    System.debug('accListQuery' + accListQuery);
                    accountRecordsList = Database.query(accListQuery);
                    System.debug('accountRecordsList' + accountRecordsList);
                }
                catch(Exception e){
                    system.debug('Error Occured on getting the account communication detais. =========>'+e.getMessage());
                }  
            }          
        }
        accountProgramList.add((String.valueOf(listAccountPrograms.size())));
        accountProgramList.add((JSON.serialize(accountProgramListWrapper)));
        accountProgramList.add((JSON.serialize(accountRecordsList)));
        accountProgramList.add((JSON.serialize(sortFields)));
        accountProgramList.add((JSON.serialize(accountProductList)));
        return accountProgramList;        
    }
    
    @AuraEnabled
    public static String getAccountCommunicationDetails(String accId, String accComId){
        List<String> accountComDetails = new List<String>();
        List<Account> accDetails;
        List<Account_Communication__c> commDetails = new List<Account_Communication__c>();
        String query;
        
        if(accComId != null && accComId != ''){
            query = 'Select Account_SFID__r.Name,Street_Addr__c,City_Name__c,State_Name__c,Country_Name__c from Account_Communication__c where Id =:accComId';
            try{
                commDetails = Database.query(query);
            }
            catch(Exception e){
                System.debug('Error Occured on getting the account communication detais. =========>'+e.getMessage());
            }
        }

        
        try{
            accDetails = [Select Id, Name From Account where Id =: accId]; 
        }        
        catch(Exception e){
            System.debug('Error Occured on getting the account detais. =========>'+e.getMessage());
        }
        accountComDetails.add(JSON.serialize(accDetails));
		accountComDetails.add(JSON.serialize(commDetails));
        return JSON.serialize(accountComDetails);
    }
    
    
    @AuraEnabled
    public static String getProgramsTasksByTask(Id acctId, Id programId, Id taskId){    
        ProgramsTasksWrapper programData =  new ProgramsTasksWrapper();
        List<Account_Program__c> listProgram = new List<Account_Program__c>();
        Set<Id> programIds = new Set<Id>();
        
        String query = 'SELECT Id, Program_SFID__c, Submitted__c, Execution_Status__c, Program_SFID__r.Name, Program_SFID__r.Id FROM Account_Program__c WHERE Account_SFID__r.Id = :acctId AND CreatedById =:currentUserId';
        try{
        listProgram = Database.query(query);
        }
        catch(Exception e){
            System.debug('Error occured on getting Account_Program__c========>'+e.getMessage());
        }
        
        List<Task> taskList = new List<Task>();        
        taskList = [SELECT Id,Subject,Description,TouchPoint_SFID__r.Date__c,TouchPoint_SFID__c,Phase__c,Status,Program_SFID__r.Name,Program_SFID__r.Budget__C,
                    Program_SFID__c,Program_Activity_SFID__c,WhatId FROM Task  WHERE  WhatId =:acctId AND CreatedById =:currentUserId];
        if(!taskList.isEmpty()){
            for(Task task:taskList){
                if(task.Program_SFID__c != null){
                    if(!programData.activityMap.containskey(task.Program_SFID__c)) {                    
                        programData.activityMap.put(task.Program_SFID__c, new  List <SObject> { task }); 
                    }
                    else{                    
                        programData.activityMap.get(task.Program_SFID__c).add(task);  
                    }
                    
                }
            }
        }
        //programData.selectedName = selectedTaskName;
        programData.accountProgramList.addall(listProgram);
        return JSON.serialize(programData);    
    }
    
    @AuraEnabled
    public static String cloneTask(Id taskId){
        Task selectedTask = [SELECT Id,Subject,Description,Type,TouchPoint_SFID__r.Date__c,TouchPoint_SFID__c,Phase__c,Status,Program_SFID__r.Name,Program_SFID__r.Budget__C,
                    Program_SFID__c,Program_Activity_SFID__c,WhatId  FROM Task  WHERE  Id =:taskId];
        Task newTask = selectedTask.clone(false);
        newTask.Status = 'Not Scheduled';
        try{
            insert newTask;
        }
        catch(Exception e){
            System.debug('Error occured on clonning the task:' +e.getMessage());
        }
        if(newTask.Id == null){
           return null; 
        }        
        return JSON.serialize(newTask);
    }
    
    @AuraEnabled
    public static String addAccountProgram(String lookupaccountId, String ProgramId){ 
        
        Account_Program__c selectedAccountProgram = [SELECT Id, Name, Account_SFID__c, Submitted__c, Service_Level_Class_Descr__c, Account_SFID__r.Name, Account_SFID__r.BillingCity, Account_SFID__r.BillingState, Cancel_Reason__c, Execution_Status__c, Planning_Status__c, Program_SFID__c, Program_SFID__r.Name ,Program_SFID__r.Available__c, Program_SFID__r.Allocated__c, Program_SFID__r.Consumed__c,Program_SFID__r.CS_Growth__c, Program_SFID__r.Growth__c,Program_SFID__r.Volume_Growth__c, Program_SFID__r.Program_Coverage__c, CreatedDate FROM Account_Program__c WHERE Program_SFID__c =: ProgramId LIMIT 1];        
        Account_Program__c newAccountProgram = selectedAccountProgram.clone(false);
        newAccountProgram.Execution_Status__c='Not Started';
        newAccountProgram.Planning_Status__c='Planned';
        newAccountProgram.Account_SFID__c=lookupaccountId;
        try{
            insert newAccountProgram;
        }        
        catch(Exception e){
            System.debug('Error while inserting record in account Program:' +e.getMessage());
            return null;
        }
        
        if(newAccountProgram.Id == null){
            return null;
        }        
        if(newAccountProgram.Id != null){
            newAccountProgram.Execution_Status__c='Not Started';
            newAccountProgram.Planning_Status__c='Post-Plan';
            try{
                update newAccountProgram;
            }
            catch(Exception e){
                System.debug('Error occured while updating the account program record' + e.getMessage());
                return null;
            }
        }
        
        return JSON.serialize(newAccountProgram);
    }
    
    public class ProgramsTasksWrapper{
        public List<Account_Program__c> accountProgramList {get;set;}
        public Map<Id,List<Task>> activityMap {get;set;}
        //Public String selectedName{set; get;}
        Public ProgramsTasksWrapper(){
            accountProgramList = new List<Account_Program__c>();
            activityMap = new Map<Id,List<Task>>();
        }
    }
    
    @AuraEnabled    
    public static List<String> getProgramActivities(Id accountId,Integer pageSize,Integer pageNumber,String triggeredField,Boolean isInitialize,Boolean isPageChange) {
        Set<Id> programIds = new Set<Id>();        
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
        Set<Id> progIdSet = new Set<Id>();
        List<Task> programEventListAfterSkip = new List<Task>(); 
        List<String> programEventList = new List<String>();
        List<Task> pgmEventList= new List<Task>();
        List<Program_Activity__c > prgActivityList = new List<Program_Activity__c >();
        List<Program_Activity__c > programActivityListAfterSkip = new List<Program_Activity__c >();
        Set<Id> pgmActivitySet = new Set<Id>();
        for(Account_Program__c accountTouchPointPgm :[SELECT Account_SFID__c,Program_SFID__c, Submitted__c FROM Account_Program__c
                                                      WHERE Account_SFID__c=:accountId]){
                                                          programIds.add(accountTouchPointPgm.Program_SFID__c);
                                                      }
        for(Account_Program__c accPr : [SELECT id,Account_SFID__c,Program_SFID__c, Submitted__c FROM Account_Program__c WHERE Account_SFID__c =:accountId ]){
             progIdSet.add(accPr.Program_SFID__c);
        }
        String query = 'SELECT Id,Subject,TouchPoint_SFID__r.Date__c,Type,Phase__c,Status,Program_SFID__r.Name,Program_SFID__r.Id,Program_Activity_SFID__c  FROM Task  WHERE  WhatId =:accountId AND CreatedById =:currentUserId AND Program_SFID__c != null';
        
        if(!isInitialize){            
            if(triggeredField != Null && sortFields.ProgramEventName == triggeredField){
                sortFields.ProgramEventName = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');  
            }
            else if(triggeredField != Null && sortFields.TouchPointProgramName == triggeredField){
                sortFields.TouchPointProgramName = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
            else if(triggeredField != Null && sortFields.Status == triggeredField){
                sortFields.Status = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
            else if(triggeredField != Null && sortFields.EventActivityDate == triggeredField){
                sortFields.EventActivityDate = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
            else if(triggeredField != Null && sortFields.Phase == triggeredField){
                sortFields.Phase = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
             else if(triggeredField != Null && sortFields.Type == triggeredField){
                sortFields.Type = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
            }
        }
        if(triggeredField != Null){
            query = Util.getQuery(query,' ORDER BY ','CreatedDate  DESC',triggeredField); 
        }
        try{
        pgmEventList = Database.query(query);
        }
        catch(Exception e){
            system.debug('Error Occured ========>'+e.getMessage());
        }
        if(!pgmEventList.isEmpty()){
            for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < pgmEventList.size();i++){   
                programEventListAfterSkip.add(pgmEventList[i]);
            }
        }
       
        programEventList.add(String.valueOf(pgmEventList.size()));
        programEventList.add((JSON.serialize(programEventListAfterSkip)));  
        programEventList.add((JSON.serialize(sortFields)));
       
        return programEventList;
    }
    
    @AuraEnabled
    public static List<String> getAllTouchPoints(){
        String query;       
        List<Task> listTouchpoints = new List<Task>();
        Map<Id,List<Task>> touchpointMap = new Map<Id,List<Task>>();
        List<String> touchpointsList = new List<String>();
        
         query = 'SELECT Id, Subject, whatId, what.name, Program_SFID__c, Program_Activity_SFID__c, TouchPoint_SFID__c,TouchPoint_SFID__r.Name,TouchPoint_SFID__r.TouchPoint_Status__c,TouchPoint_SFID__r.TouchPointTypes__c,TouchPoint_SFID__r.Date__c FROM Task WHERE TouchPoint_SFID__c != NULL AND CreatedById =:currentUserId';
        try{
             listTouchpoints = Database.query(query);
        }
        catch(Exception e){
            System.debug('Exception occured on accessing the task ========='+e.getMessage());
        }

        if(!listTouchpoints.isEmpty()){
            for(Task task : listTouchpoints){
                if(touchpointMap.containskey(task.TouchPoint_SFID__c)) {
                    touchpointMap.get(task.TouchPoint_SFID__c).add(task);                
                } 
                else{
                    touchpointMap.put(task.TouchPoint_SFID__c,new List<Task>{task});
                }
            }
        }
        
        touchpointsList.add((JSON.serialize(touchpointMap))); 
        System.debug('touchpointsList' + touchpointsList);
        return touchpointsList;        
    }
      
     @AuraEnabled    
    public static List<String> getProgramActivityTouchpoints(Id accountId,String filterTask, Integer pageSize,Integer pageNumber) {
        String WHERECondition;
         List<Task> listTouchpoints = new List<Task>();
         Map<String,List<Task>> touchpointtListAfterSkip = new Map<String,List<Task>>();
        Map<Id,List<Task>> touchpointMap = new Map<Id,List<Task>>();
        List<String> touchpointsList = new List<String>(); 
        list<Id> touchPointIds =new List<Id>();
        
                Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);

        if(filterTask == 'Upcoming' ||filterTask == null ){
            WHERECondition = ' WHERE WhatId =:accountId'+' AND TouchPoint_SFID__r.Date__c >= today' +' AND TouchPoint_SFID__r.TouchPoint_Status__c = \'Scheduled\'';    
        }
        else if(filterTask == 'Previous'){
            WHERECondition = ' WHERE WhatId =:accountId'+' AND TouchPoint_SFID__r.Date__c <= today';
        }else if(filterTask == 'Cancelled'){
            WHERECondition = ' WHERE WhatId =:accountId'+' AND TouchPoint_SFID__r.TouchPoint_Status__c = \'Cancelled\'';
        }
        else if(filterTask == 'All'){
            WHERECondition = 'WHERE TouchPoint_SFID__c != NULL';
        }
        String query;
        query = 'SELECT Id, whatId, Program_SFID__c, Program_SFID__r.Name, Program_Activity_SFID__c, Program_Activity_SFID__r.Name, TouchPoint_SFID__c, TouchPoint_SFID__r.TouchPoint_Status__c,TouchPoint_SFID__r.TouchPointTypes__c,TouchPoint_SFID__r.Date__c'
            +' FROM Task'
            + WHERECondition +' AND CreatedById =:currentUserId ';
        try{
            listTouchpoints = Database.query(query);
        }catch(Exception e){
            System.debug('Error occured on getting task =============>'+e.getMessage());
        }
        if(!listTouchpoints.isEmpty()){
            for(Task task : listTouchpoints){
                if(touchpointMap.containskey(task.TouchPoint_SFID__c)) {
                   touchpointMap.get(task.TouchPoint_SFID__c).add(task);                    
                } 
                else{
                    touchpointMap.put(task.TouchPoint_SFID__c,new List<Task>{task});
                    touchPointIds.add(task.TouchPoint_SFID__c);
                }
            }
        }
        if(!touchPointIds.isEmpty()){
            for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < touchPointIds.size();i++){  
                    touchpointtListAfterSkip.put(touchPointIds[i],touchpointMap.get(touchPointIds[i]));            
            }
        }
        touchpointsList.add((String.valueOf(touchPointIds.size())));
        touchpointsList.add((JSON.serialize(touchpointtListAfterSkip))); 
        return touchpointsList;
    }
    
    @AuraEnabled
    public static String getProgramProfileDetails(){
        String responseResult;
        responseResult = Frontier_GetAccountFarmingDatas_CUS360.getGrowerAccFarmingDatas();
        if(responseResult != null){
            return responseResult;
        }
        return null;
    } 
  
    //Cancel Program and its realted Activities upon clicking on Cancel Program
    @AuraEnabled
    public static void getCancelPgm(String status , Id accPgmId, String reason){
        Account_Program__c cancelledProgram = new Account_Program__c();
        Set<Id> touchIdSet = new Set<Id>();
        Set<Id> touchcancelSet = new Set<Id>();
        List<Task> cancelActivities = new List<Task>();
        List<Task> updateActivitiesList = new List<Task>();
        List<Task> tasktouchList = new List<Task>();
        List<Task> updTskTouchnullList = new List<Task>();
        List<Touchpoint__c> updtouchcanclList = new List<Touchpoint__c>();
        List<Touchpoint__c> touchStatus = new List<Touchpoint__c>();
        List<Touchpoint__c> touchcancelList = new List<Touchpoint__c>();
        Map<Id,List<Id>> otherPgmTouch = new Map<Id,List<Id>>();
        Map<Id,Id> samePgmTouch = new Map<Id,Id>();
        Touchpoint__c updtouchpoint = new Touchpoint__c();
        List<Task> ProgramtaskList = new List<Task>();
        List<Task> canceltaskList = new List<Task>();
        Id AccountId = cancelledProgram.Account_SFID__c;
        Id ProgramId = cancelledProgram.Program_SFID__c;
         List<Touchpoint__c> canceltouchpointList = new List<Touchpoint__c>();
        
        Account_Program__c cancelProgramList = new Account_Program__c(Id= accPgmId,Execution_Status__c = status,Cancel_Reason__c = reason);    
        cancelledProgram = [SELECT  Account_SFID__c,Submitted__c, Program_SFID__c FROM Account_Program__c WHERE Id =:accPgmId];
         ProgramtaskList = [SELECT Id,TouchPoint_SFID__c FROM Task WHERE WhatId = :AccountId AND Program_SFID__c=:ProgramId];
         Set<Id> taskId = new Set<Id>();
         Set<Id> touchpointId = new Set<Id>();
         Set<Id> touchpointsetId = new Set<Id>();
         Touchpoint__c touchPoint;
           for(Task task :ProgramtaskList){
             taskId.add(task.id);
             touchpointId.add(task.TouchPoint_SFID__c);
            }
          List<Task> taskList = [SELECT Id,TouchPoint_SFID__c FROM Task WHERE Id !=:taskId AND TouchPoint_SFID__c =:touchpointId];
          if(!taskList.isEmpty()){
            for(Task task :taskList){
               touchpointsetId.add(task.TouchPoint_SFID__c);
            }
         }
        if(!ProgramtaskList.isEmpty()){
           for(Task task:ProgramtaskList){
            if(!taskList.isEmpty()){
              if(touchpointsetId.contains(task.TouchPoint_SFID__c)){
                 task.TouchPoint_SFID__c= null;
                }
           else{
                 touchPoint = new Touchpoint__c(id=task.TouchPoint_SFID__c,Touchpoint_Status__c='Cancelled');
                  canceltouchpointList.add(touchPoint);
             }
            }
           task.Status='Cancelled';
           canceltaskList.add(task);
            }
        }
        try{
            if(!canceltouchpointList.isEmpty()){
            update canceltouchpointList;
            }
           if(!canceltaskList.isEmpty()){
              update canceltaskList;
            }

            if(cancelProgramList !=null){
                update cancelProgramList; 
            }  
        }
        catch(Exception le){
            System.debug('Message: ' + le.getMessage() + 'Cause: ' + le.getCause() + 'Line number: ' + le.getLineNumber() + 'Stack trace: ' + le.getStackTraceString());    
        }        
    } 
    
    //Cancel Activity    
    @AuraEnabled
    public static void getCancelActy(Id accountId, Id programId, Id taskId){        
        Task cancelTask =  new Task();
        List<Task> cancelTaskList =  new List<Task>();
        Task taskupdate = new Task();
        Touchpoint__c touchpoint; 
        Set<Id> touchpointId = new Set<Id>();
        
        try{
        cancelTask = [SELECT Id, Status, TouchPoint_SFID__c,TouchPoint_SFID__r.TouchPoint_Status__c,WhatId,Program_SFID__c FROM Task WHERE WhatId = :accountId AND Program_SFID__r.Id = :programId AND Id= :taskId];
        }
        catch(Exception e){
            system.debug('Error occured on getting the task============>'+e.getMessage());
        }
        if(cancelTask.TouchPoint_SFID__c!= null){
          cancelTaskList = [SELECT Id,TouchPoint_SFID__c FROM Task WHERE TouchPoint_SFID__c=:cancelTask.TouchPoint_SFID__c AND Id != :cancelTask.Id];
            if(cancelTaskList.isEmpty()){
              touchpoint = new TouchPoint__c(Id=cancelTask.TouchPoint_SFID__c,TouchPoint_Status__c = 'Cancelled',Date__c=null);
              try{
                 update touchpoint;
              }
                catch(Exception e){
                    System.debug('Error occured while updating the touchpoint =======>'+e.getMessage());
                }
            }
            else{
               cancelTask.TouchPoint_SFID__c =null;
            }
        }
        
       if(cancelTask != null){                                 
                    cancelTask.Status = 'Cancelled';
       }
        try{             
           update cancelTask;
        }
        catch(Exception le){
            System.debug('Message: ' + le.getMessage() + 'Cause: ' + le.getCause() + 'Line number: ' + le.getLineNumber() + 'Stack trace: ' + le.getStackTraceString());
        }   
    }
     //Check Status of related Task and set program Complete
    @AuraEnabled
    public static String getCompletePgm(String status , Id accPgmId){
        Integer count = 0;
        Integer checkStatus = 0;
        String popupFlag;
        Set<String> statusSet = new Set<String>();
        Set<String> statusvalSet = new Set<String>{'In Progress','Not Scheduled','Scheduled'};
        Account_Program__c completeProgramList;
        Account_Program__c completeProgram = new Account_Program__c();
        List<Task> checkCompleteActvtyList = new List<Task>();
        List<Task> updateActivitiesList = new List<Task>();
        
        completeProgram = [SELECT  Account_SFID__c, Program_SFID__c, Submitted__c FROM Account_Program__c WHERE Id =:accPgmId];
        Id AccountId = completeProgram.Account_SFID__c;
        Id ProgramId = completeProgram.Program_SFID__c;
        System.debug('AccountId=============>' + AccountId + 'ProgramId==========>' + ProgramId);
        String query = 'SELECT Id, Status FROM Task WHERE WhatId =:AccountId AND Program_SFID__c = :ProgramId';
        try{
        checkCompleteActvtyList  = Database.query(query);
        }
        catch(Exception e){
            System.debug('Error occured on getting the the task ==>'+e.getMessage());
        }
        if(!checkCompleteActvtyList.isEmpty()){
        for(Task checkTask : checkCompleteActvtyList){
            statusSet.add(checkTask.Status);
            if(checkTask.Status == 'Cancelled'){
               count+= 1;
            }
            else{
               checkStatus+= 1; 
            }
            }
        }
        if(count == checkCompleteActvtyList.Size()){
                popupFlag = 'Not Allow';
            }
        else if(statusSet.contains('Not Scheduled') || statusSet.contains('In Progress') ||statusSet.contains('Scheduled')){
               popupFlag = 'Not Allow';
        }
        else{
                popupFlag = 'Allow';
                completeProgramList = new Account_Program__c(Id= accPgmId,Execution_Status__c = status);
        }                      
        try{
            if(completeProgramList != null){
                update completeProgramList;
            }
        }
        catch(Exception le){
            System.debug('Message: ' + le.getMessage() + 'Cause: ' + le.getCause() + 'Line number: ' + le.getLineNumber() + 'Stack trace: ' + le.getStackTraceString());    
        }

        return popupFlag;        
    } 
    
   @AuraEnabled
    public static String getNewAndUpdateTouchPointDetails(String seletedProgActivityId,Id accId,String selectedProgramIds,String touchPointId){
        GrowerProgramWrapper programdata = new GrowerProgramWrapper();
        List<Account_Program__c> listProgram = new List<Account_Program__c>();
        List<Task> taskList =new List<Task>();
        List<Account> accList =new List<Account>();
        List<Program__c> nonProgramActivityList = new List<Program__c>();
        List<UserRecordAccess> lstUserRecordAccess = new List<UserRecordAccess>();

        Set<Id> allAccountAssociatedProgramSet = new Set<Id>();
        Set<Id> programIdSet = new Set<Id>();
        Set<Id> selectedpgmActivityIdSet = new Set<Id>();
        Set<Id> nonScheduledActivityIdSet = new Set<Id>();
        Set<Id> pgmActivityIdSet = new Set<Id>();
        Set<Id> nonpgmActivityIdSet = new Set<Id>();
        Set<Id> scheduledNonPrgActivitySet = new Set<Id>();
        Set<Id> nonProgramIdSet = new Set<Id>(); 
        
        List<Contact_Communication__c> contactEmail = new List<Contact_Communication__c>();
        List<Contact_Communication__c> contactPhone = new List<Contact_Communication__c>();
        List<Contact_Communication__c> contactAddress = new List<Contact_Communication__c>();
        
        Contact accontact = new Contact(); 
        Account selectedAccount = new Account();

        Map<Id,List<Task>> selectedProgramIdAndTaskListMap = new Map<Id,List<Task>>();
        
        selectedAccount = [Select Id,Name FROM Account WHERE id = :accId];
        
        
         if(selectedProgramIds != ''){
             if(selectedProgramIds.contains(',')){
                for(String prgId : selectedProgramIds.split(',')){
                    programIdSet.add(prgId);
                }
             } else{
                   programIdSet.add(selectedProgramIds);
             }
        }   
        if(seletedProgActivityId != ''){
            if(seletedProgActivityId.contains(',')){
                for(String prgActyId : seletedProgActivityId.split(',')){
                    selectedpgmActivityIdSet.add(prgActyId);
                }
            }else{
                selectedpgmActivityIdSet.add(seletedProgActivityId);
            }
        }
        
        if(touchPointId != 'null'){
            programIdSet.clear();
            selectedpgmActivityIdSet.clear();
            for(Task tsks : [SELECT Id,Subject,Program_SFID__c,Program_Activity_SFID__c ,TouchPoint_SFID__r.TouchPoint_Status__c FROM Task WHERE TouchPoint_SFID__c = :touchPointId AND WhatId = :accId AND CreatedById =:currentUserId]){
               programIdSet.add(tsks.Program_SFID__c);
               selectedpgmActivityIdSet.add(tsks.Program_Activity_SFID__c );
               programdata.touchPointStatus  = tsks.TouchPoint_SFID__r.TouchPoint_Status__c;               
            }        
        }
        for(Task tsks : [SELECT Id,Subject,Program_SFID__c,Program_Activity_SFID__c  FROM Task WHERE Status = 'Not Scheduled' AND Program_SFID__c !=Null AND Program_Activity_SFID__c  != NULL AND WhatId = :accId AND CreatedById =:currentUserId]){
           nonScheduledActivityIdSet.add(tsks.Program_Activity_SFID__c );
        }       
        
        for(Account_Program__c accountTouchPointPgm :[SELECT Account_SFID__c,Submitted__c, Program_SFID__c FROM Account_Program__c
                                                      WHERE Account_SFID__c =:accId AND CreatedById =:currentUserId]){
                                                          allAccountAssociatedProgramSet.add(accountTouchPointPgm.Program_SFID__c);
                                                      }
        
        RecordType recType = [SELECT id FROM RecordType WHERE DeveloperName='Non_Program_Activities' AND SobjectType='Program_Activity__c'];
        RecordType nonProgramRecordType = [SELECT id FROM RecordType WHERE DeveloperName='Non_Program' AND SobjectType='Program__c'];
        
        for(Program_Activity__c  prgActivity : [SELECT Id,Name,Program_SFID__c,Activity_Type__c FROM Program_Activity__c  WHERE RecordTypeId = :recType.id AND Program_SFID__c IN :programIdSet]){
            programdata.nonProgramActivitiyList.add(prgActivity);
            programdata.activityType = prgActivity.Activity_Type__c;
        }
        for(Program_Activity__c  pgActivity : [SELECT Id,Name,Program_SFID__c,Activity_Type__c FROM Program_Activity__c  WHERE Id IN :selectedpgmActivityIdSet AND RecordTypeId = :recType.id]){
            programdata.selectedNonProgramActivityList.add(pgActivity);
            programdata.activityType = pgActivity.Activity_Type__c;

        }
        for(Program__c pgm : [SELECT Id,Name FROM Program__c WHERE Id IN :programIdSet AND RecordTypeId = :nonProgramRecordType.id]){
            programdata.selectedNonProgramList.add(pgm);
        }
        
        for(Program__c pgm : [SELECT Id,Name FROM Program__c WHERE RecordTypeId = :nonProgramRecordType.id ]){
            programdata.nonProgramsList.add(pgm);
            nonProgramIdSet.add(pgm.Id);

        }
        
        for(Task tsk :[SELECT Id,Program_Activity_SFID__c,Program_SFID__c FROM Task WHERE Program_SFID__c IN :nonProgramIdSet AND WhatId = :accId AND CreatedById =:currentUserId]){
            scheduledNonPrgActivitySet.add(tsk.Program_Activity_SFID__c);
        }
        
        String Recordtype ='Account_Communication_Address';
        try{
        listProgram = [SELECT Id,  Account_SFID__r.Id,Submitted__c, Account_SFID__r.Name, Program_SFID__c, Program_SFID__r.Name FROM Account_Program__c WHERE Account_SFID__r.Id = :accId AND Program_SFID__r.RecordTypeId != :nonProgramRecordType.id AND CreatedById =:currentUserId];
        }
        catch(Exception e){
            system.debug('Exception occured =======>'+e.getMessage());
        }
      
        
        //List<Account_Communication__c> accCommunication = [SELECT Account_SFID__r.Name,Street_Addr__c, City_Name__c, State_Name__c, Country_Name__c  FROM Account_Communication__c WHERE RecordType.DeveloperName='Account_Communication_Address' AND Account_SFID__c =:accId];
          List<Account_Communication__c> accCommunication = [SELECT Account_SFID__r.Name,Parent_SFID__r.Parent_SFID__r.Id,Parent_SFID__r.Parent_SFID__r.Street_Addr__c,Parent_SFID__r.Parent_SFID__r.City_Name__c,      
                                                                Parent_SFID__r.Parent_SFID__r.State_Name__c,Parent_SFID__r.Parent_SFID__r.Country_Name__c,   
                                                                Parent_SFID__r.Role_Descr__c FROM Account_Communication__c
                                                                WHERE   Archive_Ind__c = 'N' AND  Parent_SFID__r.Archive_Ind__c = 'N' AND   Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                                                                AND   RecordType.DeveloperName = 'Account_Communication_Address_Role_Business_Role' AND  Parent_SFID__r.Role_Descr__c = 'Business' AND Account_SFID__c =:accId];
         
         
        List<Account_Contact__c> accContact = [SELECT Id, Account_SFID__c, Contact_SFID__c, is_Primary_Contact__c, Role_Descr__c 
                                               FROM Account_Contact__c WHERE Account_SFID__c =: accId AND Contact_SFID__c != null];
        
        if(!accContact.isEmpty()){
            system.debug('accContact[0].Contact_SFID__c =>'+accContact[0].Contact_SFID__c);
            
            //Giving read access to the current SaleRep Manually
            
            lstUserRecordAccess = [SELECT RecordId,MaxAccessLevel,HasAllAccess, 
                                       HasDeleteAccess, 
                                       HasEditAccess,
                                       HasReadAccess, 
                                       HasTransferAccess 
                                       FROM UserRecordAccess 
                                       WHERE UserId =: UserInfo.getUserId()
                                       AND RecordId =: accContact[0].Contact_SFID__c];
            
            
            ContactShare contactRecordShare = new ContactShare();
            if(lstUserRecordAccess[0].HasReadAccess == False)
            {
                contactRecordShare.ContactId = accContact[0].Contact_SFID__c;
                contactRecordShare.UserOrGroupId = UserInfo.getUserId();
                contactRecordShare.ContactAccessLevel = 'Read';
                contactRecordShare.RowCause = Schema.ContactShare.RowCause.Manual;
                insert contactRecordShare;    
            }
            
            // grab grower account contact details
            accontact = [SELECT Id,Account.Name,FirstName, LastName, Name, MobilePhone, Email, MailingStreet, MailingCity, MailingState,
                                 MailingCountry FROM Contact WHERE Id = : accContact[0].Contact_SFID__c];
             
            programdata.contactList.add(accontact); 
            
            
            
            contactEmail= [SELECT Id, Account_Business_Role_SFID__c, Archive_Date__c, Archive_Ind__c, City_Name__c, Contact_SFID__c,
                                                        Country_Name__c, has_Do_Not_Call_Ind__c, has_Do_Not_Email_Ind__c, Email_Addr__c, Phone_Extension_Number__c, 
                                                        is_Fax__c, Geocode__c, HC_Integration_Key__c, is_Mobile_Phone__c, Parent_SFID__c, Parent_SFID__r.Parent_SFID__r.Email_Addr__c ,Parent_SFID__r.Parent_SFID__r.Phone_Number__c, Phone_Number__c, Postal_Code__c,
                                                        is_Primary_Communication__c, Parent_SFID__r.Archive_Ind__c, Parent_SFID__r.Parent_SFID__r.Archive_Ind__c, Role_Descr__c, State_Name__c, Street_Addr__c, is_Voice_Phone__c
                                                        From Contact_Communication__c 
                                                        WHERE   RecordType.DeveloperName = 'Contact_Communication_Email_Role_Business_Role'
                                                        AND Archive_Ind__c = 'N'AND Parent_SFID__r.Archive_Ind__c = 'N' 
                                                        AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N' AND Contact_SFID__c =: accontact.Id];
                
            contactPhone= [SELECT Id, Account_Business_Role_SFID__c, Archive_Date__c, Archive_Ind__c, City_Name__c, Contact_SFID__c,
                                                    Country_Name__c, has_Do_Not_Call_Ind__c, has_Do_Not_Email_Ind__c, Email_Addr__c, Phone_Extension_Number__c, 
                                                    is_Fax__c, Geocode__c, HC_Integration_Key__c, is_Mobile_Phone__c, Parent_SFID__c,Parent_SFID__r.Parent_SFID__r.Email_Addr__c ,Parent_SFID__r.Parent_SFID__r.Phone_Number__c,Phone_Number__c, Postal_Code__c,
                                                    is_Primary_Communication__c,  Role_Descr__c, State_Name__c, Street_Addr__c, is_Voice_Phone__c
                                                    From Contact_Communication__c 
                                                    WHERE   RecordType.DeveloperName = 'Contact_Communication_Phone_Role_Business_Role'
                                                    AND Archive_Ind__c = 'N'
                                                    AND Parent_SFID__r.Archive_Ind__c = 'N' 
                                                    AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                                                    AND Contact_SFID__c =: accontact.Id];
            
            contactAddress= [SELECT Id, Account_Business_Role_SFID__c, Archive_Date__c, Archive_Ind__c, City_Name__c, Contact_SFID__c,
                                                      Country_Name__c, has_Do_Not_Call_Ind__c, has_Do_Not_Email_Ind__c, Email_Addr__c, Phone_Extension_Number__c, 
                                                      is_Fax__c, Geocode__c, HC_Integration_Key__c, is_Mobile_Phone__c, Parent_SFID__c, Parent_SFID__r.Email_Addr__c ,Parent_SFID__r.Phone_Number__c, Phone_Number__c, Postal_Code__c,
                                                      is_Primary_Communication__c, Role_Descr__c, State_Name__c, Street_Addr__c, is_Voice_Phone__c,
                                                      Parent_SFID__r.Parent_SFID__r.Street_Addr__c,Parent_SFID__r.Parent_SFID__r.City_Name__c,
                                                      Parent_SFID__r.Parent_SFID__r.State_Name__c,Parent_SFID__r.Parent_SFID__r.Country_Name__c
                                                      FROM Contact_Communication__c 
                                                      WHERE   RecordType.DeveloperName = 'Contact_Communication_Address_Role_Business_Role'
                                                      AND Archive_Ind__c = 'N'
                                                      AND Parent_SFID__r.Archive_Ind__c = 'N' 
                                                      AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                                                      AND Contact_SFID__c =: accontact.Id];
                                                      
        }
        
        //Adding Not-Scheduled Program Activity for Program
        for(Program_Activity__c  task:[SELECT Id,Name,Program_SFID__c,Activity_Type__c FROM Program_Activity__c  WHERE Program_SFID__c != NULL AND Id IN :nonScheduledActivityIdSet]){
                if(!programdata.activityMap.containskey(task.Program_SFID__c)) {
                    programdata.activityMap.put(task.Program_SFID__c, new  List <Program_Activity__c > { task }); 
                }
                else{
                    programdata.activityMap.get(task.Program_SFID__c).add(task);  
                }
        }
       //Adding Not-Scheduled Program Activity for Non-Program
       for(Program_Activity__c  task:[SELECT Id,Name,Program_SFID__c,Activity_Type__c FROM Program_Activity__c  WHERE Program_SFID__c IN  :nonProgramIdSet]){
                if(!scheduledNonPrgActivitySet.contains(task.Id)){//Eliminating the Scheduled Non-Program Activities
                    if(!programdata.activityMap.containskey(task.Program_SFID__c)) {
                        programdata.activityMap.put(task.Program_SFID__c, new  List <Program_Activity__c > { task }); 
                    }
                    else{
                        programdata.activityMap.get(task.Program_SFID__c).add(task);  
                    }
                }
        }
       
        if(programIdSet != Null){
            for(Program_Activity__c  tsk:[SELECT Id,Name,Program_SFID__c,Activity_Type__c FROM Program_Activity__c  WHERE  Id IN :selectedpgmActivityIdSet AND RecordTypeId != :recType.id]){
                    programdata.selectedActivityList.add(tsk);
                    programdata.activityType = tsk.Activity_Type__c;
            }
        }
 
            for(Program__c prgm : [SELECT id,Name FROM Program__c WHERE id IN :programIdSet AND  RecordTypeId != :nonProgramRecordType.id]){
                    programdata.selectedProgramsList.add(prgm);
            }
        programdata.accountProgramList.clear();
        if(listProgram.size() > 0){programdata.accountProgramList.addall(listProgram);} 
            programdata.accountName= selectedAccount != null ? (selectedAccount.Name != null ? selectedAccount.Name : ''):'';
            programdata.streetaddress= !accCommunication.isEmpty() ? (accCommunication[0].Parent_SFID__r != null ? (accCommunication[0].Parent_SFID__r.Parent_SFID__r != null ? (accCommunication[0].Parent_SFID__r.Parent_SFID__r.Street_Addr__c != null ? accCommunication[0].Parent_SFID__r.Parent_SFID__r.Street_Addr__c : '' ): '') : ''):'';
            programdata.cityName=  !accCommunication.isEmpty() ? (accCommunication[0].Parent_SFID__r != null ? (accCommunication[0].Parent_SFID__r.Parent_SFID__r != null ? (accCommunication[0].Parent_SFID__r.Parent_SFID__r.City_Name__c != null ? accCommunication[0].Parent_SFID__r.Parent_SFID__r.City_Name__c: '' ): '') : ''):'';
            programdata.stateName= !accCommunication.isEmpty() ? (accCommunication[0].Parent_SFID__r != null ? (accCommunication[0].Parent_SFID__r.Parent_SFID__r != null ? (accCommunication[0].Parent_SFID__r.Parent_SFID__r.State_Name__c != null ? accCommunication[0].Parent_SFID__r.Parent_SFID__r.State_Name__c : '' ): '') : ''):'';
            programdata.CountryName= !accCommunication.isEmpty() ? (accCommunication[0].Parent_SFID__r != null ? (accCommunication[0].Parent_SFID__r.Parent_SFID__r != null ? (accCommunication[0].Parent_SFID__r.Parent_SFID__r.Country_Name__c != null ? accCommunication[0].Parent_SFID__r.Parent_SFID__r.Country_Name__c: '' ): '') : ''):'';
      
        
            programdata.firstName= accontact != null ? (accontact.FirstName != null ? accontact.FirstName : '') : '';
            programdata.lastName=accontact != null ? (accontact.LastName!= null ? accontact.LastName: '') : '';
            programdata.MobilePhone=accontact != null ? (accontact.MobilePhone!= null ? accontact.MobilePhone: '') : '';
            programdata.contactEmail= !contactEmail.isEmpty() ?(contactEmail[0].Parent_SFID__r != null ? (contactEmail[0].Parent_SFID__r.Parent_SFID__r != null ? (contactEmail[0].Parent_SFID__r.Parent_SFID__r.Email_Addr__c != null ? contactEmail[0].Parent_SFID__r.Parent_SFID__r.Email_Addr__c : ''):''):''):'';
            programdata.contactPhone= !contactPhone.isEmpty() ? (contactPhone[0].Parent_SFID__r != null ? (contactPhone[0].Parent_SFID__r.Parent_SFID__r != null ? (contactPhone[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c  != null ? contactPhone[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c  : ''):''):''):'';
            programdata.contactAddress= (!contactAddress.isEmpty() ? (contactAddress[0].Parent_SFID__r != null ? (contactAddress[0].Parent_SFID__r.Parent_SFID__r != null ? (contactAddress[0].Parent_SFID__r.Parent_SFID__r.Street_Addr__c != null ? contactAddress[0].Parent_SFID__r.Parent_SFID__r.Street_Addr__c+'\n' : ''  ):''):''):'') +
                                        (!contactAddress.isEmpty() ? (contactAddress[0].Parent_SFID__r != null ? (contactAddress[0].Parent_SFID__r.Parent_SFID__r != null ? (contactAddress[0].Parent_SFID__r.Parent_SFID__r.City_Name__c != null? contactAddress[0].Parent_SFID__r.Parent_SFID__r.City_Name__c+'\n' : ''  ):''):'') :'')+
                                        (!contactAddress.isEmpty() ? (contactAddress[0].Parent_SFID__r != null ? (contactAddress[0].Parent_SFID__r.Parent_SFID__r != null ? (contactAddress[0].Parent_SFID__r.Parent_SFID__r.State_Name__c != null? contactAddress[0].Parent_SFID__r.Parent_SFID__r.State_Name__c+'\n' : ''  ):''):''):'') +
                                        (!contactAddress.isEmpty() ? (contactAddress[0].Parent_SFID__r != null ?  (contactAddress[0].Parent_SFID__r.Parent_SFID__r != null ? (contactAddress[0].Parent_SFID__r.Parent_SFID__r.Country_Name__c != null? contactAddress[0].Parent_SFID__r.Parent_SFID__r.Country_Name__c+'\n' : ''  ):''):''):'');
            return JSON.serialize(programdata);
    }
    
    
    public Class GrowerProgramWrapper{
        public List<Account_Program__c> accountProgramList {get;set;}
        public Map<Id,List<Program_Activity__c >> activityMap {get;set;}
        public List<Program_Activity__c > selectedActivityList {get;set;}
        public List<Program__c> selectedProgramsList {get;set;}
        public List<Program__c> nonProgramsList {get;set;}
        public List<Program_Activity__c > nonProgramActivitiyList{get;set;}
        public List<Program_Activity__c > selectedNonProgramActivityList{get;set;}
        public List<Program__c> selectedNonProgramList {get;set;}
        public String activityType {get;set;}
        public String touchPointStatus {get;set;}
        public String accountName {get;set;}
        public String streetaddress {get;set;}
        public String cityName {get;set;}
        public String stateName {get;set;}
        public String CountryName {get;set;}
        public String firstName {get;set;}
        public String lastName {get;set;}
        public String MobilePhone {get;set;}
        public String contactEmail{get;set;}
        public String contactPhone{get;set;}
        public String contactAddress{get;set;}
        public List<Contact> contactList {get;set;}
        public GrowerProgramWrapper(){
            accountProgramList = new List<Account_Program__c>();
            activityMap = new Map<Id,List<Program_Activity__c >>();
            selectedActivityList = new List<Program_Activity__c >();
            selectedProgramsList = new List<Program__c>();
            nonProgramActivitiyList = new List<Program_Activity__c >();
            selectedNonProgramActivityList = new List<Program_Activity__c >();
            nonProgramsList = new List<Program__c>();
            selectedNonProgramList = new List<Program__c>();
            contactList = new List<Contact>();
        }
    }
    
      @AuraEnabled
    public static void saveTouchPointDetails(Id accId,String deletedProgramIds,String deletedActivityIds,String programIdAndActivityIds,
                                            String deletedNonProgramIds,String deletedNonActivityIds,String savedNonProgramActivityMapIds,
                                            String status,string touchPointId,string touchPointType,String touchPointDates){
                     
        List<String> deletedActivityIdList = new List<String>();
        List<String> deletedProgramIdList = new List<String>();
        List<String> deletedNonActivityIdList = new List<String>();
        List<String> deletedNonProgramIdList = new List<String>();
        List<Task> updateTaskList = new List<Task>();
        List<Task> taskList = new List<Task>();
        List<Task> deleteTaskList = new List<Task>();
        List<Account_Program__c> accProgramList = new List<Account_Program__c>();                                       
                                                
        
        Set<String> deletedActivityIdSet = new Set<String>();
        Set<String> deletedProgramIdSet = new Set<String>(); 
        Set<String> deletedNonActivityIdSet = new Set<String>();
        Set<String> deletedNonProgramIdSet = new Set<String>();
        Set<String> selectedProgramActivityIdSet = new Set<String>(); 
        Set<String> selectedNonProgramActivityIdSet = new Set<String>(); 
        Set<Task> taskSet = new Set<Task>();
        Set<Id> nonPrgIdSet = new Set<Id>();
        Set<Id> nonPrgActivitySet = new Set<Id>();
        Set<Id> PrgIdSet = new Set<Id>();
        Set<String> PrgAndNonProgActivitySet = new Set<String>();
        
        Map<String, List<Activities>> programIdAndActivityIdListMap = new Map<String, List<Activities>>();
        Map<String, List<Activities>> nonprogramIdAndActivityIdListMap = new Map<String, List<Activities>>();
        Map<Id,List<Task>> prgIdAndTaskListMap = new Map<Id,List<Task>>();
        Map<Id,Set<Id>> progIdAndProgramActivitySetMap = new Map<Id,Set<Id>>();
        
        if(deletedActivityIds != '["null"]'){
            deletedActivityIdList = (List<String>)JSON.deserialize(deletedActivityIds, List<String>.class);
            deletedActivityIdSet = new Set<String>(deletedActivityIdList);
        }
        if(deletedProgramIds != '["null"]'){
            deletedProgramIdList = (List<String>)JSON.deserialize(deletedProgramIds, List<String>.class);
            deletedProgramIdSet = new Set<String>(deletedProgramIdList); 
        }
        if(deletedNonActivityIds != '["null"]'){
            deletedNonActivityIdList = (List<String>)JSON.deserialize(deletedNonActivityIds, List<String>.class);
            deletedNonActivityIdSet = new Set<String>(deletedNonActivityIdList);
        }
        if(deletedNonProgramIds != '["null"]'){
            deletedNonProgramIdList = (List<String>)JSON.deserialize(deletedNonProgramIds, List<String>.class);
            deletedNonProgramIdSet = new Set<String>(deletedNonProgramIdList); 
        }
        if(programIdAndActivityIds != '["null"]')programIdAndActivityIdListMap = (Map<String, List<Activities>>)JSON.deserialize(programIdAndActivityIds, Map<String, List<Activities>>.class);
        if(savedNonProgramActivityMapIds != 'null')nonprogramIdAndActivityIdListMap = (Map<String, List<Activities>>)JSON.deserialize(savedNonProgramActivityMapIds, Map<String, List<Activities>>.class);
         
         for(String prgId : programIdAndActivityIdListMap.keySet()){
            for(Activities acti : programIdAndActivityIdListMap.get(prgId)){
                selectedProgramActivityIdSet.add(acti.id);
            }
        }
        
         for(String prgId : nonprogramIdAndActivityIdListMap .keySet()){
            for(Activities acti : nonprogramIdAndActivityIdListMap.get(prgId)){
                selectedNonProgramActivityIdSet.add(acti.id);
            }
        }
         
        PrgAndNonProgActivitySet.addAll(selectedProgramActivityIdSet);
        PrgAndNonProgActivitySet.addAll(selectedNonProgramActivityIdSet);
        
        TouchPoint__c touchPoint = new TouchPoint__c();
        
        if(touchPointId != 'null' && touchPointId != '' && touchPointId != NULL ){
            touchPoint.id = touchPointId;
        }
                                                
		DateTime dt = (DateTime) JSON.deserialize('"' + touchPointDates + '"', DateTime.class);        
        System.debug('parsed Date' + dt);
        List<Account> accList = [SELECT Id,Name FROM Account WHERE id = :accId];
        /*String[] strDate = touchPointDates.split('-');
        Integer myIntDate = integer.valueOf(strDate[2]);
        Integer myIntMonth = integer.valueOf(strDate[1]);
        Integer myIntYear = integer.valueOf(strDate[0]);
        Date touchPointDate = Date.newInstance(myIntYear, myIntMonth, myIntDate);*/
        touchPoint.Date__c = dt;
        touchPoint.TouchPoint_Status__c = status;
        touchPoint.TouchPointTypes__c = touchPointType;
        touchpoint.Account_SFID__c = accId; 
        string accountName =  accList.isEmpty() ? '' : ('- '+accList[0].Name );                                       
        touchpoint.Name = 'Touchpoint '+ accountName;                                     
        upsert(touchPoint);
        
        if(touchPointId == 'null' || touchPointId == '' || touchPointId == NULL ){        
            
            for(Task tsk : [SELECT Id,Subject,Program_SFID__c,Program_Activity_SFID__c  FROM Task WHERE Program_SFID__c != Null And Program_Activity_SFID__c  != Null AND WhatId = :accId AND CreatedById =:currentUserId]){
                if(!prgIdAndTaskListMap.containsKey(tsk.Program_SFID__c)){
                    prgIdAndTaskListMap.put(tsk.Program_SFID__c,new List<Task>{tsk});
                }else{
                    prgIdAndTaskListMap.get(tsk.Program_SFID__c).add(tsk);
                }
                if(!progIdAndProgramActivitySetMap.containsKey(tsk.Program_SFID__c)){
                    progIdAndProgramActivitySetMap.put(tsk.Program_SFID__c,new Set<Id>{tsk.Program_Activity_SFID__c });
                }else{
                    progIdAndProgramActivitySetMap.get(tsk.Program_SFID__c).add(tsk.Program_Activity_SFID__c );
                }
                
            }
            System.debug('prgIdAndTaskListMap=>'+prgIdAndTaskListMap);

            for(String pgmId :programIdAndActivityIdListMap.keySet()){
                for(Activities act : programIdAndActivityIdListMap.get(pgmId)){
                    for(Task tskss : prgIdAndTaskListMap.get(pgmId)){
                        if(tskss.Program_Activity_SFID__c  == act.id && tskss.Program_SFID__c == pgmId){
                            Task tsk = new Task();
                            tsk.id = tskss.id;
                            tsk.Program_Activity_SFID__c  = act.id;
                            tsk.Program_SFID__c = pgmId;
                            tsk.TouchPoint_SFID__c = touchPoint.id;
                            tsk.Status = status;
                            tsk.WhatId = accId;
                            taskList.add(tsk);
                            PrgIdSet.add(pgmId);
                        }
                    }
                }
            }
            
            //Changing Corresponding Account Program to In-Execution State
            
            for(Account_Program__c accPrg : [ SELECT id,Account_SFID__c,Submitted__c,Program_SFID__c,Execution_Status__c,Planning_Status__c 
                                              FROM Account_Program__c
                                              WHERE Account_SFID__c= :accId AND Program_SFID__c IN :PrgIdSet AND CreatedById =:currentUserId ])
            {
                if(accPrg.Execution_Status__c != 'In Execution' && accPrg.Planning_Status__c != 'Post-Plan'){
                    Account_Program__c accpg = new Account_Program__c();
                    accpg.id = accPrg.id;
                    accpg.Execution_Status__c = 'In Execution';
                    accpg.Planning_Status__c = 'Post-Plan';
                    accProgramList.add(accpg);
                }
            }
            if(accProgramList.size() > 0){
                update accProgramList;
            }
            
            for(String pgmId :nonprogramIdAndActivityIdListMap.keySet()){
                for(Activities act : nonprogramIdAndActivityIdListMap.get(pgmId)){
                    //if(prgIdAndTaskListMap.containsKey(pgmId)){ //
                        //for(Task tskss : prgIdAndTaskListMap.get(pgmId)){
                            //if(tskss.Program_Activity_SFID__c  == act.id && tskss.Program_SFID__c == pgmId){
                                Task tsk = new Task(Subject=act.value,Program_Activity_SFID__c  = act.id,Program_SFID__c = pgmId,TouchPoint_SFID__c= touchPoint.Id,
                                                   Status = status,WhatId = accId);                           
                                taskList.add(tsk);
                            //}
                        //}
                    //}
                }
            }
         }else{
             for(Task tsk : [SELECT Id,Subject,Program_SFID__c,Program_Activity_SFID__c ,TouchPoint_SFID__c FROM Task WHERE Program_SFID__c != Null And Program_Activity_SFID__c  != Null AND WhatId = :accId AND TouchPoint_SFID__c = :touchPointId AND CreatedById =:currentUserId]){
                if(!prgIdAndTaskListMap.containsKey(tsk.Program_SFID__c)){
                    prgIdAndTaskListMap.put(tsk.Program_SFID__c,new List<Task>{tsk});
                }else{
                    prgIdAndTaskListMap.get(tsk.Program_SFID__c).add(tsk);
                }
             }
             for(Task tsk : [SELECT Id,Subject,Program_SFID__c,Program_Activity_SFID__c ,TouchPoint_SFID__c FROM Task WHERE Program_SFID__c != Null And Program_Activity_SFID__c  != Null AND WhatId = :accId AND TouchPoint_SFID__c = :touchPointId AND CreatedById =:currentUserId]){
                if(!progIdAndProgramActivitySetMap.containsKey(tsk.Program_SFID__c)){
                    progIdAndProgramActivitySetMap.put(tsk.Program_SFID__c,new Set<Id>{tsk.Program_Activity_SFID__c });
                }else{
                    progIdAndProgramActivitySetMap.get(tsk.Program_SFID__c).add(tsk.Program_Activity_SFID__c );
                }
            }
         
            
            for(Id prgId : programIdAndActivityIdListMap.keySet()){ //For newly Added Program And Activities
                if(prgIdAndTaskListMap.containsKey(prgId)){
                    for(Task act : prgIdAndTaskListMap.get(prgId)){
                        for(Activities acts : programIdAndActivityIdListMap.get(prgId)){
                            if(act.TouchPoint_SFID__c == Null && act.Program_Activity_SFID__c  == act.id){
                                Task tsk = new Task();
                                tsk.Program_Activity_SFID__c  = act.Program_Activity_SFID__c ;
                                tsk.Program_SFID__c= prgId;
                                tsk.TouchPoint_SFID__c = touchPointId;
                                tsk.Status = status;
                                tsk.id = act.id;
                                taskList.add(tsk);
                            }
                        }
                    }
                }
            }
            for(Id prgId : nonprogramIdAndActivityIdListMap.keySet()){ //For newly Added Non Program And Activities
                if(prgIdAndTaskListMap.containsKey(prgId)){
                    for(Task act : prgIdAndTaskListMap.get(prgId)){
                        for(Activities acts : nonprogramIdAndActivityIdListMap.get(prgId)){
                            if(act.TouchPoint_SFID__c == Null && act.Program_Activity_SFID__c  == act.id){
                                Task tsk = new Task();
                                tsk.Program_Activity_SFID__c  = act.Program_Activity_SFID__c ;
                                tsk.Program_SFID__c = prgId;
                                tsk.TouchPoint_SFID__c = touchPointId;
                                tsk.Status = status;
                                tsk.id = act.id;
                                taskList.add(tsk);
                            }
                        }
                    }
                }
            }            
             
           for(Id prgId : prgIdAndTaskListMap.keySet()){ 
               if(deletedProgramIdSet.contains(prgId)){//For deleted Program
                   for(Task tsk : prgIdAndTaskListMap.get(prgId)){
                        Task tsks = new Task();
                        tsks.status = 'Not Scheduled';
                        tsks.TouchPoint_SFID__c = Null;
                        tsks.Id = tsk.id;
                        taskList.add(tsks);
                        PrgIdSet.add(prgId);
                   }
               }else {
                   if(programIdAndActivityIdListMap.containsKey(prgId )){
                       for(Activities activits : programIdAndActivityIdListMap.get(prgId)){
                           if(!progIdAndProgramActivitySetMap.get(prgId).contains(activits.id)){//newly added activities for existing program
                               for(Task act : prgIdAndTaskListMap.get(prgId)){
                                   if(act.Program_Activity_SFID__c  == activits.id){
                                        Task tsk = new Task();
                                        tsk.Program_Activity_SFID__c  = activits.id;
                                        tsk.Program_SFID__c= prgId;
                                        tsk.TouchPoint_SFID__c = touchPointId;
                                        tsk.Status = status;
                                        tsk.id = act.id;
                                        taskList.add(tsk);
                                        PrgIdSet.add(prgId);
                                    }
                                }
                                
                           }else if(deletedActivityIdSet.contains(activits.id)) {//Deleting Activities FROM Existing Program                           
                                   for(Task tsk : prgIdAndTaskListMap.get(prgId)){                                       
                                       if(activits.id == tsk.Program_Activity_SFID__c  ){                                      
                                      
                                            Task tsks = new Task();
                                            tsks.status = 'Not Scheduled';
                                            tsks.TouchPoint_SFID__c = Null;
                                            tsks.Id = tsk.id;
                                            taskList.add(tsks);
                                            PrgIdSet.add(prgId);
                                       }
                                   }
                           }else{
                               for(Task tsks : prgIdAndTaskListMap.get(prgId)){                                  
                                  if(activits.id == tsks.Program_Activity_SFID__c  ){
                                       Task tsk = new Task();
                                       tsk.Id = tsks.id;
                                       tsk.Status = status;
                                       taskList.add(tsk);
                                       PrgIdSet.add(prgId);                                   
                                   }
                               } 
                                for(Task tsks : prgIdAndTaskListMap.get(prgId)){ //Deleting the deselected Activity From Existing Non Program                                 
                                    if(!PrgAndNonProgActivitySet.contains(tsks.Program_Activity_SFID__c)){
                                      Task tskss = new Task();
                                            tskss.status = 'Not Scheduled';
                                            tskss.TouchPoint_SFID__c = Null;
                                            tskss.Id = tsks.id;
                                            taskList.add(tskss);
                                            PrgIdSet.add(prgId);                                  
                                   }
                               }  
                           }
                       }
                   }
               }
            }
            
            for(Id prgId : prgIdAndTaskListMap.keySet()){ 
               if(deletedNonProgramIdSet.contains(prgId)){//For deleted Non Program
                   for(Task tsk : prgIdAndTaskListMap.get(prgId)){
                        Task tsks = new Task();
                        tsks.status = 'Not Scheduled';
                        tsks.TouchPoint_SFID__c = Null;
                        tsks.Id = tsk.id;
                        deleteTaskList.add(tsks);
                        nonPrgIdSet.add(prgId);        
                        
                   }
               }else {
                   if(nonprogramIdAndActivityIdListMap.containsKey(prgId)){
                       system.debug('Test');
                       for(Activities activits : nonprogramIdAndActivityIdListMap.get(prgId)){
                           nonPrgActivitySet.add(activits.id);
                           system.debug('progIdAndProgramActivitySetMap=>'+progIdAndProgramActivitySetMap.get(prgId));
                           system.debug('activits.id=>'+activits.id);
                           if(!progIdAndProgramActivitySetMap.get(prgId).contains(activits.id)){//newly added  activities for existing Non program
                               //for(Task act : prgIdAndTaskListMap.get(prgId)){
                                   //if(act.Program_Activity_SFID__c  == activits.id){
                                        Task tsk = new Task();
                                        tsk.Program_Activity_SFID__c  = activits.id;
                                        tsk.Program_SFID__c = prgId;
                                        tsk.TouchPoint_SFID__c = touchPointId;
                                        tsk.Status = status;
                                        tsk.subject = activits.value;
                                        tsk.WhatId= accId;
                                        //tsk.id = act.id;
                                        taskList.add(tsk);
                                        nonPrgIdSet.add(prgId);
                                    //}
                               // }
                                
                           }else if(deletedNonActivityIdSet.contains(activits.id)) {//Deleting Activities FROM Existing  Non Program
                                   for(Task tsk : prgIdAndTaskListMap.get(prgId)){                                       
                                       if(activits.id == tsk.Program_Activity_SFID__c  ){                                       
                                            Task tsks = new Task();
                                            tsks.status = 'Not Scheduled';
                                            tsks.TouchPoint_SFID__c = Null;
                                            tsks.Id = tsk.id;
                                            deleteTaskList.add(tsks);
                                            nonPrgIdSet.add(prgId);        
                                       }
                                   }
                           }else{
                               for(Task tsks : prgIdAndTaskListMap.get(prgId)){                                   
                                   if(activits.id == tsks.Program_Activity_SFID__c  ){                                      
                                       Task tsk = new Task();
                                       tsk.Id = tsks.id;
                                       tsk.Status = status;
                                       taskList.add(tsk);
                                       nonPrgIdSet.add(prgId);                                   
                                   }
                               }
                               
                               for(Task tsks : prgIdAndTaskListMap.get(prgId)){ //Deleting the deselected Activity From Existing Non Program                                 
                                    if(!PrgAndNonProgActivitySet.contains(tsks.Program_Activity_SFID__c)){
                                       Task tsk = new Task();
                                       tsk.Id = tsks.id;
                                       tsk.Status = status;
                                       deleteTaskList.add(tsk);
                                       nonPrgIdSet.add(prgId);                                   
                                   }
                               }  
                           }
                       }
                   }//else{
                       system.debug('nonPrgIdSet=>'+nonPrgIdSet);
                      
                    
                   // }
               }
            } 
            
            for(String pgmId :nonprogramIdAndActivityIdListMap.keySet()){
                for(Activities act : nonprogramIdAndActivityIdListMap.get(pgmId )){
                    if(!nonPrgIdSet.contains(pgmId ) && !PrgIdSet.contains(pgmId )){ //
                        
                        //for(Task tskss : prgIdAndTaskListMap.get(pgmId)){
                            //if(tskss.Program_Activity_SFID__c  == act.id && tskss.Program_SFID__c == pgmId){
                                Task tsk = new Task(Subject=act.value,Program_Activity_SFID__c  = act.id,Program_SFID__c = pgmId,TouchPoint_SFID__c= touchPoint.Id,
                                                   Status = status,WhatId = accId);                           
                                taskList.add(tsk);
                            //}
                        //}
                    }
                }
            }       
        
        }
        if(taskList.size() > 0){
            
            taskSet.addAll(taskList);
            taskList = new List<Task>();
            taskList.addAll(taskSet);
            try{
                upsert taskList;
            }
            catch(Exception e){
                system.debug('Exception occured ========>'+e.getMessage());
            }
        }
        
        if(deleteTaskList.size() > 0){
            try{
                taskSet.clear();
                taskSet.addAll(deleteTaskList);
                deleteTaskList = new List<Task>();
                deleteTaskList.addAll(taskSet);
                delete deleteTaskList;
            }
            catch(Exception e){
                system.debug('Exception occured ========>'+e.getMessage());
            }
        }
    }
    
    public class Activities{
        public string id{get;set;}
        public string value{get;set;}
    }
          public class programDetailWrapper implements Comparable{
        public string Id{get;set;}
        public string AccountProgramId{get;set;}
        public string Name{get;set;}
        public Boolean SubmittedFlag{get;set;}
        public string ProgramId{get;set;}
        public string ExecutionStatus{get;set;}
        public string PlanningStatus{get;set;}
        public string Location{get;set;}
        public String RADL{get;set;}
        public String ProductName{get;set;}
         public programDetailWrapper(){
            this.ProductName = '';
         }
          public Integer compareTo(Object compareTo) {
            programDetailWrapper compareToEmp = (programDetailWrapper)compareTo;
            system.debug('CompareTo=>'+Name );
            if(triggerFields.split('-')[0] == 'Account_SFID__r.Name' && triggerFields.split('-')[1] == 'ASC'){
                if (Name == compareToEmp.Name) return 0;
                if (Name > compareToEmp.Name) return 1;
            }else if(triggerFields.split('-')[0] == 'Account_SFID__r.Name' && triggerFields.split('-')[1] == 'DESC'){
                if (Name == compareToEmp.Name) return 0;
                if (Name < compareToEmp.Name) return 1;
            }else if(triggerFields.split('-')[0] == 'Execution_Status__c' && triggerFields.split('-')[1] == 'ASC'){
                if (ExecutionStatus == compareToEmp.ExecutionStatus) return 0;
                if (ExecutionStatus > compareToEmp.ExecutionStatus) return 1;
            }else if(triggerFields.split('-')[0] == 'Execution_Status__c' && triggerFields.split('-')[1] == 'DESC'){
                if (ExecutionStatus == compareToEmp.ExecutionStatus) return 0;
                if (ExecutionStatus < compareToEmp.ExecutionStatus) return 1;
            }else if(triggerFields.split('-')[0] == 'Planning_Status__c' && triggerFields.split('-')[1] == 'ASC'){
                if (PlanningStatus == compareToEmp.PlanningStatus) return 0;
                if (PlanningStatus> compareToEmp.PlanningStatus) return 1;
            }else if(triggerFields.split('-')[0] == 'Planning_Status__c' && triggerFields.split('-')[1] == 'DESC'){
                if (PlanningStatus == compareToEmp.PlanningStatus) return 0;
                if (PlanningStatus < compareToEmp.PlanningStatus) return 1;
            }else if(triggerFields.split('-')[0] == 'Location' && triggerFields.split('-')[1] == 'ASC'){
                if (Location == compareToEmp.Location) return 0;
                if (Location> compareToEmp.Location) return 1;
            }else if(triggerFields.split('-')[0] == 'Location' && triggerFields.split('-')[1] == 'DESC'){
                if (Location == compareToEmp.Location) return 0;
                if (Location < compareToEmp.Location) return 1;
            }else if(triggerFields.split('-')[0] == 'Service_Level_Class_Descr__c' && triggerFields.split('-')[1] == 'ASC'){
                if (RADL == compareToEmp.RADL) return 0;
                if (RADL> compareToEmp.RADL) return 1;
            }else if(triggerFields.split('-')[0] == 'Service_Level_Class_Descr__c' && triggerFields.split('-')[1] == 'DESC'){
                if (RADL == compareToEmp.RADL) return 0;
                if (RADL < compareToEmp.RADL) return 1;
            }else if(triggerFields.split('-')[0] == 'Product_SFID__r.Name' && triggerFields.split('-')[1] == 'ASC'){
                system.debug('triggerFields asc-----------'+triggerFields);
                if (ProductName == compareToEmp.ProductName) return 0;
                if (ProductName> compareToEmp.ProductName) return 1;
            }else if(triggerFields.split('-')[0] == 'Product_SFID__r.Name' && triggerFields.split('-')[1] == 'DESC'){
                                system.debug('triggerFields desc-----------'+triggerFields);

                if (ProductName == compareToEmp.ProductName) return 0;
                if (ProductName < compareToEmp.ProductName) return 1;
            }  
            return -1;        
        }          
    }
  
}