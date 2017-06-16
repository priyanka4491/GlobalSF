public class TestAccountList {

    @AuraEnabled    
    public static String getAccounts() {
        
        return JSON.serialize([SELECT Name,Id From Account]);
    }
}