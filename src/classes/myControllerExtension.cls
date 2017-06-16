public class myControllerExtension {

    private final Account acct;
    public List<Event> eventList {get;set;}
     public List<Event> allVisits {get;set;}
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public myControllerExtension(ApexPages.StandardController stdController) {
        this.acct = [SELECT Id FROM Account LIMIT 1];
        eventList = [SELECT Id,Type,ActivityDate,CreatedBy.Name,WhatId,What.Name FROM Event LIMIT 100];
        allVisits = [SELECT Id,Type,ActivityDate,CreatedBy.Name,WhatId,What.Name FROM Event];
    }

    public String getGreeting() {
        return 'Hello ' + acct.name + ' (' + acct.id + ')';
    }
}