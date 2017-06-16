public with sharing class Frontier_ProgramPlanningController {    
    public static Frontier_SortDirection sortFields = new  Frontier_SortDirection();
    public static string triggerFields;
    public static List<String> accountList= new List<String>(); 
    
   @AuraEnabled 
    public static List<String> getPrograms(Integer pageNumber,Integer pageSize){       
        List<String> programList= new List<String>();
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
        List<Frontier_ProgramDetailWrapper> pgmListAfterSkip = new List<Frontier_ProgramDetailWrapper>();
        Map<Id,Frontier_ProgramDetailWrapper>  programDetailMap = Util.getProgramBudgetDetail(); 

        List<Frontier_ProgramDetailWrapper> programDetailWrapperList = new List<Frontier_ProgramDetailWrapper>();
        Set<Id> programIds = new Set<Id>();
        if(!programDetailMap.isEmpty()){
            
            
            Set<Id> programSetId = new Set<Id>();
            for(Account_Program__c accpgm : [SELECT Id,Program_SFID__r.Id,Planning_Status__c,Execution_Status__c,Program_SFID__r.Name,
                                                    Program_SFID__r.Available__c,Program_SFID__r.Allocated__c,Program_SFID__r.Budget__c,Program_SFID__r.Program_Coverage__c,
                                                    Program_SFID__r.Consumed__c,Program_SFID__r.CS_Growth__c,Program_SFID__r.Growth__c, Program_SFID__r.Planning_Status__c,
                         							Program_SFID__r.Volume_Growth__c,Program_SFID__r.Completed__c,Program_SFID__r.Cancelled__c,Program_SFID__r.Execution_Status__c,Program_SFID__r.Brand_Family__c,  
                                                    Service_Level_Class_Descr__c FROM Account_Program__c
                                             WHERE CreatedBy.Id =:Userinfo.getUserId() AND Submitted__c = false  AND Execution_status__c != 'Cancelled']){
                                 programSetId.add(accpgm.Program_SFID__r.Id);                
                                             }
            
            Map<Id,Program__c> programMap = new Map<Id,Program__c>([SELECT Id FROM Program__c WHERE Id IN:programSetId]);
            
           programIds.addAll(programMap.keySet());
            if(!programIds.isEmpty()){
                for(Id progId : programIds){
                    if(programDetailMap.containsKey(progId)){
                       programDetailWrapperList.add(programDetailMap.get(progId));
                    }                    
                }

            }   
            system.debug('programIds'+programIds+'programDetailMap'+programDetailMap.keyset());
        }
        
       for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < programDetailWrapperList.size();i++){   
                pgmListAfterSkip.add(programDetailWrapperList[i]);
       } 
            programList.add((String.valueOf(programDetailWrapperList.size())));
            programList.add((JSON.serialize(pgmListAfterSkip)));
            programList.add((JSON.serialize(programIds)));
        system.debug('programList'+programList);
        return programList;   
    }
            
    
    @AuraEnabled
    public static List<String> getProgramList(String progId,String dealerId){
 Set<String> growerSet = new Set<String>{'Grower','Dealer -  Grower Through Dealer'};
        Program__c program = new Program__c();
         List<String> progDetailList = new List<String>();
        List<Territory2> territoryList = new List<Territory2>();
        List<UserTerritory2Association> userTerritoryList = new List<UserTerritory2Association>();
        userTerritoryList = [SELECT Id, IsActive, RoleInTerritory2, Territory2Id, UserId FROM 
        UserTerritory2Association WHERE UserId =: UserInfo.getUserId()];
        if(!userTerritoryList.isEmpty()){
           territoryList = [SELECT Id, Name, DeveloperName, Division__c FROM 
               Territory2 WHERE Id =: userTerritoryList[0].Territory2Id];
        }


  if(!territoryList.isEmpty()){
        
        Id recordTypeId = Schema.SObjectType.Program__c.getRecordTypeInfosByName().get('Program').getRecordTypeId();
        String division = territoryList[0].Division__c;
		String programQuery = 'SELECT Id,Name,Available__c,Allocated__c,Consumed__c,(SELECT Id,Product_SFID__c,Product_SFID__r.Name FROM Product_Programs__r),Volume_Growth__c,Growth__c,CS_Growth__c,Program_Coverage__c';
                 programQuery +=' FROM Program__c WHERE recordtypeid =:recordTypeId AND Brand_Family__c =: division';
        system.debug('dealerId================='+dealerId);
        if(dealerId != 'Null'){
            programQuery += ' AND Account_Type__c IN:growerSet';
        }
         programQuery += ' ORDER BY Createddate DESC';
        system.debug('programQuery'+programQuery);
        if(!territoryList.isEmpty()){
        List<Program__c> programList = Database.query(programQuery);
            system.debug('progId' +progId+programList[0].Id);
        if(!programList.isEmpty()){
          progId = (progId != 'Null' ? progId : programList[0].Id);
        }
        system.debug('ProgId ==================>'+progId);
        if(programList.isEmpty()){
            programList = new List<Program__c>();
        }
        else{
            for(Integer i = 0 ; i < programList.size();i++){
                if(programList[i].Id == progId){                    
                        program = programList[i];
                        break;                    
                }
            }
            
        }
            
        progDetailList.add(JSON.serialize(programList));
        progDetailList.add(JSON.serialize(Util.getProgramDetail(progId)));                  
        progDetailList.add(getProducts());
       }
  }
        return progDetailList;
    }
    
     @AuraEnabled
    public static String getProducts(){
        List<AccountProductWrapper> accountProductWrapperList = new List<AccountProductWrapper>();
        Set<Id> productIds = new Set<Id>();
 		Map<Id,PricebookEntry> productPriceBookMap = new Map<Id,PricebookEntry>();
        for(Product2 prod : [SELECT Id,Name FROM Product2]){
            productIds.add(prod.Id);
        }
        if(!productIds.isEmpty()){
                for(PricebookEntry  pricebook : [SELECT Id,Product2Id,UnitPrice FROM PricebookEntry WHERE Pricebook2.isStandard = true AND Product2Id IN :productIds]){
               		productPriceBookMap.put(pricebook.Product2Id,pricebook);
                }
            }
        if(!productPriceBookMap.isEmpty()){
            for(Product2 prod : [SELECT Id,Name,ProductCode FROM Product2 WHERE Id IN:productPriceBookMap.keySet()]){
                    AccountProductWrapper accProdWrapper = new AccountProductWrapper();
                    accProdWrapper.productId = prod.Id;
                    accProdWrapper.price = (productPriceBookMap.containsKey(prod.Id) ? productPriceBookMap.get(prod.Id).UnitPrice : 0);
                    accProdWrapper.ProductCode = prod.ProductCode;
                    accountProductWrapperList.add(accProdWrapper);
            }
        }
        String products = (!accountProductWrapperList.isEmpty() ? JSON.serialize(accountProductWrapperList) : '');
        return products;
    }
    
     
    @AuraEnabled
    public static List<String> getProgramAccounts(Id programId,Integer pageSize,Integer pageNumber,String triggeredField,Boolean isInitialize,Boolean isPageChange){
        //List<String> accountList= new List<String>();
        System.debug('getAccountsProgram' + programId);
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize); 
        List<Account_Program__c> accountProgramList = new List<Account_Program__c>();
         List<Account_Business_Role__c> accountRecordsList = new List<Account_Business_Role__c>();
         List<AccountWrapper> allAccountBusinessList = new List<AccountWrapper>();
        List<AccountWrapper> accountListAfterSkip=new List<AccountWrapper>();
        accountProgramList = [SELECT Id,Account_SFID__c, Program_SFID__c, Program_SFID__r.Name,Program_SFID__r.Account_Type__c,Planning_Status__c,Account_SFID__r.Account_Global_Party_ID__c, Execution_Status__c  FROM Account_Program__c 
                              WHERE Account_SFID__r.Account_Global_Party_ID__c != null AND Program_SFID__c = :programId AND Submitted__c = false
                              AND  Execution_Status__c != 'Cancelled' AND CreatedBy.Id =: Userinfo.getUserId()];
        Set<Id> accId = new Set<Id>();
        if(!accountProgramList.isEmpty()){
            for(Account_Program__c accProgram :accountProgramList){
               accId.add(accProgram.Account_SFID__c);
            }
        }
        system.debug('accId'+accId);
        try{
            if(!isInitialize){ 
                if(triggeredField != Null && sortFields.AccName == triggeredField){
                    sortFields.AccName = triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');  
                }else if(triggeredField != Null && sortFields.Address == triggeredField){
                    sortFields.Address= triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
                }else if(triggeredField != Null && sortFields.AccRADL == triggeredField){
                    sortFields.AccRADL= triggeredField.split('-')[0]+'-'+(triggeredField.split('-')[1] == 'ASC'?'DESC':'ASC');
                }
            }else if(isInitialize){
                sortFields = new Frontier_SortDirection();               
            }
            system.debug('triggeredField=>'+triggeredField);
            triggerFields = triggeredField;
            String query = 'SELECT Account_SFID__c,Account_SFID__r.Name,SAP_ID__c,Service_Level_Class_Descr__c,Account_SFID__r.Account_Global_Party_ID__c,Role_Descr__c,Business_Unit_Descr__c,'
                                 +'(SELECT Parent_SFID__r.Parent_SFID__r.Id,Parent_SFID__r.Parent_SFID__r.Street_Addr__c,Parent_SFID__r.Parent_SFID__r.City_Name__c,'      
                                 +'Parent_SFID__r.Parent_SFID__r.State_Name__c,Parent_SFID__r.Parent_SFID__r.Country_Name__c,Parent_SFID__r.Role_Descr__c' 
                                 +' FROM Account_Communications__r'
                                 +' WHERE Archive_Ind__c =\'N\''+ ' AND  Parent_SFID__r.Archive_Ind__c =\'N\''+'AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c =\'N\''
                                 +' AND RecordType.DeveloperName = \'Account_Communication_Address_Role_Business_Role\'' +'AND  Parent_SFID__r.Role_Descr__c = \'Business\''
                                 +' LIMIT 1)'
                                 +' FROM Account_Business_Role__c'
                                 +' WHERE Account_SFID__r.Account_Global_Party_ID__c != null AND Archive_Ind__c = \'N\''+' AND Account_SFID__r.Archive_Ind__c = \'N\' AND   Account_SFID__c IN:accId';
             
           
            if(accountProgramList[0].Program_SFID__r.Account_Type__c == 'Grower' || String.valueof(accountProgramList[0].Program_SFID__r.Account_Type__c).replaceAll( '\\s+', '') =='Dealer-GrowerThroughDealer'){
                query += ' AND Role_Descr__c = \'Customer\'';
                query += ' AND Role_Category_Descr__c = \'Consumer\'';
                query += ' AND Business_Unit_Descr__c = \'Customer\'';
            }
            else if(accountProgramList[0].Program_SFID__r.Account_Type__c == 'Dealer' || String.valueof(accountProgramList[0].Program_SFID__r.Account_Type__c).replaceAll( '\\s+', '') == 'Dealer-Dealer'){
                query += ' AND Role_Descr__c = \'Partner\'';              
            } 
            system.debug('query'+query);
            accountRecordsList = Database.query(query);
            system.debug('accountRecordsList'+accountRecordsList);
            for(Account_Business_Role__c  ABR : accountRecordsList){
               
                   allAccountBusinessList.add(new AccountWrapper(ABR,false));
               }
                  if(triggeredField != null){ 
                       allAccountBusinessList.sort();
                   } 
               
               for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < allAccountBusinessList.size();i++){   
                        accountListAfterSkip.add(allAccountBusinessList[i]);
                }
                accountList.add((String.valueOf(accountRecordsList.size())));
                accountList.add((JSON.serialize(accountListAfterSkip))); 
                accountList.add(JSON.serialize(sortFields));
                system.debug('accountList Size==============>'+accountListAfterSkip);
            }
        catch(Exception e){
            System.debug('The following error has been occured' + e.getMessage()); 
        }
        return accountList;
        //return null;
    }
    @Auraenabled
    public static void submitProgram(String programIds){
        if(programIds != ''){
        Set<Id> programIdSet = (Set<Id>)JSON.deserialize(programIds, Set<Id>.class);
        
       List<Account_Program__c> accountProgramList = [SELECT Id,Account_SFID__c, Account_SFID__r.Account_Global_Party_ID__c,Program_SFID__c, Program_SFID__r.Name, Planning_Status__c, Execution_Status__c,Submitted__c  FROM Account_Program__c 
                               WHERE Program_SFID__c IN:programIdSet AND Account_SFID__r.Account_Global_Party_ID__c != null AND Submitted__c = false AND CreatedBy.Id =:Userinfo.getUserId()];
        if(accountProgramList.isEmpty()){
            accountProgramList = new list<Account_Program__c>();
        }
        else{
            for(Account_Program__c accPgm : accountProgramList){
               // accPgm.Execution_Status__c = 'In Execution';
               accPgm.Submitted__c = True;
            }
            try{
                update accountProgramList;
            }
            catch(Exception e){
                System.debug('Error occurred in updating the account program status to approved ==========>'+e.getMessage());
            }
        }
        }
    }
    
    @AuraEnabled
    public static List<String> getAccounts(String searchKey,String radlKey,Integer pageSize,Integer pageNumber,String progId,String dealerId){ 
        
        List<Territory2> territoryList = new List<Territory2>();
        List<UserTerritory2Association> userTerritoryList = new List<UserTerritory2Association>();
        userTerritoryList = [SELECT Id, IsActive, RoleInTerritory2, Territory2Id, UserId FROM 
        UserTerritory2Association WHERE UserId =: UserInfo.getUserId()];
        if(!userTerritoryList.isEmpty()){
           territoryList = [SELECT Id, Name, DeveloperName, Division__c FROM 
               Territory2 WHERE Id =: userTerritoryList[0].Territory2Id];
        }

        if(progId == null){
            progId = 'Null';
        }
        
        if(!territoryList.isEmpty()){
        String division = territoryList[0].Division__c;
		
        
        System.debug('searchKey'+searchKey+'radlKey'+radlKey);
 Set<String> growerSet = new Set<String>{'Grower','Dealer -  Grower Through Dealer'};
            List<Program__c> programDetails = new List<Program__c>();  
         Id recordTypeId =  Schema.SObjectType.Program__c.getRecordTypeInfosByName().get('Program').getRecordTypeId();
        String programQuery = 'SELECT Id,Name,Account_Type__c FROM Program__c WHERE recordtypeid =:recordTypeId AND Brand_Family__c =: division';
        Program__c programDetail;       
        
        
        if(dealerId != 'Null'){
             if(progId != '' && progId != 'Null'){
                 system.debug('Inside If ProgramId' +progId);
            programQuery += ' AND Account_Type__c IN:growerSet';
             }
        }
        if(progId != '' && progId != 'Null'){
                   system.debug('Inside If ProgramId' +progId);

                    programQuery += ' AND Id =:progId';            
        }
         programQuery += ' ORDER BY Createddate desc';
        system.debug('programQuery'+programQuery);
            programDetails = Database.query(programQuery);
        if(!programDetails.isEmpty()){
            programDetail = programDetails[0];
        }
       
            
        system.debug('programDetail----'+programDetail);
         progId = (progId != '' ? progId : programDetail.Id);
        Set<Id> approvedPrograms = new Set<Id>(); 
        Set<Id> unApprovedPrograms = new Set<Id>();
        for(Account_Program__c accPgm : [SELECT Id,Program_SFID__c,Account_SFID__c,Execution_Status__c, Submitted__c FROM Account_Program__c WHERE Program_SFID__c=:progId AND CreatedBy.Id =:Userinfo.getUserId()]){
            if(accPgm.Submitted__c == True  || accPgm.Execution_Status__c == 'Cancelled'){ 
                approvedPrograms.add(accPgm.Account_SFID__c);
            }
            else{
                unApprovedPrograms.add(accPgm.Account_SFID__c);
            }
        }
        system.debug('************'+approvedPrograms+'^^^^^^^^^^^'+unApprovedPrograms);
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize); 
        List<AccountWrapper> accountListAfterSkip=new List<AccountWrapper>();
        
        List<AccountWrapper> toBeApprovedAccounts = new List<AccountWrapper>();
        //List<String> accountList= new List<String>(); 
             
        string varsearchKey= '%'+searchKey+'%';
        
        String searchByRadl = radlKey;
        String whereCondition = '';
        Set<Id> accountIds = new Set<Id>();
        Set<Id> territoryaccIds = new Set<Id>();
        
        //Get Accounts of current user's territory from Util
        territoryaccIds = Util.getTerritoryAccountIds(); 
        System.debug('territoryaccIds' + territoryaccIds);
        
        String Query = 'SELECT Id,Account_SFID__c,Account_SFID__r.Name,Service_Level_Class_Descr__c,SAP_ID__c,Account_SFID__r.Account_Global_Party_ID__c,'                                
            +'Role_Descr__c,Business_Unit_Descr__c,' 
            +'(SELECT Source_System_ID__c FROM Account_Identifiers__r LIMIT 1)'
            +' ,(SELECT Parent_SFID__r.Parent_SFID__r.Id,Parent_SFID__r.Parent_SFID__r.Street_Addr__c,Parent_SFID__r.Parent_SFID__r.City_Name__c,'      
            +'Parent_SFID__r.Parent_SFID__r.State_Name__c,Parent_SFID__r.Parent_SFID__r.Country_Name__c,'   
            +'Parent_SFID__r.Role_Descr__c FROM Account_Communications__r'
            +' WHERE   Archive_Ind__c =\'N\''+ ' AND  Parent_SFID__r.Archive_Ind__c =\'N\''+'AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c =\'N\''
            +' AND   RecordType.DeveloperName = \'Account_Communication_Address_Role_Business_Role\'' +'AND  Parent_SFID__r.Role_Descr__c = \'Business\''
            +' LIMIT 1)'
            +' FROM    Account_Business_Role__c'
            +' WHERE Account_SFID__r.Account_Global_Party_ID__c != null AND Archive_Ind__c = \'N\''+' AND Account_SFID__r.Archive_Ind__c = \'N\'';
          //  +' AND  Service_Level_Class_Descr__c Like :varsearchKey AND Account_SFID__c NOT IN:approvedPrograms AND  Account_SFID__c NOT IN:unApprovedPrograms';
      
        
        
          List<Account_Business_Role__c> accountRecordsList = new  List<Account_Business_Role__c>();
         List<AccountWrapper> filteredAccountRecordsList = new  List<AccountWrapper>();
                      List<Account_Business_Role__c> approvedAccountRecordsList = new  List<Account_Business_Role__c>();
            List<Account_Business_Role__c> unApprovedAccountBusinessList;
           
            if(programDetail.Account_Type__c == 'Grower' || String.valueof(programDetail.Account_Type__c).replaceAll( '\\s+', '') =='Dealer-GrowerThroughDealer'){
                 
                whereCondition = ' AND Account_SFID__c NOT IN:approvedPrograms AND Account_SFID__c IN:unApprovedPrograms';             
                whereCondition += ' AND Role_Descr__c = \'Customer\'';
                whereCondition += ' AND Role_Category_Descr__c = \'Consumer\'';
                whereCondition += ' AND Business_Unit_Descr__c = \'Customer\'';
            }
            else if(programDetail.Account_Type__c == 'Dealer' || String.valueof(programDetail.Account_Type__c).replaceAll( '\\s+', '') == 'Dealer-Dealer'){
                whereCondition = ' AND Account_SFID__c NOT IN:approvedPrograms AND Account_SFID__c IN:unApprovedPrograms';
                whereCondition += ' AND Role_Descr__c = \'Partner\'';              
            }
        
         if(whereCondition == '' && dealerId != 'Null'){
            whereCondition = 'AND Account_SFID__c NOT IN:approvedPrograms AND Account_SFID__c NOT IN:unApprovedPrograms AND Account_SFID__r.Dealer_SFID__c =: dealerId AND Account_SFID__r.Name Like :varsearchKey'; 
        }
        else if(whereCondition != '' && dealerId != 'Null'){
            whereCondition += ' AND Account_SFID__r.Dealer_SFID__c =: dealerId';
        }
            
        if(searchByRadl != 'None') {
                     if(searchByRadl == 'UnKnown'){
                         String radl = null;
                         String UnknownRADL ='UnKnown';
                   		//whereCondition += ' AND Service_Level_Class_Descr__c = \''+radl+'\'';
                   		whereCondition += ' AND (Service_Level_Class_Descr__c = :radl OR Service_Level_Class_Descr__c = :UnknownRADL)';
                     }
                     else{
            			//whereCondition += ' AND Service_Level_Class_Descr__c =\''+searchByRadl+'\'';
            			whereCondition += ' AND Service_Level_Class_Descr__c Like :searchByRadl';
                     }
                }
        whereCondition += ' AND Account_SFID__r.Name Like :varsearchKey';
            if(!territoryaccIds.isEmpty()){
                //Get Accounts of current user's territory
                whereCondition += ' AND Account_SFID__c IN :territoryaccIds';
            
            system.debug('@@@@@@@@@'+Query+whereCondition);
                for(Account_Business_Role__c accountBusinessRole : Database.query(Query+whereCondition+' LIMIT 40000')){
                    toBeApprovedAccounts.add(new AccountWrapper(accountBusinessRole,true)); 
                    
                    accountIds.add(accountBusinessRole.Account_SFID__c);
                    if((accountBusinessRole.Service_Level_Class_Descr__c != null && searchByRadl != 'None' && String.valueof(accountBusinessRole.Service_Level_Class_Descr__c).contains(searchByRadl))
                      || ((searchKey != '') && searchKey.contains(accountBusinessRole.Account_SFID__r.Name))){
                     	accountRecordsList.add(accountBusinessRole);
                          system.debug('Un Approved With Search key==================');
                   }
                    else{
                        system.debug('Un Approved==================');
                        accountRecordsList.add(accountBusinessRole);
	                }
                   
                 }
    }
                      
     whereCondition = '';   
        if(programDetail.Account_Type__c == 'Grower' || String.valueof(programDetail.Account_Type__c).replaceAll( '\\s+', '') =='Dealer-GrowerThroughDealer'){
                whereCondition = 'AND Account_SFID__c NOT IN:approvedPrograms AND Account_SFID__c NOT IN:unApprovedPrograms AND Account_SFID__r.Name Like :varsearchKey'; 
            	whereCondition += ' AND Role_Descr__c = \'Customer\'';
                whereCondition += ' AND Role_Category_Descr__c = \'Consumer\'';
                whereCondition += ' AND Business_Unit_Descr__c = \'Customer\'';
        }
            else if(programDetail.Account_Type__c == 'Dealer' || String.valueof(programDetail.Account_Type__c).replaceAll( '\\s+', '') =='Dealer-Dealer'){
                              whereCondition = 'AND Account_SFID__c NOT IN:approvedPrograms AND Account_SFID__c NOT IN:unApprovedPrograms AND Account_SFID__r.Name Like :varsearchKey'; 
                whereCondition += ' AND Role_Descr__c = \'Partner\'';               
            }
        if(whereCondition == '' && dealerId != 'Null'){
            system.debug('dealerId');
            whereCondition = 'AND Account_SFID__c NOT IN:approvedPrograms AND Account_SFID__c NOT IN:unApprovedPrograms AND Account_SFID__r.Dealer_SFID__c =: dealerId AND Account_SFID__r.Name Like :varsearchKey'; 
        }
        else if(whereCondition != '' && dealerId != 'Null'){
            system.debug('dealerId'); 	
            whereCondition += ' AND Account_SFID__r.Dealer_SFID__c =: dealerId';
        }
            if(searchByRadl != 'None') {
                     if(searchByRadl == 'UnKnown'){
                         String UnknownRADL = 'Unknown';
                          String radl = null;
                   		//whereCondition += ' AND Service_Level_Class_Descr__c = \''+radl+'\'';
                   		whereCondition += ' AND (Service_Level_Class_Descr__c = :radl OR Service_Level_Class_Descr__c = :UnknownRADL)';
                     }
                     else{
            			//whereCondition += ' AND Service_Level_Class_Descr__c =\''+searchByRadl+'\'';
            			whereCondition += ' AND Service_Level_Class_Descr__c Like :searchByRadl';
                     }
                }
        	if(!territoryaccIds.isEmpty()){
                //Get Accounts of current user's territory
                whereCondition += ' AND Account_SFID__c IN :territoryaccIds';
            
            whereCondition += ' LIMIT 40000';
           system.debug('query-------'+Query+whereCondition);
                if(!toBeApprovedAccounts.isEmpty()){
        	filteredAccountRecordsList.addAll(toBeApprovedAccounts);
        }
            for(Account_Business_Role__c accountBusinessRole : Database.query(Query+whereCondition)){
                accountRecordsList.add(accountBusinessRole);
                filteredAccountRecordsList.add(new AccountWrapper(accountBusinessRole,true));
            }
            }
        system.debug('Account Records List============='+accountRecordsList.size());
        if(!accountRecordsList.isEmpty() && accountRecordsList.size() > 0){
            for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < accountRecordsList.size();i++){   
                if(!unApprovedPrograms.isEmpty()){
                    if(unApprovedPrograms.contains(accountRecordsList[i].Account_SFID__c)){
                        accountListAfterSkip.add(new AccountWrapper(accountRecordsList[i],true));
                    }
                    else{
                        accountListAfterSkip.add(new AccountWrapper(accountRecordsList[i],false));
                    }
                }
                    else{
                        accountListAfterSkip.add(new AccountWrapper(accountRecordsList[i],false));
                    }
                   
                    
                }
                
                
            
        }
            
            
           system.debug('To be approved accounts ================>'+toBeApprovedAccounts);
            accountList.add((String.valueOf(accountRecordsList.size())));
            accountList.add((JSON.serialize(accountListAfterSkip)));
            accountList.add((JSON.serialize(toBeApprovedAccounts)));
             accountList.add(JSON.serialize(filteredAccountRecordsList));
         Map<Id,PricebookEntry> productPriceBookMap = new Map<Id,PricebookEntry>();
            Map<Id,List<AccountProduct__c>> accountProductMap = new Map<Id,List<AccountProduct__c>>();
        if(!accountIds.isEmpty()){
            system.debug('accountIds'+accountIds);
            for(AccountProduct__c accProd : [SELECT Account_SFID__c,Qty__c,Product_SFID__c,Product_SFID__r.ProductCode,
                                             Charge_Type__c FROM AccountProduct__c WHERE Account_SFID__c IN: accountIds AND CreatedBy.Id =:Userinfo.getUserId()]){
                                                 if(!accountProductMap.containsKey(accProd.Product_SFID__c)){
                                                     accountProductMap.put(accProd.Product_SFID__c, new List<AccountProduct__c>{accProd});
                                                 }
                                                 else{
                                                     accountProductMap.get(accProd.Product_SFID__c).add(accProd);
                                                 }
             }
            if(!accountProductMap.isEmpty()){
                for(PricebookEntry  pricebook : [SELECT Id,Product2Id,UnitPrice FROM PricebookEntry WHERE Pricebook2.isStandard = true AND Product2Id IN :accountProductMap.keyset()]){
                    productPriceBookMap.put(pricebook.Product2Id,pricebook);
                    system.debug('pricebook'+pricebook);
                }
            }
        }
        
        if(!accountProductMap.isEmpty() && !productPriceBookMap.isEmpty()){
            system.debug('accountProductMap'+accountProductMap);
             List<AccountProductWrapper> accprodWrapperList = new List<AccountProductWrapper>();
            for(Id productId : accountProductMap.keySet()){
                for(AccountProduct__c accProduct : accountProductMap.get(productId)){
                    AccountProductWrapper accProdWrapper = new AccountProductWrapper();
                    accProdWrapper.accountId = accProduct.Account_SFID__c;
                    accProdWrapper.productId = productId;
                    accProdWrapper.Qty = accProduct.Qty__c;
                    accProdWrapper.price = (productPriceBookMap.containsKey(productId) ? productPriceBookMap.get(productId).UnitPrice : 0);
                   accProdWrapper.ProductCode = accProduct.Product_SFID__r.ProductCode;
                    accProdWrapper.chargeType = accProduct.Charge_Type__c;
                    accprodWrapperList.add(accProdWrapper);
                }
            }
            if(!accprodWrapperList.isEmpty()){
                accountList.add(JSON.serialize(accprodWrapperList));
            }
        } 
        }
        return accountList;
    }
   
    // To be used in future for the program submission. 
    @AuraEnabled
    public static void getSubmitPrograms(List<Id> ProgramId){
       system.debug('ProgramId'+ProgramId);
        List<Account_Program__c> accProgramList = new List<Account_Program__c>();
        List<Account_Program__c> accPgmList = new List<Account_Program__c>();
        accProgramList = [SELECT Id,Program_SFID__c,Account_SFID__c,Execution_Status__c,Planning_Status__c,Submitted__c FROM Account_Program__c WHERE Program_SFID__c IN: ProgramId AND CreatedBy.Id =:Userinfo.getUserId()];
        try{
        if(!accProgramList.isEmpty()){
            for(Account_Program__c accPgm :accProgramList){
                //accPgm.Execution_Status__c ='In Execution';
                //accPgm.Planning_Status__c ='Post-Plan';
                accPgm.Submitted__c = True;
                accPgmList.add(accPgm);
            }
        }
        update accPgmList;
        }
        catch(Exception e){
                            System.debug('Exception Occured'+e.getMessage());
                        }
    }
    
    @AuraEnabled
    public static void assignProgram(String progId,String accounts,String accountIdsToDelete,String product){
        try{
        system.debug('ProgId with accounts-----------'+progId+'--------------'+accountIdsToDelete+'accounts---------'+accounts);
        List<AccountWrapper> accountWrapperList = new List<AccountWrapper>();
        List<AccountProductWrapper> productList = new List<AccountProductWrapper>();
        Set<String> accountsToDeleteIds = new Set<String>();
        List<Account_Program__c> accountprogramDeleteList = new List<Account_Program__c>();
        List<Account_Program__c> accountProgram = new List<Account_Program__c>();
        if(product != 'null'){
            String result = product.replaceAll('\\[', '').replaceAll('\\]', '');

                       
            List<AccountProduct__c> accountProducts = new List<AccountProduct__c>();
            system.debug('product--------------'+product);
            productList = (List<AccountProductWrapper>)JSON.deserialize('['+result+']', List<AccountProductWrapper>.class);
            system.debug('productList--------------'+result);
            if(!productList.isEmpty()){
                for(AccountProductWrapper accProduct : productList){
                    accountProducts.add(new AccountProduct__c(Account_SFID__c = accProduct.accountId,Product_SFID__c = accProduct.productId,
                                                             Charge_Type__c = accProduct.ChargeType,Qty__c = accProduct.Qty));
                }
            }
            if(!accountProducts.isEmpty()){
                insert accountProducts;
            }
        }
        
        if(accounts != 'null'){
            accountWrapperList = (List<AccountWrapper>)JSON.deserialize(accounts, List<AccountWrapper>.class);
            system.debug('accountsaccountsaccounts'+accountWrapperList);
        }
        if(accountIdsToDelete != 'null' &&  accountIdsToDelete.length() > 2){
            if(!accountIdsToDelete.contains(',')){
                accountsToDeleteIds.add(accountIdsToDelete.substring(2,accountIdsToDelete.length()-2));
            }
            else{
            for(String accountId : (Set<Id>)JSON.deserialize(accountIdsToDelete,Set<Id>.class)){           
                accountsToDeleteIds.add(accountId);
                }
            }
            system.debug('accountsToDeleteIds========>'+accountsToDeleteIds);
            if(!accountsToDeleteIds.isEmpty()){  
                try{
                List<Account_Program__c> accountPrograms =  [SELECT Id FROM Account_Program__c WHERE Account_SFID__c IN:accountsToDeleteIds AND Program_SFID__c =:progId AND CreatedBy.Id =:Userinfo.getUserId()];  
                    if(!accountPrograms.isEmpty()){
                        delete accountPrograms;
                    }
                }
                catch(Exception e){
                    system.debug('Detatch Account From Program'+e.getMessage());
                }
            }
              
        }
       
        
        Set<Id> accountIds = new Set<Id>();
        Set<Id> programAccountIds = new Set<Id>();        
                    if(!accountWrapperList.isEmpty()){
                        for(AccountWrapper acc : accountWrapperList){
                            accountIds.add(acc.accId);
                        }
                    }
       
        List<Account_Program__c> accountprogramList = [SELECT Program_SFID__c,Account_SFID__c FROM Account_Program__c WHERE Program_SFID__c =:progId 
                                                       AND Account_SFID__c IN:accountIds AND CreatedBy.Id =:Userinfo.getUserId()];
      
        if(!accountprogramList.isEmpty()){
            for(Account_Program__c accProg : accountprogramList){
                programAccountIds.add(accProg.Account_SFID__c);                 
            }
        }
         if(!accountWrapperList.isEmpty()){             
                        for(AccountWrapper acc : accountWrapperList){
                            system.debug('accaccacc'+acc);
                            if(!programAccountIds.isEmpty() && !programAccountIds.contains(acc.accId)){
                                accountProgram.add(new Account_Program__c(Program_SFID__c = progId,Account_SFID__c = acc.accId,Planning_Status__c = 'Planned',Execution_Status__c = 'Not Started',Service_Level_Class_Descr__c = acc.serviceLevelDesc));
                            }
                            else if(programAccountIds.isEmpty()){
                                accountProgram.add(new Account_Program__c(Program_SFID__c = progId,Account_SFID__c = acc.accId,Planning_Status__c = 'Planned',Execution_Status__c = 'Not Started',Service_Level_Class_Descr__c = acc.serviceLevelDesc));

                            }
                        }
                    }
                    if(!accountProgram.isEmpty()){
                        system.debug('accountProgram to insert'+accountProgram);
                        try{
                         insert accountProgram;
                        }
                        catch(Exception e){
                            System.debug('Exception Occured'+e.getMessage());
                        }
                    }
        }catch(Exception e){System.debug('exception'+e);}
    }
    @AuraEnabled
    public static void removeAccountFromProgram(String progId,String accountId){
    List<Account_Program__c> accountProgram = [SELECT Id FROM Account_Program__c WHERE Account_SFID__c =:accountId AND Program_SFID__c =:progId AND CreatedBy.Id =:Userinfo.getUserId()];
        if(!accountProgram.isEmpty()){
            try{
             Delete accountProgram;
            }
            catch(Exception e){
                System.debug('Error occure while detaching account from a program'+e.getMessage());
            }
        }
       
    }
    
    @AuraEnabled
    public static String getProgramDetailCount(String progId){    
        return JSON.serialize(Util.getProgramDetail(progId)); 
    }
    
    Public Class AccountWrapper implements Comparable {      
        
        public String Name{get;set;}
        public String accId{get;set;}
        public Account_Business_Role__c accountBusinessRole{get;set;}
        
        public String serviceLevelDesc{get;set;}  
        public String roleDesc{get;set;}
        public String sapId{get;set;} 
        
        public String accCommu{get;set;}
        public String streetAddress{get;set;}
        public String cityName{get;set;}
        public String stateName{get;set;}
        public String countryName{get;set;}
        public Boolean isSelected {get;set;}
        public Id Id {get;set;}
        
        public Account_Communication__c accountCommunication {get;set;}
        
        public AccountWrapper(Account_Business_Role__c businessRole,Boolean selected)
        {
            this.Id = businessRole.Id;
            this.isSelected = selected;            
            this.Name=businessRole.Account_SFID__r.Name;
            this.accId = businessRole.Account_SFID__c;            
            this.serviceLevelDesc=businessRole.Service_Level_Class_Descr__c;
            this.roleDesc=businessRole.Role_Descr__c;
            this.sapId=businessRole.SAP_ID__C;
            this.accountCommunication = (businessRole.Account_Communications__r.isEmpty() ? Null : businessRole.Account_Communications__r[0] );
            this.accCommu= (businessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.Id);
            this.streetAddress=(businessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.Street_Addr__c);
            this.cityName=(businessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.City_Name__c);
            this.stateName=(businessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.State_Name__c);
            this.countryName=(businessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.Country_Name__c);
        }
        
        //Implemntation of CompareTo for sorting AccountProgram Records
        public Integer compareTo(Object compareTo) {
            AccountWrapper compareToEmp = (AccountWrapper)compareTo;
            system.debug('CompareTo=>'+Name );
            if(triggerFields.split('-')[0] == 'Account_SFID__r.Name' && triggerFields.split('-')[1] == 'ASC'){
                if (Name == compareToEmp.Name) return 0;
                if (Name > compareToEmp.Name) return 1;
            }else if(triggerFields.split('-')[0] == 'Account_SFID__r.Name' && triggerFields.split('-')[1] == 'DESC'){
                if (Name == compareToEmp.Name) return 0;
                if (Name < compareToEmp.Name) return 1;
            }else if(triggerFields.split('-')[0] == 'Account.City' && triggerFields.split('-')[1] == 'ASC'){
                if (cityName == compareToEmp.cityName) return 0;
                if (cityName > compareToEmp.cityName) return 1;
            }else if(triggerFields.split('-')[0] == 'Account.City' && triggerFields.split('-')[1] == 'DESC'){
                if (cityName == compareToEmp.cityName) return 0;
                if (cityName < compareToEmp.cityName) return 1;
            }else if(triggerFields.split('-')[0] == 'Service_Level_Class_Descr__c' && triggerFields.split('-')[1] == 'ASC'){
                if (serviceLevelDesc == compareToEmp.serviceLevelDesc) return 0;
                if (serviceLevelDesc> compareToEmp.serviceLevelDesc) return 1;
            }else if(triggerFields.split('-')[0] == 'Service_Level_Class_Descr__c' && triggerFields.split('-')[1] == 'DESC'){
                if (serviceLevelDesc == compareToEmp.serviceLevelDesc) return 0;
                if (serviceLevelDesc < compareToEmp.serviceLevelDesc) return 1;
            }
            return -1;        
        }          
    }
    
   
    public class AccountProductWrapper{
        public Decimal Qty {get;set;}
        public string ProductCode {get;set;}        
        public String productId {get;set;}        
        public Decimal price {get;set;}        
        public string chargeType {get;set;}
        public String accountId {get;set;}
        public AccountProductWrapper(){
            this.price = 0;
            this.accountId = null;
            this.productId = null;
            this.Qty = null;
            this.ProductCode = null;
            this.chargeType = null;
        }
    }
}