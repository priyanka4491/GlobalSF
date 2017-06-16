public class Frontier_SalesREP_MyPrograms {
	public static void getMyPrograms()
    {
        Id salesRepId;
        salesRepId = UserInfo.getUserId();
        salesRepProgramsWrapper programData = new salesRepProgramsWrapper();
        Map<Id, Integer> mapAllocated = new Map<Id, Integer>();
        Map<Id, Integer> mapAvailable = new Map<Id, Integer>();
        Map<Id, Integer> mapConsumed = new Map<Id, Integer>();
        Map<Id, Integer> mapCancelled = new Map<Id, Integer>();
        Map<Id, Integer> mapCompleted = new Map<Id, Integer>();
        Map<Id, Integer> mapPlanned = new Map<Id, Integer>();
        Map<Id, Integer> mapPostPlanned = new Map<Id, Integer>();
        Map<Id, Integer> mapInExecution = new Map<Id, Integer>();
        Map<Id, Integer> mapNotStarted = new Map<Id, Integer>();
        Map<Id, Integer> mapAcquire = new Map<Id, Integer>();
        Map<Id, Integer> mapRetain = new Map<Id, Integer>();
        Map<Id, Integer> mapLightTouch = new Map<Id, Integer>();
        Map<Id, Integer> mapDevelop = new Map<Id, Integer>();
        System.debug('salesRepId'+salesRepId);
        Set <Id> programId = new Set<Id>();
        List<programWrapper> listProgWrapper = new List<programWrapper>();
        List<Account_Program__c> salesRepPrograms = new List<Account_Program__c>();
        try{
        	salesRepPrograms = [SELECT Id, Program_SFID__c, CreatedById,  Account_SFID__c, Cancel_Reason__c, Execution_Status__c, Planning_Status__c, 
                            Service_Level_Class_Descr__c From Account_Program__c Where CreatedById =: salesRepId];
        	for(Account_Program__c accProg : salesRepPrograms)
            {
                if(!mapAcquire.containsKey(accProg.Program_SFID__c))
                {
                    if(accProg.Service_Level_Class_Descr__c == 'Acquire')
                    {
                    	mapAcquire.put(accProg.Program_SFID__c, 1);                        
                    }
                }else if(mapAcquire.containsKey(accProg.Program_SFID__c))
                {
					if(accProg.Service_Level_Class_Descr__c == 'Acquire')
                    {
                    	mapAcquire.put(accProg.Program_SFID__c, (mapAcquire.get(accProg.Program_SFID__c) +1));
                    }
                }
                if(!mapRetain.containsKey(accProg.Program_SFID__c))
                {
                    if(accProg.Service_Level_Class_Descr__c == 'Retain')
                    {
                    	mapRetain.put(accProg.Program_SFID__c, 1);                        
                    }
                }else if(mapRetain.containsKey(accProg.Program_SFID__c))
                {
					if(accProg.Service_Level_Class_Descr__c == 'Retain')
                    {
                    	mapRetain.put(accProg.Program_SFID__c, (mapRetain.get(accProg.Program_SFID__c) +1));
                    }                    
                }
                if(!mapLightTouch.containsKey(accProg.Program_SFID__c))
                {
                    if(accProg.Service_Level_Class_Descr__c == 'LightTouch')
                    {
                    	mapLightTouch.put(accProg.Program_SFID__c, 1);                        
                    }
                }else if(mapLightTouch.containsKey(accProg.Program_SFID__c))
                {
					if(accProg.Service_Level_Class_Descr__c == 'LightTouch')
                    {
                    	mapLightTouch.put(accProg.Program_SFID__c, (mapLightTouch.get(accProg.Program_SFID__c) +1));
                    }                    
                }
                if(!mapDevelop.containsKey(accProg.Program_SFID__c))
                {
                    if(accProg.Service_Level_Class_Descr__c == 'Develop')
                    {
                    	mapDevelop.put(accProg.Program_SFID__c, 1);                        
                    }
                }else if(mapDevelop.containsKey(accProg.Program_SFID__c))
                {
					if(accProg.Service_Level_Class_Descr__c == 'Develop')
                    {
                    	mapDevelop.put(accProg.Program_SFID__c, (mapDevelop.get(accProg.Program_SFID__c) +1));
                    }                    
                }
             	if(!mapCancelled.containsKey(accProg.Program_SFID__c) && !mapAvailable.containsKey(accProg.Program_SFID__c))
                {
                    if(accProg.Execution_Status__c == 'Cancelled')
                    {
                        mapAvailable.put(accProg.Program_SFID__c, 1);
                    	mapCancelled.put(accProg.Program_SFID__c, 1);                        
                    }
                }else if(mapCancelled.containsKey(accProg.Program_SFID__c) && mapAvailable.containsKey(accProg.Program_SFID__c))
                {
                    if(accProg.Execution_Status__c == 'Cancelled')
                    {
                        mapAvailable.put(accProg.Program_SFID__c, (mapAvailable.get(accProg.Program_SFID__c) +1));
                    	mapCancelled.put(accProg.Program_SFID__c, (mapCancelled.get(accProg.Program_SFID__c) +1));
                    }
                }
                if(!mapCompleted.containsKey(accProg.Program_SFID__c) && !mapConsumed.containsKey(accProg.Program_SFID__c))   
                {
                    if(accProg.Execution_Status__c == 'Completed')
                    {
                        mapConsumed.put(accProg.Program_SFID__c, 1);
                        mapCompleted.put(accProg.Program_SFID__c, 1);
                    }
                }else if(mapCompleted.containsKey(accProg.Program_SFID__c) && mapConsumed.containsKey(accProg.Program_SFID__c))   
                {
                    if(accProg.Execution_Status__c == 'Completed')
                    {
                        mapConsumed.put(accProg.Program_SFID__c, (mapConsumed.get(accProg.Program_SFID__c) +1));
                        mapCompleted.put(accProg.Program_SFID__c, (mapCompleted.get(accProg.Program_SFID__c) +1));
                    }
                }
                if(!mapInExecution.containsKey(accProg.Program_SFID__c))   
                {
                    if(accProg.Execution_Status__c == 'In Execution')
                    {
                        mapInExecution.put(accProg.Program_SFID__c, 1);
                    }
                }else if(mapInExecution.containsKey(accProg.Program_SFID__c))
                {
                    if(accProg.Execution_Status__c == 'In Execution')
                    {
                        mapInExecution.put(accProg.Program_SFID__c, (mapInExecution.get(accProg.Program_SFID__c) +1));
                    }
                }
               if(!mapNotStarted.containsKey(accProg.Program_SFID__c))   
                {
                    if(accProg.Execution_Status__c == 'Not Started')
                    {
                        mapNotStarted.put(accProg.Program_SFID__c, 1);
                    }
                }else if(mapNotStarted.containsKey(accProg.Program_SFID__c))
                {
                    if(accProg.Execution_Status__c == 'Not Started')
                    {
                        mapNotStarted.put(accProg.Program_SFID__c, (mapNotStarted.get(accProg.Program_SFID__c) +1));
                    }
                }
                if(!mapPlanned.containsKey(accProg.Program_SFID__c))   
                {
                    if(accProg.Planning_Status__c == 'Planned')
                    {
                        mapPlanned.put(accProg.Program_SFID__c, 1);
                    }
                }else if(mapPlanned.containsKey(accProg.Program_SFID__c))
                {
                    if(accProg.Execution_Status__c == 'Planned')
                    {
                        mapPlanned.put(accProg.Program_SFID__c, (mapPlanned.get(accProg.Program_SFID__c) +1));
                    }
                }
                if(!mapPostPlanned.containsKey(accProg.Program_SFID__c))   
                {
                    if(accProg.Planning_Status__c == 'Post-Plan')
                    {
                        mapPostPlanned.put(accProg.Program_SFID__c, 1);
                    }
                }else if(mapPostPlanned.containsKey(accProg.Program_SFID__c))
                {
                    if(accProg.Planning_Status__c == 'Post-Plan')
                    {
                        mapPostPlanned.put(accProg.Program_SFID__c, (mapPostPlanned.get(accProg.Program_SFID__c) +1));
                    }
                }
            }
            for(Account_Program__c acProg : salesRepPrograms)
            {
                programWrapper pgw = new programWrapper();
                if(mapCompleted.containsKey(acProg.Program_SFID__c) || mapCancelled.containsKey(acProg.Program_SFID__c) || mapPlanned.containsKey(acProg.Program_SFID__c) || mapPostPlanned.containsKey(acProg.Program_SFID__c) || mapInExecution.containsKey(acProg.Program_SFID__c) || mapNotStarted.containsKey(acProg.Program_SFID__c))
                {
                    pgw.program = acProg.Program_SFID__c;
                	pgw.completed = (!mapCompleted.isEmpty() ? mapCompleted.get(acProg.Program_SFID__c) : 0);
                    pgw.cancelled = (!mapCancelled.isEmpty() ? mapCancelled.get(acProg.Program_SFID__c) : 0);
                    pgw.planned = (!mapPlanned.isEmpty() ? mapPlanned.get(acProg.Program_SFID__c) : 0);
                    pgw.postPlan = (!mapPostPlanned.isEmpty() ? mapPostPlanned.get(acProg.Program_SFID__c) : 0);
                    pgw.inExecution = (!mapInExecution.isEmpty() ? mapInExecution.get(acProg.Program_SFID__c) : 0);
                    pgw.notStarted = (!mapNotStarted.isEmpty() ? mapNotStarted.get(acProg.Program_SFID__c) : 0);
                    pgw.retain= (!mapRetain.isEmpty() ? mapRetain.get(acProg.Program_SFID__c) : 0);
                    pgw.acquire= (!mapAcquire.isEmpty() ? mapAcquire.get(acProg.Program_SFID__c) : 0);
                    pgw.develop= (!mapDevelop.isEmpty() ? mapDevelop.get(acProg.Program_SFID__c) : 0);
                    pgw.lightTouch= (!mapLightTouch.isEmpty() ? mapLightTouch.get(acProg.Program_SFID__c) : 0);   
                }                
                listProgWrapper.add(pgw);                
            }
            System.debug('listProgWrapper'+listProgWrapper);
            programData.programWrapperList.addAll(listProgWrapper);
            programData.totalPrograms = programId.size();
        }catch(Exception caught)
        {
            System.debug('Caught Exception'+caught);
        }		
    }
    class salesRepProgramsWrapper
    {
        public List<programWrapper> programWrapperList {get;set;}
        public Integer totalPrograms {get;set;}
    }
    class programWrapper
    {
        public String program {get;set;}
     	public Decimal available {get;set;}   
        public Decimal budget {get;set;}
        public Integer consumed {get;set;}
        public Integer allocated {get;set;}
        public Integer cancelled {get;set;}
        public Integer completed {get;set;}
        public Integer retain {get;set;}
        public Integer acquire {get;set;}
        public Integer develop {get;set;}
        public Integer lightTouch {get;set;}
        public Integer notStarted {get;set;}
        public Integer inExecution {get;set;}
        public Integer planned {get;set;}
        public Integer postPlan {get;set;}   
    }
}