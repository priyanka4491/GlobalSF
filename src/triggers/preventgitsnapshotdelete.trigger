trigger preventgitsnapshotdelete on copado__Git_Backup__c (before delete) {

    for(copado__Git_Backup__c snap : trigger.old){
    
        snap.adderror('Git snapshot Cannot be deleted');
        
    }

}