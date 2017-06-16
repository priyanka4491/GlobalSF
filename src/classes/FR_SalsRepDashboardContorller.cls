public class FR_SalsRepDashboardContorller {
    public static List<String> crops;
    public static List<String> seasons;
    Static {      
        seasons = new List<String>();
        crops = new List<String>();
        
		Schema.DescribeFieldResult fieldResult =  Account_Sales__c.Selling_Season_Descr__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();                   
        ple = fieldResult.getPicklistValues();        
        for(Schema.PicklistEntry f : ple){
            seasons.add(f.getValue());
        }
        ple.clear();
        fieldResult =  Account_Sales__c.Crop__c.getDescribe();
        ple = fieldResult.getPicklistValues();        
        for(Schema.PicklistEntry f : ple){
            crops.add(f.getValue());
        }
    }
    public static List<String> getFilterDetails()
    {
        List<String> accountSales = new List<String>();
        accountSales.add(JSON.serialize(seasons));
        accountSales.add(JSON.serialize(Crops));
        return accountSales;
    }
}