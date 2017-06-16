public class Frontier_DealerDashboardController {
    
     @AuraEnabled
    public static String getDealersList(Integer pageNumber,Integer pageSize,String crop, String season, String accType, Integer visit){ 
		System.debug('crop'+crop +' '+accType+' '+visit);
        System.debug('season'+season);
        List<Account_Business_Role__c> accpgmRadl =  new List<Account_Business_Role__c>();
        List<Account_Business_Role__c> accbussinessRoleList =  new List<Account_Business_Role__c>();
        List<Touchpoint__c> touchpointList = new List<Touchpoint__c>();
        List<Account> accountList = new List<Account>();
        List<Account> accountTouchList = new List<Account>(); 
        List<Account_Farming_Area__c> accFarmingList= new List<Account_Farming_Area__c>();
        List<Account_Sales__c> accSalesList= new List<Account_Sales__c>();
        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> accCropSeasonId = new Set<Id>();
        Map<Id,Integer> accTouchpointMap = new Map<Id,Integer>();
        Map<Id,String> accTouchpointDateMap = new Map<Id,String>();
        Integer noOfRecordsToSkip=(Integer.valueOf(pageNumber)-1)*Integer.valueOf(pageSize);
                List<DealerWrapper> dealerWrapperList = new List<DealerWrapper>();

        Set<Id> territoryaccIdSet = new Set<Id>();
        territoryaccIdSet = Util.getTerritoryAccountIds(); 
        try{
        //Get accounts having selected season and crop
        if(accType == 'Customer'){
            if(crop == 'All Crops'){
                accFarmingList = [SELECT Account_SFID__c,Area_Opportunity__c FROM Account_Farming_Area__c WHERE Selling_Season_Descr__c = :season AND Account_Business_Role_SFID__r.Role_Descr__c='Customer' AND Account_SFID__c =:territoryaccIdSet AND Year__c = 2016];
            }
            else{
                accFarmingList = [SELECT Account_SFID__c,Area_Opportunity__c FROM Account_Farming_Area__c WHERE Selling_Season_Descr__c = :season AND Area_Usage_Descr__c = :crop AND Account_Business_Role_SFID__r.Role_Descr__c='Customer' AND Account_SFID__c =:territoryaccIdSet AND Year__c = 2016];
            }
          
        	//accSalesList = [SELECT Account_SFID__c,Net_Sales_Qty__c FROM Account_Sales__c WHERE Selling_Season_Descr__c = :season AND Area_Usage_Descr__c = :crop AND Account_Business_Role_SFID__r.Role_Descr__c='Customer'];
            // accountList = [Select Id,(SELECT Id, Account_SFID__c, Account_SFID__r.Id, Completion_Date__c,Check__c FROM TouchPoints__r WHERE TouchPoint_Status__c = 'Completed') FROM Account WHERE Id IN (SELECT Account_SFID__c FROM Account_Farming_Area__c WHERE Selling_Season_Descr__c = :season AND Area_Usage_Descr__c = :crop AND Account_Business_Role_SFID__r.Role_Descr__c='Customer')];
         if(!accFarmingList.isEmpty()){
            for(Account_Farming_Area__c accFarming : accFarmingList){
                accCropSeasonId.add(accFarming.Account_SFID__c);
                System.debug('accCropSeasonId' + accCropSeasonId);
            }
        }
        }
        if(accType == 'Partner'){
            if(crop == 'All Crops'){
               accSalesList = [SELECT Account_SFID__c,Net_Sales_Qty__c,Opportunity__c FROM Account_Sales__c WHERE Selling_Season_Descr__c = :season  AND Account_Business_Role_SFID__r.Role_Descr__c='Partner' AND Account_SFID__c =:territoryaccIdSet AND Year__c = '2016'];  
            }
            else{
               accSalesList = [SELECT Account_SFID__c,Net_Sales_Qty__c,Opportunity__c FROM Account_Sales__c WHERE Selling_Season_Descr__c = :season AND Crop__c = :crop AND Account_Business_Role_SFID__r.Role_Descr__c='Partner' AND Account_SFID__c =:territoryaccIdSet AND Year__c = '2016'];  
            }
         
          if(!accSalesList.isEmpty()){
            for(Account_Sales__c accSales : accSalesList){
                accCropSeasonId.add(accSales.Account_SFID__c);
                System.debug('accCropSeasonId' + accCropSeasonId);
            }
        }
        } 
         if(!accCropSeasonId.isEmpty()){
            String queryString;
             queryString = 'SELECT Id,Name,(Select Id,Completion_Date__c From TouchPoints__r WHERE TouchPoint_Status__c = \'Completed\''
             			  +' AND TouchPointTypes__c =\'1:1 Visit\''    
                          +' AND Completion_Date__c = LAST_N_DAYS:'+ visit 
                          +') FROM Account Where Id =:accCropSeasonId';
            // accountList = [SELECT Id,Name,(Select Id,Completion_Date__c From TouchPoints__r WHERE TouchPoint_Status__c = 'Completed' AND TouchPointTypes__c ='1:1 Visit' AND Completion_Date__c = LAST_N_DAYS:+ visit) FROM Account Where Id =:accCropSeasonId];
             try{
                accountList = Database.query(queryString);
                 System.debug('accountList' + accountList);
             }
             catch(Exception e){
            System.debug('Exception Occured on accessing account Records'+e.getMessage());
        }
             for(Account account : accountList ){
                if(!account.TouchPoints__r.isEmpty()){
                    accTouchpointMap.put(account.Id,account.TouchPoints__r.size());
                    accountIdSet.add(account.Id);
                }
            }
             queryString = 'SELECT Id,Name,(Select Id,Completion_Date__c From TouchPoints__r WHERE TouchPoint_Status__c = \'Completed\''
             			  +' AND TouchPointTypes__c =\'1:1 Visit\''    
                          +' AND Completion_Date__c = LAST_N_DAYS:'+ visit
                 		  +' ORDER BY Completion_Date__c DESC LIMIT 1'
                          +') FROM Account Where Id =:accCropSeasonId';
            // accountList = [SELECT Id,Name,(Select Id,Completion_Date__c From TouchPoints__r WHERE TouchPoint_Status__c = 'Completed' AND TouchPointTypes__c ='1:1 Visit' AND Completion_Date__c = LAST_N_DAYS:+ visit) FROM Account Where Id =:accCropSeasonId];
             try{
                accountTouchList = Database.query(queryString); 
                 System.debug('accountTouchList' + accountTouchList);
             }
             catch(Exception e){
            System.debug('Exception Occured on accessing account Records'+e.getMessage());
        }
            //for(Account account : [SELECT Id,Name,(Select Id,Completion_Date__c From TouchPoints__r WHERE TouchPoint_Status__c = 'Completed' AND TouchPointTypes__c ='1:1 Visit' AND Completion_Date__c = LAST_N_DAYS:+visit ORDER BY Completion_Date__c DESC LIMIT 1) FROM Account Where Id =:accCropSeasonId ]){
             for(Account account :accountTouchList){
             if(!account.TouchPoints__r.isEmpty()){
                 DateTime completeddate = account.TouchPoints__r[0].Completion_Date__c;
                 System.debug('completeddate' + completeddate);
                 String myDate = DateTime.newinstance(completeddate.year(), completeddate.month(), completeddate.day()).format('dd-MM-YYYY');
                 System.debug('myDate' + myDate);
 				 //String sdate = String.valueOf(myDate);

                 //Date d = completeddate.date();
                 accTouchpointDateMap.put(account.Id,myDate);
                 System.debug('accTouchpointDateMap' + accTouchpointDateMap);
            }
            }
        }
        if(!accountIdSet.isEmpty()){
        accpgmRadl = [SELECT Id, Service_Level_Class_Descr__c ,Account_SFID__c,Account_SFID__r.Name FROM Account_Business_Role__c WHERE Service_Level_Class_Descr__c != null AND Account_SFID__c IN :accountIdSet AND Role_Descr__c= :accType];
        if(!accpgmRadl.isEmpty()){
            for(Integer i = noOfRecordsToSkip; i < noOfRecordsToSkip + Integer.valueOf(pageSize) && i < accpgmRadl.size();i++){
                
                accbussinessRoleList.add(accpgmRadl[i]);                 
            }
        }
        }
        set<DateTime> completionDateSet = new set<DateTime>();
       
        if(!accbussinessRoleList.isEmpty()){
            for(Account_Business_Role__c accbussrole:accbussinessRoleList){
                if(!accTouchpointMap.isEmpty() && accTouchpointMap.containskey(accbussrole.Account_SFID__c)){
                DealerWrapper dealerWrapperdetails = new DealerWrapper();
                dealerWrapperdetails.accountName = accbussrole.Account_SFID__r.Name;
                dealerWrapperdetails.accountRADL = accbussrole.Service_Level_Class_Descr__c; 
                dealerWrapperdetails.Count =  (accpgmRadl.size() > 0 ? accpgmRadl.size(): 0);
               
                dealerWrapperdetails.accTouchpointCount =accTouchpointMap.get(accbussrole.Account_SFID__c);
               
                if(!accTouchpointDateMap.isEmpty() && accTouchpointDateMap.containskey(accbussrole.Account_SFID__c)){
                    dealerWrapperdetails.accTouchpointDate =accTouchpointDateMap.get(accbussrole.Account_SFID__c);
                } 
                dealerWrapperList.add(dealerWrapperdetails);
                }  
            } 
            
        }
        else{
            dealerWrapperList = new List<DealerWrapper>();
            
        }
        }
        catch(Exception e){
            system.debug('The following Error occured' + e.getMessage());
        }
        //if(!dealerWrapperList.isEmpty()){
            return JSON.serialize(dealerWrapperList);
        //}
       
           
        
        
    }   
    
    public class DealerWrapper{ 
        public Integer Count {get;set;}
        public String accountName {get;set;}
        public String accountRADL {get;set;}
        public Integer accTouchpointCount {get;set;}
        public String accTouchpointDate {get;set;}

        
        
        public DealerWrapper(){
            
        }
    }

}