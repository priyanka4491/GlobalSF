@isTest
public class Frontier_LocationActivities_Test {
    
    public static testmethod void locationActivitiestest(){
        
        TestUtilClass.createTestAccount(5);
        TestUtilClass.createTask(5,'In Progress');
        Frontier_LocationActivities.getMyLocationRecords(13.082680,80.270718);
    }

}