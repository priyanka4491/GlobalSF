public without sharing class CreateAccountActivity {
    @AuraEnabled
    public static List<String> getListItem() {
        List<String> lists = new List<String>();
        lists.add('Task');        
        return lists;
    }
}