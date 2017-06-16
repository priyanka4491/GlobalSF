public class Frontier_LocationActivities {
    @AuraEnabled
    public static list<task> getMyLocationRecords(decimal lati,decimal longi){
        system.debug('Latitude=>'+lati);
        system.debug('Longitude=>'+longi);
            List<Account> acc = Database.Query('Select Id,Name,(select Service_Level_Class_Descr__c From Business_Roles__r),(select Id,subject,Type,ActivityDate,Who.Name,Account.Name, Account.BillingCity, Account.BillingStreet,Account.BillingLatitude,Account.BillingLongitude,Status,priority from Tasks where Remind_me_at_Location__c = True and isClosed = False) from Account where Distance(BillingAddress,Geolocation('+lati+','+longi+'),\'mi\') < 30 limit 10');
        List<task> taskRecords = new List<task>();        
        for(Account accountRecords : acc ){
            for(Task tk:accountRecords.tasks)
                taskRecords.add(tk);
        }  
        system.debug('taskRecords=>'+taskRecords);

        return taskRecords;
    }
    
    @AuraEnabled
    public static list<Account> getCoverageAreaLocationRecords(decimal lati,decimal longi){
        system.debug('Latitude=>'+lati);
        system.debug('Longitude=>'+longi);
        List<Account> acc = Database.Query('Select Id,Name,BillingLongitude,BillingLatitude,(select Service_Level_Class_Descr__c From Business_Roles__r),(select Id,subject,Type,ActivityDate,Who.Name,Account.Name, Account.BillingCity, Account.BillingStreet,Account.BillingLatitude,Account.BillingLongitude,Status,priority from Tasks where Remind_me_at_Location__c = True and isClosed = False) from Account where Distance(BillingAddress,Geolocation('+lati+','+longi+'),\'mi\') < 30 limit 10');
        system.debug('taskRecords=>'+acc);
        return acc;
    }
}