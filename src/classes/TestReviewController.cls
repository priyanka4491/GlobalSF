public class TestReviewController {
@AuraEnabled
    public static List<Program__c> getPrograms(){
        List<Program__c> programList = new List<Program__c>();
        List<Account_Program__c> accPgmNewList = new List<Account_Program__c>();
        Map<Id,Id> pgmAccMap = new Map<Id,Id>();
        Set<Id> pgmIdSet = new Set<Id>();
        programList = [SELECT Id, Name FROM Program__c];
        if(programList.size()>0 && programList != null ){
            for(Program__c pgmIdList : programList){
                pgmIdSet.add(pgmIdList.Id);
        }
        }
        //String query = 'SELECT Id, Program__c, Account__c, Execution_Status__c FROM Account_Program__c Where Program__r.Id = :pgmIdSet';
        accPgmNewList = [SELECT Id, Program_SFID__c, Account_SFID__c, Execution_Status__c FROM Account_Program__c Where Program_SFID__r.Id = :pgmIdSet AND Execution_Status__c = 'New'];
        for(Account_Program__c accPgm : accPgmNewList){
          System.debug('Inside for');  
           pgmAccMap.put(accPgm.Program_SFID__c,accPgm.Account_SFID__c); 
        }
        return programList;
    }
}