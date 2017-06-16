@isTest
private class testpreventgitsnapshotdelete {
    
    static testmethod void testPreventsnapDel(){
    
        copado__Git_Repository__c repoRecord = new copado__Git_Repository__c();
        repoRecord.Name = 'test';
        repoRecord.copado__URI__c = 'www.test.com';
        insert repoRecord;
        
        copado__Org__c orgRecord = new copado__Org__c();
        orgRecord.Name = 'testing';
        insert orgRecord;
        
        copado__Git_Backup__c snapRecord = new copado__Git_Backup__c();
        snapRecord.Name = 'testsnap';
        snapRecord.copado__Frequency__c = 'None';
        snapRecord.copado__Org__c = orgRecord.id;
        snapRecord.copado__Git_Repository__c = repoRecord.id;
        
        insert snapRecord;
         
        try{
            delete snapRecord;
        }catch(DMLexception e){
            system.assert(e.getMessage().contains('Git snapshot Cannot be deleted'),'Git snapshot Cannot be deleted');                      
        }
    }
}