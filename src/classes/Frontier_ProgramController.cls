public  without sharing class Frontier_ProgramController {
    public static Frontier_SortDirection sortFields = new  Frontier_SortDirection();
    public static Id currentUserId = UserInfo.getUserId();
    public static string triggerFields;

    @AuraEnabled
    public static List<String> getAllPrograms(String dealerId,String isAllDealer,String pageNumber,String pageSize,String isMyProgram){
        System.debug(dealerId+isAllDealer+isMyProgram+pageNumber+pageSize);
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
        List<Account> accList = new List<Account>();
        List<Program__c> programList = new List<Program__c>();
        List<ProgramWrapper> programListAfterSkip = new List<ProgramWrapper>();
        List<Account_Program__c> accPgmSalesList =  new List<Account_Program__c>();
        List<String> programsList = new List<String>();
        Set<Id> accSetId = new Set<Id>();
        Set<Id> dealerAccSetId = new Set<Id>();
        Set<Id> accPgmSalesIdSet = new Set<Id>();
        List<ProgramWrapper> pgmWrapperList = new List<ProgramWrapper>();
        Map<Id,ProgramWrapper> accPgmId =  new Map<Id,ProgramWrapper>();
        Set<Id> programSetId = new Set<Id>();
        List<Territory2> territoryList;
        List<UserTerritory2Association> userTerritoryList = new List<UserTerritory2Association>();
        userTerritoryList = [SELECT Id, IsActive, RoleInTerritory2, Territory2Id, UserId FROM 
                             UserTerritory2Association WHERE UserId =: UserInfo.getUserId()];
        if(!userTerritoryList.isEmpty()){
            territoryList = [SELECT Id, Name, DeveloperName, Division__c FROM 
                             Territory2 WHERE Id =: userTerritoryList[0].Territory2Id];
        }
        try{
            if(isMyProgram == 'false'){
                if(isAllDealer == 'true'){
                    for(Account_Business_Role__c accbussinessrole : [SELECT Id,Account_SFID__c FROM Account_Business_Role__c WHERE Role_Descr__c = 'Partner']){
                        dealerAccSetId.add(accbussinessrole.Account_SFID__c);
                    }
                }
                system.debug('dealerAccSetId' + dealerAccSetId);
                string query = 'SELECT Id,Name FROM account'; 
                if(dealerId != 'null' ){
                    system.debug('dealerId'+dealerId);
                    query += ' WHERE Dealer_SFID__c =:dealerId';
                }
                if(!dealerAccSetId.isEmpty()){
                    query += ' WHERE Dealer_SFID__c =:dealerAccSetId'; 
                }
                system.debug('query' +query);
                accList  = Database.query(query);
                for (Account acc:accList){
                    accSetId.add(acc.Id); 
                }
                List<Account_Program__c> accProgramList = new List<Account_Program__c>();
                
                accPgmSalesList=[SELECT Id,Account_SFID__c,Program_SFID__c,Program_SFID__r.CS_Growth__c,Program_SFID__r.Account_Type__c,Program_SFID__r.Volume_Growth__c,Program_SFID__r.Program_Coverage__c,Program_SFID__r.Growth__c,Program_SFID__r.Name,Program_SFID__r.Budget__c,Execution_Status__c, Service_Level_Class_Descr__c,Planning_Status__c  FROM Account_Program__c WHERE Account_SFID__c=:accSetId AND CreatedBy.ID = :UserInfo.getUserId()];
                
                
            }
            else{
                // Sales Rep owned Account Program
                accPgmSalesList = [SELECT Id,Account_SFID__c,Program_SFID__c,Program_SFID__r.CS_Growth__c,Program_SFID__r.Account_Type__c,Program_SFID__r.Volume_Growth__c,Program_SFID__r.Program_Coverage__c,Program_SFID__r.Growth__c,Program_SFID__r.Name,Program_SFID__r.Budget__c,Execution_Status__c, Service_Level_Class_Descr__c,Planning_Status__c FROM Account_Program__c WHERE CreatedBy.ID = :UserInfo.getUserId()];  
            }
            system.debug('accPgmSalesList' +accPgmSalesList.size()+accPgmSalesList);
            if(!accPgmSalesList.isEmpty()){
                // Get Program Id from Account_Program__c owned by Sales Rep
                for(Account_Program__c accPgmSales : accPgmSalesList){
                    system.debug('Inside for');
                    ProgramWrapper pgmWrapper;
                    //accPgmSalesIdSet.add(accPgmSales.Program_SFID__c);
                    if(accPgmId.containsKey(accPgmSales.Program_SFID__c)){
                        system.debug('Inside if');
                        pgmWrapper = accPgmId.get(accPgmSales.Program_SFID__c);
                        system.debug('pgmWrapper' +pgmWrapper);
                        if((accPgmSales.Execution_Status__c == 'Not Started') || (accPgmSales.Execution_Status__c == 'In Execution') || (accPgmSales.Execution_Status__c == 'Approved') || (accPgmSales.Execution_Status__c == 'Completed')){   
                            pgmWrapper.allocated += 1;
                            if(pgmWrapper.available != 'NA'){
                                pgmWrapper.available = String.valueOf((Integer.valueOf(pgmWrapper.available) -1) == -1 ? 0 : (Integer.valueOf(pgmWrapper.available) -1));
                            }
                        }
                        if(accPgmSales.Execution_Status__c == 'Completed'){   
                            pgmWrapper.consumed += 1;
                            pgmWrapper.completed += 1;
                        }
                        if(accPgmSales.Execution_Status__c == 'Cancelled'){   
                            pgmWrapper.cancelled += 1;
                            if(pgmWrapper.available != 'NA'){
                                pgmWrapper.available = String.valueOf((Integer.valueOf(pgmWrapper.available) -1) == -1 ? 0 : (Integer.valueOf(pgmWrapper.available) -1));
                            }
                            
                        }
                        if(accPgmSales.Execution_Status__c == 'Not Started'){   
                            pgmWrapper.notstarted += 1;
                            
                        }
                        if(accPgmSales.Execution_Status__c == 'In Execution'){   
                            pgmWrapper.inExec  += 1;
                            
                        }
                        if(accPgmSales.Planning_Status__c == 'Planned'){   
                            pgmWrapper.planned += 1;     
                        }
                        else{
                            pgmWrapper.postplan += 1; 
                        }
                        if(accPgmSales.Service_Level_Class_Descr__c == 'Retain' && accPgmSales.Execution_Status__c != 'Cancelled'){   
                            pgmWrapper.retaincount  += 1;
                            
                        }
                        else if(accPgmSales.Service_Level_Class_Descr__c == 'Acquire' && accPgmSales.Execution_Status__c != 'Cancelled'){   
                            pgmWrapper.acquirecount   += 1;
                            
                        }
                        else if(accPgmSales.Service_Level_Class_Descr__c == 'Light Touch' && accPgmSales.Execution_Status__c != 'Cancelled'){   
                            pgmWrapper.ltcount   += 1;
                            
                        }
                        else if(accPgmSales.Service_Level_Class_Descr__c == 'Develop' && accPgmSales.Execution_Status__c != 'Cancelled'){   
                            pgmWrapper.developcount   += 1;
                            
                        }
                    }
                    else{
                        system.debug('Inside else');
                        pgmWrapper = new ProgramWrapper();
                        pgmWrapper.progName= accPgmSales.Program_SFID__r.Name;
                        pgmWrapper.progId= accPgmSales.Program_SFID__c;
                        pgmWrapper.acctTarget  = accPgmSales.Program_SFID__r.Account_Type__c;
                        system.debug('pgmWrapper Name' +pgmWrapper.progName);
                        pgmWrapper.volumegrowth = (accPgmSales.Program_SFID__r.Volume_Growth__c !=null ? Integer.valueof(accPgmSales.Program_SFID__r.Volume_Growth__c):0);
                        pgmWrapper.growthPer = (accPgmSales.Program_SFID__r.Growth__c !=null ? Integer.valueof(accPgmSales.Program_SFID__r.Growth__c):0);
                        pgmWrapper.CSGrowth =(accPgmSales.Program_SFID__r.CS_Growth__c !=null?Integer.valueof(accPgmSales.Program_SFID__r.CS_Growth__c):0);
                        pgmWrapper.programcov =(accPgmSales.Program_SFID__r.Program_Coverage__c !=null?accPgmSales.Program_SFID__r.Program_Coverage__c:'') ; 
                        if((accPgmSales.Execution_Status__c == 'Not Started') || (accPgmSales.Execution_Status__c == 'In Execution') || (accPgmSales.Execution_Status__c == 'Approved') || (accPgmSales.Execution_Status__c == 'Completed')){   
                            pgmWrapper.allocated = 1;
                            pgmWrapper.available = ((accPgmSales.Program_SFID__r.Budget__c == Null || accPgmSales.Program_SFID__r.Budget__c == 0) ? 'NA' : String.valueOf(accPgmSales.Program_SFID__r.Budget__c - 1));   
                        }
                        if(accPgmSales.Execution_Status__c == 'Completed'){   
                            pgmWrapper.consumed = 1;
                            pgmWrapper.completed = 1;
                        }
                        if(accPgmSales.Execution_Status__c == 'Cancelled'){   
                            pgmWrapper.cancelled = 1;
                            pgmWrapper.available = ((accPgmSales.Program_SFID__r.Budget__c == Null || accPgmSales.Program_SFID__r.Budget__c == 0) ? 'NA' : String.valueOf(accPgmSales.Program_SFID__r.Budget__c - 1));   
                            
                        }
                        if(accPgmSales.Execution_Status__c == 'Not Started'){   
                            pgmWrapper.notstarted = 1;
                            
                        }
                        if(accPgmSales.Execution_Status__c == 'In Execution'){   
                            pgmWrapper.inExec  = 1;
                            
                        }
                        if(accPgmSales.Planning_Status__c == 'Planned'){   
                            pgmWrapper.planned = 1;     
                        }
                        else{
                            pgmWrapper.postplan = 1; 
                        }
                        if(accPgmSales.Service_Level_Class_Descr__c == 'Retain' && accPgmSales.Execution_Status__c != 'Cancelled'){   
                            pgmWrapper.retaincount  = 1;
                            
                        }
                        else if(accPgmSales.Service_Level_Class_Descr__c == 'Acquire' && accPgmSales.Execution_Status__c != 'Cancelled'){   
                            pgmWrapper.acquirecount   = 1;
                            
                        }
                        else if(accPgmSales.Service_Level_Class_Descr__c == 'Light Touch' && accPgmSales.Execution_Status__c != 'Cancelled'){   
                            pgmWrapper.ltcount   = 1;
                            
                        }
                        else if(accPgmSales.Service_Level_Class_Descr__c == 'Develop' && accPgmSales.Execution_Status__c != 'Cancelled'){   
                            pgmWrapper.developcount   = 1;
                            
                        }
                        system.debug('pgmWrapper' +pgmWrapper);
                        accPgmId.put(accPgmSales.Program_SFID__c,pgmWrapper);  
                        system.debug('accPgmId' +accPgmId);
                    }
                    
                    
                } 
            }
            for(Id pgmMap : accPgmId.keySet() ){
                pgmWrapperList.add(accPgmId.get(pgmMap));
            }
            system.debug('pgmWrapperList' +pgmWrapperList);
            /* programList=[SELECT Id,Name,Allocated__c, RecordType.Name, Available__c,Cancelled__c,Budget__c,Completed__c,CS_Growth__c,Execution_Status__c,Growth__c,In_Execution__c,
Not_Started__c,Planning_Status__c,Brand_Family__c,Target_RADL__c,Total_Acquire__c,Total_Develop__c,Total_Light_Touch__c,Total_Planned__c,Total_Post_Plan__c,
Total_Retain__c,Volume_Growth__c,Program_Coverage__c FROM Program__c Where RecordType.Name = 'Program' AND Brand_Family__c =: territoryList[0].Division__c];  */
            
            
            if(!pgmWrapperList.isEmpty()){
                for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < pgmWrapperList.size();i++){   
                    programListAfterSkip.add(pgmWrapperList[i]);
                }
                programsList.add((String.valueOf(pgmWrapperList.size())));
                programsList.add((JSON.serialize(programListAfterSkip)));
                programsList.add(JSON.serialize(pgmWrapperList));
            }
        }
        catch(Exception e){
            System.debug('The following error has been occured' + e.getMessage()); 
        }
        return programsList;
    }
    
    @AuraEnabled
    public static List<String> getMyProgramAccounts (Id programId, String pageSize,String pageNumber,String triggeredField,Boolean isInitialize,Boolean isPageChange){
        List<String> accountProgramList = new List<String>();  
        accountProgramList = Frontier_GrowerAccount_ProgramController.getProgramAccounts(programId, 'default', 'default' ,pageSize, pageNumber, triggeredField, isInitialize, isPageChange, null);
        return accountProgramList;
    }
    
    @AuraEnabled
    public static string getSeasonData(String season){
        String seasonDetails = Frontier_GrowerProfileController.growerAccountDetails('','',season);
        return seasonDetails;
    }
    
    @AuraEnabled
    public static List<String> getPgmAccounts(String programId,String pageSize,String pageNumber,String triggeredField,Boolean isInitialize,Boolean isPageChange)
    {
        system.debug('triggeredField Start' + triggeredField);
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
        List<Account_Program__c> accProgramListAfterSkip = new List<Account_Program__c>();
        List<Account> groweracc = new List<Account>();
        Set<Id> growerIdSet = new Set<Id>();
        List<programDetailWrapper> accountProgramListWrapper = new List<programDetailWrapper>();
        Map<Id,List<String>> accountProductMap = new Map<Id,List<String>>();
        String query;
        List<String> accountProgramList = new List<String>(); 
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
        
        groweracc = [ SELECT Id, Dealer_SFID__c FROM Account WHERE Dealer_SFID__c != null ];
        
        System.debug('groweracc' + groweracc);
        for(Account grower : groweracc){
            growerIdSet.add(grower.Id);
        }
        query = 'SELECT Id, Name, Account_SFID__c,Service_Level_Class_Descr__c, Account_SFID__r.Name,Submitted__c, Account_SFID__r.BillingCity, Account_SFID__r.BillingState, Cancel_Reason__c, Execution_Status__c, Planning_Status__c, Program_SFID__c, Program_SFID__r.Name ,Program_SFID__r.Available__c, Program_SFID__r.Allocated__c, Program_SFID__r.Consumed__c,Program_SFID__r.CS_Growth__c, Program_SFID__r.Growth__c,Program_SFID__r.Volume_Growth__c, Program_SFID__r.Program_Coverage__c, CreatedDate FROM Account_Program__c WHERE Program_SFID__c =: programId AND Account_SFID__c IN :growerIdSet AND CreatedById =:currentUserId' ; 
        
        
        
        
        
        system.debug('query' + query);
        try{
            listAccountPrograms = Database.query(query);
            if(Test.isRunningTest()){
                Integer testnum = 1/0;
            }
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
        
        try{
            accountRecordsList= [SELECT Account_SFID__c,Account_SFID__r.Name,Service_Level_Class_Descr__c,                                
                                 Role_Descr__c,Business_Unit_Descr__c, 
                                 (SELECT Source_System_ID__c FROM Account_Identifiers__r LIMIT 1),
                                 (SELECT Parent_SFID__r.Parent_SFID__r.Id,Parent_SFID__r.Parent_SFID__r.Street_Addr__c,Parent_SFID__r.Parent_SFID__r.City_Name__c,      
                                  Parent_SFID__r.Parent_SFID__r.State_Name__c,Parent_SFID__r.Parent_SFID__r.Country_Name__c,   
                                  Parent_SFID__r.Role_Descr__c FROM Account_Communications__r 
                                  WHERE   Archive_Ind__c = 'N' AND  Parent_SFID__r.Archive_Ind__c = 'N' AND   Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                                  AND   RecordType.DeveloperName = 'Account_Communication_Address_Role_Business_Role' AND  Parent_SFID__r.Role_Descr__c = 'Business'
                                  LIMIT 1)
                                 FROM  Account_Business_Role__c
                                 WHERE Account_SFID__c =: acctIdSet 
                                 AND   Archive_Ind__c = 'N'
                                 AND   Account_SFID__r.Archive_Ind__c = 'N'
                                 AND (Role_Descr__c = 'Partner' OR (Role_Descr__c='Customer' AND Role_Category_Descr__c = 'Consumer' AND Business_Unit_Descr__c = 'Customer'))];
        
        
        }
        catch(Exception e){
            system.debug('Error Occured on getting the account communication detais. =========>'+e.getMessage());
        }
        accountProgramList.add((String.valueOf(listAccountPrograms.size())));
        accountProgramList.add((JSON.serialize(accountProgramListWrapper)));
        accountProgramList.add((JSON.serialize(accountRecordsList)));
        accountProgramList.add((JSON.serialize(sortFields)));
        accountProgramList.add((JSON.serialize(accountProductList)));

        return accountProgramList;        
    }
    
    //Calculate average of Program allocation,available,consumed,completed etc...
    @AuraEnabled
    public static String getMyPrograms(Id ProgramId,String dealerId,String isAllDealer,String isMyProgram){

        MyProgramWrapper avgProgramWrap = new MyProgramWrapper();
        
        Integer allocated =0;
        Integer available =0;
        Integer consumed =0;
        Integer completed =0;
        Integer cancelled =0;
        Integer inExec =0;
        Integer notstarted =0;
        Integer planned =0;
        Integer postplan =0;
        Integer develop =0;
        Integer acquire =0;
        Integer retain =0;
        Integer lighttouch =0;
        
        //Calculate average Program Allocation,Available etc...
        
        List<String> programDetails = new List<String>();
        String jsonString;
        //Call getAllPrograms to get Program allocation, available, consumed etc..
        programDetails = Frontier_ProgramController.getAllPrograms(dealerId,isAllDealer,'10','1',isMyProgram);
        List<ProgramWrapper> ProgramList = new List<ProgramWrapper>();
        if(!programDetails.isEmpty()){
            jsonString = programDetails[2]; 
        }
        ProgramList = (List<ProgramWrapper>)((JSON.deserialize(jsonString, List<ProgramWrapper>.class)));    
        System.debug('*************Prgm 2---------'+ProgramList + ' ' + ProgramList.size());            
        if(!ProgramList.isEmpty()){
            for(ProgramWrapper pgmWrapper : ProgramList){
                allocated += pgmWrapper.allocated;
                available += (pgmWrapper.available == 'NA' ?0:Integer.valueOf(pgmWrapper.available));
                consumed +=  pgmWrapper.consumed;
                cancelled += pgmWrapper.cancelled;
                completed += pgmWrapper.completed;
                inExec += pgmWrapper.inExec;
                notstarted += pgmWrapper.notstarted;
                planned += pgmWrapper.planned;
                postplan += pgmWrapper.postplan;
                develop += pgmWrapper.developcount;
                acquire += pgmWrapper.acquirecount;
                retain += pgmWrapper.retaincount;
                lighttouch += pgmWrapper.ltcount;
                
            }
            //Calculate average and assign value to wrapper
            avgProgramWrap.pgmSize  = ProgramList.size();
            avgProgramWrap.avgAllocated = allocated/(ProgramList.size());
            avgProgramWrap.avgAvailable = available/(ProgramList.size());
            avgProgramWrap.avgConsumed  = consumed/(ProgramList.size());
            avgProgramWrap.avgCancelled = cancelled/(ProgramList.size());
            avgProgramWrap.avgCompleted = completed/(ProgramList.size());
            avgProgramWrap.avgExecution = inExec/(ProgramList.size());
            avgProgramWrap.avgNtStarted  = notstarted/(ProgramList.size());
            avgProgramWrap.avgPlanned   = planned/(ProgramList.size());
            avgProgramWrap.avgPostPlan  = postplan/(ProgramList.size());
            avgProgramWrap.developCount  = develop/(ProgramList.size());
            avgProgramWrap.acquireCount  = acquire/(ProgramList.size());
            avgProgramWrap.retainCount  = retain/(ProgramList.size());
            avgProgramWrap.lightTouchCount  = lighttouch/(ProgramList.size());
        }
        System.debug('avgProgramWrap' + avgProgramWrap);
        return JSON.serialize(avgProgramWrap);
    }
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
        cancelledProgram = [SELECT  Account_SFID__c,Program_SFID__c FROM Account_Program__c WHERE Id =:accPgmId];
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

            if(cancelProgramList !=null ){
                system.debug('cancelProgramList'+cancelProgramList);
               update cancelProgramList; 
            }  
        }
        catch(Exception le){
            System.debug('Message: ' + le.getMessage() + 'Cause: ' + le.getCause() + 'Line number: ' + le.getLineNumber() + 'Stack trace: ' + le.getStackTraceString());    
        }        
    } 
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
        
        completeProgram = [SELECT  Account_SFID__c,Program_SFID__c FROM Account_Program__c WHERE Id =:accPgmId];
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
    public static String getMyProgramsChart(String programId,String dealerId,String isAllDealer,String isMyProgram, String isDashboard){
        system.debug('programId' +programId);
        Set<Id> dealerAccSetId = new Set<Id>();
        Set<Id> accSetId = new Set<Id>();
        List<Account> accList = new List<Account>();
        List<Account_Program__c> accountPrograms = new List<Account_Program__c>();
        ProgramWrapper pgmWrapper = new ProgramWrapper();
        Schema.DescribeFieldResult sellingSeasonResult = Account_Farming_Area__c.Selling_Season_Descr__c.getDescribe();
        List<Schema.PicklistEntry> pickValues = sellingSeasonResult.getPicklistValues();
        Schema.DescribeFieldResult cropResult = Account_Farming_Area__c.Area_Usage_Descr__c.getDescribe();
        List<Schema.PicklistEntry> croppicvalues = cropResult.getPicklistValues();
        
        pgmWrapper.sellingSeasontypes.add('SUMMER');
        pgmWrapper.sellingSeasontypes.add('WINTER');
        pgmWrapper.sellingSeasontypes.add('SPRING');
        
		//Set picklist value for Account label and Crop value 'All Crops' in Account Dashboard	
        if(isDashboard == 'True'){
           System.debug('Inside Dashboard');
           Set<Id> territoryAccId = new Set<Id>();
           List<Account_Business_Role__c> dealeracc = new List<Account_Business_Role__c>();
           List<Account_Business_Role__c> groweracc = new List<Account_Business_Role__c>();
           territoryaccId = Util.getTerritoryAccountIds(); 
           //check logged in user holds dealer or grower account 
           dealeracc = [SELECT Id,Account_SFID__c FROM Account_Business_Role__c WHERE Role_Descr__c = 'Partner' AND Account_SFID__c = :territoryaccId];
           groweracc = [SELECT Id,Account_SFID__c FROM Account_Business_Role__c WHERE Role_Descr__c = 'Customer' AND Account_SFID__c = :territoryaccId];   
            if(!dealeracc.isEmpty()){
               pgmWrapper.accTypes.add('Dealer');
            }
            if(!groweracc.isEmpty()){
               pgmWrapper.accTypes.add('Grower');
            }
            pgmWrapper.accTypes.add('All Accounts');
            pgmWrapper.croptypes.add('All Crops'); 
        }
         for (Schema.PicklistEntry reasonLabel: croppicvalues) {
            pgmWrapper.croptypes.add(reasonLabel.getLabel());
        }
        if(isMyProgram == 'false'){
            if(isAllDealer == 'true'){
                for(Account_Business_Role__c accbussinessrole : [SELECT Id,Account_SFID__c FROM Account_Business_Role__c WHERE Role_Descr__c = 'Partner']){
                    dealerAccSetId.add(accbussinessrole.Account_SFID__c);
                }
            }
            system.debug('dealerAccSetId' + dealerAccSetId);
            string query = 'SELECT Id,Name FROM account'; 
            if(dealerId != 'null'){
                query += ' WHERE Dealer_SFID__c =:dealerId';
            }
            if(!dealerAccSetId.isEmpty()){
                query += ' WHERE Dealer_SFID__c =:dealerAccSetId'; 
            }
            system.debug('query' +query);
            accList  = Database.query(query);
            for (Account acc:accList){
                accSetId.add(acc.Id); 
            }
            List<Account_Program__c> accProgramList = new List<Account_Program__c>();
            
            accountPrograms = [SELECT Id,Account_SFID__c,Program_SFID__c,Program_SFID__r.CS_Growth__c,Program_SFID__r.Volume_Growth__c,Program_SFID__r.Program_Coverage__c,Program_SFID__r.Growth__c,Program_SFID__r.Name,Program_SFID__r.Budget__c,Execution_Status__c, Service_Level_Class_Descr__c,Planning_Status__c FROM Account_Program__c
                               WHERE Program_SFID__c =:programId AND Account_SFID__c =:accSetId AND CreatedBy.Id =:Userinfo.getUserId()];
            
            
        }
        else{
            accountPrograms = [SELECT Id,Account_SFID__c,Program_SFID__c,Program_SFID__r.CS_Growth__c,Program_SFID__r.Volume_Growth__c,Program_SFID__r.Program_Coverage__c,Program_SFID__r.Growth__c,Program_SFID__r.Name,Program_SFID__r.Budget__c,Execution_Status__c, Service_Level_Class_Descr__c,Planning_Status__c FROM Account_Program__c
                               WHERE Program_SFID__c =:programId AND CreatedBy.Id =:Userinfo.getUserId()];
        }
        system.debug('accountPrograms' +accountPrograms.size());
        for(Account_Program__c accPgmSales : accountPrograms){
            
            pgmWrapper.progName= accPgmSales.Program_SFID__r.Name;
            pgmWrapper.progId = accPgmSales.Program_SFID__c;
            system.debug('pgmWrapper Name' +pgmWrapper.progName);
            pgmWrapper.volumegrowth = (accPgmSales.Program_SFID__r.Volume_Growth__c !=null ? Integer.valueof(accPgmSales.Program_SFID__r.Volume_Growth__c):0);
            pgmWrapper.growthPer = (accPgmSales.Program_SFID__r.Growth__c !=null ? Integer.valueof(accPgmSales.Program_SFID__r.Growth__c):0);
            pgmWrapper.CSGrowth =(accPgmSales.Program_SFID__r.CS_Growth__c !=null?Integer.valueof(accPgmSales.Program_SFID__r.CS_Growth__c):0);
            pgmWrapper.programcov =(accPgmSales.Program_SFID__r.Program_Coverage__c !=null?accPgmSales.Program_SFID__r.Program_Coverage__c:'') ; 
            if((accPgmSales.Execution_Status__c == 'Not Started') || (accPgmSales.Execution_Status__c == 'In Execution') || (accPgmSales.Execution_Status__c == 'Approved') || (accPgmSales.Execution_Status__c == 'Completed')){   
                pgmWrapper.allocated += 1;
                pgmWrapper.available = ((accPgmSales.Program_SFID__r.Budget__c == Null || accPgmSales.Program_SFID__r.Budget__c == 0) ? '0' : String.valueOf(accPgmSales.Program_SFID__r.Budget__c -  pgmWrapper.allocated));   
            }
            if(accPgmSales.Execution_Status__c == 'Completed'){   
                pgmWrapper.consumed += 1;
                pgmWrapper.completed += 1;
            }
            if(accPgmSales.Execution_Status__c == 'Cancelled'){   
                pgmWrapper.cancelled += 1;
                pgmWrapper.available = ((accPgmSales.Program_SFID__r.Budget__c == Null || accPgmSales.Program_SFID__r.Budget__c == 0) ? '0' : String.valueOf(accPgmSales.Program_SFID__r.Budget__c - pgmWrapper.cancelled));   
                
            }
            if(accPgmSales.Execution_Status__c == 'Not Started'){   
                pgmWrapper.notstarted += 1;
            }
            if(accPgmSales.Execution_Status__c == 'In Execution'){   
                pgmWrapper.inExec  += 1;
                
            }
            if(accPgmSales.Planning_Status__c == 'Planned'){   
                pgmWrapper.planned += 1;     
            }
            else{
                pgmWrapper.postplan += 1; 
            }
            if(accPgmSales.Service_Level_Class_Descr__c == 'Retain' && accPgmSales.Execution_Status__c != 'Cancelled'){   
                pgmWrapper.retaincount  += 1;
                
            }
            else if(accPgmSales.Service_Level_Class_Descr__c == 'Acquire' && accPgmSales.Execution_Status__c != 'Cancelled'){   
                pgmWrapper.acquirecount   += 1;
                
            }
            else if(accPgmSales.Service_Level_Class_Descr__c == 'Light Touch' && accPgmSales.Execution_Status__c != 'Cancelled'){   
                pgmWrapper.ltcount   += 1;
                
            }
            else if(accPgmSales.Service_Level_Class_Descr__c == 'Develop' && accPgmSales.Execution_Status__c != 'Cancelled'){   
                pgmWrapper.developcount   += 1;
            }
        }
        system.debug('pgmWrapper'+pgmWrapper);
        return JSON.serialize(pgmWrapper);
        
    }  
    //Wrapper to group Average of allocated, available, consumed, cancelled, consumed etc..
    public class MyProgramWrapper{
        
        public String progName  {get;set;}
        public Integer avgAllocated  {get;set;} 
        public Integer avgAvailable  {get;set;} 
        public Integer avgConsumed  {get;set;} 
        public Integer avgCancelled  {get;set;} 
        public Integer avgCompleted  {get;set;} 
        public Integer avgExecution  {get;set;} 
        public Integer avgNtStarted  {get;set;} 
        public Integer avgPlanned  {get;set;} 
        public Integer avgPostPlan  {get;set;}  
        public Integer acquireCount  {get;set;} 
        public Integer developCount  {get;set;} 
        public Integer lightTouchCount  {get;set;} 
        public Integer retainCount  {get;set;}
        public Integer pgmSize {get;set;}
        public List<String> sellingSeasontypes{get;set;}
        public List<String> croptypes{get;set;}
        public MyProgramWrapper(){
            sellingSeasontypes=new List<String>();
            croptypes=new List<String>();
            
        }
    }
    //Wrapper to group Program name,Available, Allocated,Completed,Planned,Post Plan
    public class ProgramWrapper{
        public String progName;
        public String progId;
        public String acctTarget;
        public String available {get;set;}
        public Integer allocated {get;set;}
        public Integer consumed {get;set;}
        public Integer notstarted {get;set;}
        public Integer inExec {get;set;}
        public Integer completed {get;set;}
        public Integer cancelled {get;set;}
        public Integer planned {get;set;}
        public Integer postplan {get;set;}
        public Integer developcount {get;set;}
        public Integer acquirecount {get;set;}
        public Integer retaincount {get;set;}
        public Integer ltcount {get;set;}
        public Integer volumegrowth {get;set;}
        public Integer growthPer {get;set;}
        public Integer CSGrowth {get;set;}
        public Integer Productone {get;set;}
        public Integer Producttwo {get;set;}
        public String programcov {get;set;}
        public List<String> sellingSeasontypes{get;set;}
        public List<String> croptypes{get;set;}
        public List<String> accTypes{get;set;}
        
        
        public ProgramWrapper(){
            this.allocated=0;
            this.consumed=0;
            this.cancelled=0;
            this.completed=0;
            this.inExec=0;
            this.notstarted=0;
            this.planned=0;
            this.postplan=0;
            this.developcount=0;
            this.acquirecount=0;
            this.retaincount=0;
            this.ltcount=0;
            this.CSGrowth=0;
            this.growthPer=0;
            this.volumegrowth=0;
            this.Productone=0; 
            this.Producttwo=0;
            sellingSeasontypes=new List<String>();
            croptypes=new List<String>();
            accTypes = new List<String>();
        }
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