/*********************************************************************************************
* @author : Cognizant Technology Solutions.
* @version : 1.0
* @Description : This is the code to display data for RADL graph.
1) Get ProgramId , Dealer Id 
2) Query AccountProgram 
3) Query Account for that accountprogram
4) Calculate radl count
*********************************************************************************************/
public class Frontier_ProgramRadlGraphController {
    @AuraEnabled
    public static String getGraphdata(Id programId, Id dealerId){
        System.debug('Inside Radl Graph' + programId);
        Integer accountcount;
        List<Account_Program__c> accPgmList = new List<Account_Program__c>();
        List<Account_Business_Role__c> accpgmRadl = new List<Account_Business_Role__c>();
        List<Account> groweraccList = new List<Account>();
        ProgramRadlWrapper pgmradlWrp = new ProgramRadlWrapper();
        Set<String> radlClassSet = new Set<String>();
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> growerIdSet = new Set<Id>();
        Schema.DescribeFieldResult fieldResult = Account_Business_Role__c.Service_Level_Class_Descr__c.getDescribe();
        List<Schema.PicklistEntry>  radlClass = fieldResult.getPicklistValues();
        
        if(!radlClass.isEmpty()){
            for(integer i=0;i<radlClass.Size();i++){
                radlClassSet.add(radlClass[i].getvalue());                        
            }
        }
        if(dealerId != null){
            System.debug('dealer' + dealerId);
            groweraccList = [SELECT Id, Dealer_SFID__c FROM Account WHERE Dealer_SFID__c = :dealerId];
            if(!groweraccList.isEmpty()){
                System.debug('groweraccList' + groweraccList);
                for(Account groweracc : groweraccList){
                    growerIdSet.add(groweracc.Id);
                }
            }
        }
        if(programId != null){
            if(!growerIdSet.isEmpty()){
              accPgmList = [SELECT Account_SFID__c FROM Account_Program__c WHERE Account_SFID__r.Id IN :growerIdSet AND  Program_SFID__c = :programId];  
            }
            else if(dealerId == null){
              accPgmList = [SELECT Account_SFID__c FROM Account_Program__c WHERE Account_SFID__r.Id != null AND  Program_SFID__c = :programId];   
            }
            System.debug('Inside pgm not null' + accPgmList);
        }
        else{
            if(!growerIdSet.isEmpty()){
               accPgmList = [SELECT Account_SFID__c FROM Account_Program__c WHERE Account_SFID__r.Id IN :growerIdSet  AND  Program_SFID__c != null]; 
            }
            else if(dealerId == null){
               accPgmList = [SELECT Account_SFID__c FROM Account_Program__c WHERE Account_SFID__r.Id != null AND  Program_SFID__c != null]; 
            }
            
            System.debug('Inside pgm null' + accPgmList);
        }
        for(Account_Program__c accPgm : accPgmList){
            accIdSet.add(accPgm.Account_SFID__c);
            System.debug('accPgm - accIdSet' + accIdSet);
        }
        accpgmRadl  = [SELECT Id, Service_Level_Class_Descr__c, Account_SFID__c FROM Account_Business_Role__c WHERE Account_SFID__c = :accIdSet AND Service_Level_Class_Descr__c!=null];
        if(!accpgmRadl.isEmpty()){
            System.debug('accPgm - accpgmRadl' + accpgmRadl);
            for(Account_Business_Role__c accradl : accpgmRadl){
                if(radlClassSet.contains(accradl.Service_Level_Class_Descr__c)){
                    System.debug('Inside business');
                    if(pgmradlWrp.accPgmRadlMap.containsKey(accradl.Service_Level_Class_Descr__c)){
                        accountcount = (pgmradlWrp.accPgmRadlMap.get(accradl.Service_Level_Class_Descr__c)) + 1;
                        pgmradlWrp.accPgmRadlMap.put(accradl.Service_Level_Class_Descr__c,accountcount);
                        System.debug('Inside if' + pgmradlWrp.accPgmRadlMap);
                    }
                    else{
                        accountcount = 1;
                        pgmradlWrp.accPgmRadlMap.put(accradl.Service_Level_Class_Descr__c,accountcount);
                        System.debug('Inside else' + pgmradlWrp.accPgmRadlMap);
                    }
                }
            }
        }
       if(pgmradlWrp!=null){
             System.debug('Inside return' + pgmradlWrp);
            return JSON.serialize(pgmradlWrp);  
        }
        else{
            return null; 
        }
    }
    
    public class ProgramRadlWrapper{ 
        public Map<String,Integer> accPgmRadlMap {get;set;}
        
        public ProgramRadlWrapper(){
            accPgmRadlMap = new Map<String,Integer>();
        }
    }
}