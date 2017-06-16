/* 
* @author : Cognizant technology solutions.
* @version : 1.0
* @objects Referenced : Account Business Role
* @Description : To carryout the average touchpoint of radl class in Account Dashboard 
*/
public class FR_VisitAvgController{
    @TestVisible private Static String Status = '';
    @AuraEnabled
    
    //Method to acquire average touchpoint for last 7 days and last 30 days
    public static String getLastData(Integer nDay){        
        Integer eventcount = 0;
        Integer accountcount = 0;
        String queryString;
        String eventPerRadl;
        Schema.DescribeFieldResult fieldResult;
        List<Schema.PicklistEntry> radlClass;
        Map<String,String> accountRadlMap = new Map<String,String>();
        Set<String> radlClassSet = new Set<String>();
        List<Account> accountRecordsList = new List<Account>();
        
         fieldResult = Account_Business_Role__c.Service_Level_Class_Descr__c.getDescribe();
         radlClass = fieldResult.getPicklistValues();
        
        if(!radlClass.isEmpty()){
            for(integer i=0;i<radlClass.Size();i++){
                radlClassSet.add(radlClass[i].getvalue());                        
            }
        }
        queryString = 'SELECT Id,(SELECT Id,WhatId FROM Events WHERE EndDateTime = LAST_N_DAYS:'+ nDay +'),(SELECT Service_Level_Class_Descr__c FROM Business_Roles__r WHERE Service_Level_Class_Descr__c != null LIMIT 1) FROM Account WHERE ID IN (select Account_SFID__c from Account_Business_Role__c where Service_Level_Class_Descr__c != null LIMIT 500) LIMIT 40000';        
        try{
        	accountRecordsList = database.query(queryString);
        }
        catch(Exception e){
            System.debug('Exception Occured on accessing account Records'+e.getMessage());
        }
        //Count Account and Events as per RADL
        if(!accountRecordsList.isEmpty()){
            for(Account acc: accountRecordsList){
                if(radlClassSet.contains(acc.Business_Roles__r[0].Service_Level_Class_Descr__c)){
                    if(accountRadlMap.containsKey(acc.Business_Roles__r[0].Service_Level_Class_Descr__c)) {                  
                        eventPerRadl = accountRadlMap.get(acc.Business_Roles__r[0].Service_Level_Class_Descr__c);
                        accountCount =  Integer.valueOf(eventPerRadl.split(',')[0]) + 1;
                        eventCount  =   Integer.valueOf(eventPerRadl.split(',')[1]) + acc.events.size();
                        accountRadlMap.put(acc.Business_Roles__r[0].Service_Level_Class_Descr__c ,accountCount + ','+eventCount);
                    } 
                    else {
                        accountCount = 1;
                        eventCount = acc.events.size();
                        accountRadlMap.put(Acc.Business_Roles__r[0].Service_Level_Class_Descr__c,accountCount + ',' + eventCount);
                    }
                }
            }           
        }
        
             
        RadlClassification radlWrap = new RadlClassification();        
        if(!radlClass.isEmpty() && !accountRadlMap.isEmpty()){
            for(Schema.PicklistEntry radl : radlClass){
                eventPerRadl = accountRadlMap.get(radl.getValue());
                //Calculate average as per RADL
                if(accountRadlMap.containsKey(radl.getValue()) && radl.getValue() == 'Develop'){
                    ((Decimal.valueOf(eventPerRadl.split(',')[1])));
                    /*radlWrap.develop = (Decimal.valueOf(eventPerRadl.split(',')[1])/
                                        Decimal.valueOf(eventPerRadl.split(',')[0])).setScale(2);*/
                        radlWrap.develop = null;
                    
                }
                else if(accountRadlMap.containsKey(radl.getValue()) && radl.getValue() == 'Acquire' ){                   
                    radlWrap.aquire = (Decimal.valueOf(eventPerRadl.split(',')[1])/
                                       Decimal.valueOf(eventPerRadl.split(',')[0])).setScale(2);
                }
                else if(accountRadlMap.containsKey(radl.getValue()) && radl.getValue() == 'Retain' ){
                    radlWrap.retain = (Decimal.valueOf(eventPerRadl.split(',')[1])/
                                       Decimal.valueOf(eventPerRadl.split(',')[0])).setScale(2);                  
                }
                else if(accountRadlMap.containsKey(radl.getValue()) && radl.getValue() == 'Light Touch' ){
                    radlWrap.lighttouch = (Decimal.valueOf(eventPerRadl.split(',')[1])/
                                           Decimal.valueOf(eventPerRadl.split(',')[0])).setScale(2); 
                }
             }
         }
        
        if(radlWrap != null){
            return JSON.serialize(radlWrap); 
        }
        else {
            return null;
        }
           
    }
    
    class RadlClassification{
        public Decimal develop {get;set;}
        public Decimal aquire {get;set;}
        public Decimal retain {get;set;}
        public Decimal lighttouch {get;set;}
        
        public RadlClassification(){
            this.develop = 0;
            this.aquire = 0;
            this.retain = 0;
            this.lighttouch = 0;
        }
    }
}