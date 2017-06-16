public class Frontier_AccountProgramClass{
    public static Map<Id,Set<Id>> accountprogramMap;
    public static Set<Id> accountIds;
    public static List<Task> programActivityTasks = new List<Task>();
    // public static Set<Id> accountIds = new Set<Id>();
    // public static Set<Id> programIds = new Set<Id>();
    public static List<Program_Activity__c> programActivityList;
    public static Set<Id> completedProgramIds;
    public static void AssociateProgramActivities(List<Account_Program__c> accountPrograms,Map<Id,Account_Program__c> accountProgramOldMap,String triggerContext){
        accountprogramMap = new Map<Id,Set<Id>>();
        completedProgramIds = new Set<Id>();
        programActivityTasks = new List<Task>();
        accountIds = new Set<Id>();
        List<program__c> programList = new List<program__c>();
        for(Account_Program__c accountProgram : accountPrograms){
            if(!accountProgramOldMap.isEmpty() && ((triggerContext == 'isUpdate' && accountProgramOldMap.get(accountProgram.Id).Submitted__c != accountProgram.Submitted__c) || (triggerContext == 'isDelete')))
                if(accountProgram.Submitted__c){
                    if(!accountProgramMap.containsKey(accountProgram.Program_SFID__c)){
                        accountProgramMap.put(accountProgram.Program_SFID__c,new Set<Id>{accountProgram.Account_SFID__c});
                    }
                    else{
                        accountProgramMap.get(accountProgram.Program_SFID__c).add(accountProgram.Account_SFID__c);
                    }
                    accountIds.add(accountProgram.Account_SFID__c);
                 }                  

            else if(accountProgram.Execution_Status__c == 'Completed'){
                completedProgramIds.add(accountProgram.Program_SFID__c);
            }
        }
        
        if(triggerContext == 'isUpdate'){
            if(!accountProgramMap.isEmpty()){
                for(Program_Activity__c programActivity : [SELECT Id,Name,Phase__c,Activity_Type__c,Program_SFID__c,Status__c,Touchpoint_type__c FROM Program_Activity__c WHERE Program_SFID__c IN:accountProgramMap.keyset()]){
                    for(Id accId : accountProgramMap.get(programActivity.Program_SFID__c)){
                    programActivityTasks.add(new Task(Phase__c = programActivity.Phase__c,Status = 'Not Scheduled',Program_SFID__c = programActivity.Program_SFID__c,Type = programActivity.Activity_Type__c,
                                                      Subject = programActivity.Name,Program_Activity_SFID__c = programActivity.Id, WhatId = accId));
                    }                    
                }
                
            }
            programList = [SELECT Id,Allocated__c,Available__c,Consumed__c,Budget__c FROM Program__c];
            if(!programList.isEmpty()){
                
                for(program__c prog : programList){
                    if(!accountProgramMap.isEmpty() && accountProgramMap.containskey(prog.Id)){
                        prog.Allocated__c = (prog.Allocated__c == null ? 1 : prog.Allocated__c + 1);
                        prog.Budget__c =    (prog.Budget__c == null ? 0 : prog.Budget__c);
                        prog.Available__c =   prog.Available__c - prog.Allocated__c;
                        prog.Consumed__c = (prog.Consumed__c == null ? 0 : prog.Consumed__c);
                    }                    
                    else if(!completedProgramIds.isEmpty() && completedProgramIds.contains(prog.Id)){
                        prog.Allocated__c = ((prog.Allocated__c == null || prog.Allocated__c == 0) ? 0 :prog.Allocated__c - 1);
                        //prog.Budget__c =     (prog.Budget__c == null ? 0 : prog.Budget__c);
                        // prog.Available__c =  prog.Budget__c - prog.Allocated__c;
                        prog.Consumed__c = (prog.Consumed__c == null ? 0 : prog.Consumed__c);
                        prog.Consumed__c = prog.Consumed__c + 1;
                    }
                }
                
            }
        } 
        else if(triggerContext == 'isDelete'){
            Set<Id> programActivityIds = new Set<Id>();
            if(!accountProgramMap.isEmpty()){
                for(Program_Activity__c progActivity : [SELECT Id,Name,Phase__c,Program_SFID__c,Status__c FROM Program_Activity__c 
                                                        WHERE Program_SFID__c IN:accountProgramMap.keyset()]){
                                                            programActivityIds.add(progActivity.Id);
                                                        }
            }
            if(!programActivityIds.isEmpty()){
                programActivityTasks = [SELECT Id FROM Task WHERE Program_SFID__c IN:accountProgramMap.keyset() AND WhatId IN:accountIds
                                        AND Program_Activity_SFID__c IN:programActivityIds];
            }
            
            
            programList = [SELECT Id,Allocated__c,Available__c,Consumed__c,Budget__c FROM Program__c];
            if(!programList.isEmpty()){
                for(program__c prog : programList){
                    if(!accountProgramMap.isEmpty() && accountProgramMap.containsKey(prog.Id)){
                        prog.Allocated__c = ((prog.Allocated__c == null || prog.Allocated__c == 0) ? 0 :prog.Allocated__c - 1);
                        prog.Budget__c =     (prog.Budget__c == null ? 0 : prog.Budget__c);
                        prog.Available__c =  prog.Budget__c - prog.Allocated__c;
                        prog.Consumed__c = (prog.Consumed__c == null ? 1 : prog.Consumed__c);                        
                    }
                    else if(!completedProgramIds.isEmpty() && completedProgramIds.contains(prog.Id)){
                        prog.Consumed__c = (prog.Consumed__c == 0 ? 0 : prog.Consumed__c - 1);
                    }
                }
            }
        }
        
        
        if(!programActivityTasks.isEmpty()){ 
            try{
                if(triggerContext == 'isUpdate'){
                    insert programActivityTasks;
                }
                else if(triggerContext == 'isDelete'){
                    delete programActivityTasks;
                }
            }
            catch(Exception e){
                System.debug('Exception Occured on '+triggerContext+'with the following message'+e.getMessage());
            }
        }
        if(!programList.isEmpty()){
            try {
                update programList;
            }               
            catch(Exception e){
                System.debug('Exception Occured on updating the program with the following message'+e.getMessage());
            }
        }
    }
}