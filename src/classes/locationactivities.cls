public with sharing class locationactivities {
    @AuraEnabled
    public static list<task> getMyLocationRecords(decimal lati,decimal longi){
        system.debug('Latitude=>'+lati);
        system.debug('Longitude=>'+longi);
            List<Account> acc = Database.Query('Select Id,Name,(select Id,subject, Who.Name, Account.Name, Account.BillingCity, Account.BillingStreet, Status,priority from Tasks where Remind_me_at_Location__c = True and isClosed = False) from Account where Distance(BillingAddress,Geolocation('+lati+','+longi+'),\'mi\') < 50 limit 10');
        List<task> taskRecords = new List<task>();        
        for(Account accountRecords : acc ){
            for(Task tk:accountRecords.tasks)
                taskRecords.add(tk);
        }        
        return taskRecords;
    }
}