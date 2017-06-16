public class ApexMemoryTest {
   /* public static void getAccounts(){
        string varsearchKey='%'+'%';
                Map<Id,Id> accountProgramMap = new Map<Id,Id>();
        List<AccountWrapper> accountListAfterSkip=new List<AccountWrapper>();

         for(Account_Program__c accPgm : [SELECT Id,Program__c,Accounts__c FROM Account_Program__c]){
            accountProgramMap.put(accPgm.Accounts__c,accPgm.Program__c);               
        }
         List<Account_Business_Role__c> accountRecordsList= [SELECT Account_SFID__c,Account_SFID__r.Name,SAP_ID__c,Service_Level_Class_Descr__c,                                
                                                                Role_Descr__c,Business_Unit_Descr__c, 
                                                                (SELECT Parent_SFID__r.Parent_SFID__r.Id,Parent_SFID__r.Parent_SFID__r.Street_Addr__c,Parent_SFID__r.Parent_SFID__r.City_Name__c,      
                                                                 Parent_SFID__r.Parent_SFID__r.State_Name__c,Parent_SFID__r.Parent_SFID__r.Country_Name__c,Parent_SFID__r.Role_Descr__c 
                                                                 FROM Account_Communications__r WHERE   Archive_Ind__c = 'N' AND  Parent_SFID__r.Archive_Ind__c = 'N' AND  
                                                                 Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N' AND RecordType.DeveloperName = 'Account_Communication_Address_Role_Business_Role'
                                                                 AND  Parent_SFID__r.Role_Descr__c = 'Business' LIMIT 1)
                                                                FROM    Account_Business_Role__c WHERE   Archive_Ind__c = 'N'AND Account_SFID__r.Archive_Ind__c = 'N' AND   Account_SFID__r.Name Like :varsearchKey];
        String progName1;
            for(Integer i = 0; i < accountRecordsList.size();i++){   
                progName1 = 'Untagged';
                if(!accountProgramMap.isEmpty()){                   
                    if(accountProgramMap.containskey(accountRecordsList[i].Account_SFID__c)){
                          system.debug('AccountSFIDddddddddddd'+accountRecordsList[i].Account_SFID__c+'AccountProgramMappp'+accountProgramMap);
                        progName1 = accountProgramMap.get(accountRecordsList[i].Account_SFID__c);                        
                    }                                       
                }
                Account_Business_Role__c abc;
                abc = accountRecordsList[i];
               abc = new Account_Business_Role__c();
                
                                accountListAfterSkip.add(new AccountWrapper(accountRecordsList[i],false));

            }
    }
    
    
    
    Public Class AccountWrapper {      
        
        public String Name{get;set;}
        public String accId{get;set;}
        public Account_Business_Role__c accountBusinessRole{get;set;}
        
        public String serviceLevelDesc{get;set;}  
        public String roleDesc{get;set;}
        public String sapId{get;set;} 
        
        public String accCommu{get;set;}
        public String streetAddress{get;set;}
        public String cityName{get;set;}
        public String stateName{get;set;}
        public String countryName{get;set;}
        public Boolean isSelected {get;set;}
        
        public Account_Communication__c accountCommunication {get;set;}
        
        public AccountWrapper(Account_Business_Role__c businessRole,Boolean selected)
        {
            this.isSelected = selected;
            businessRole = new Account_Business_Role__c();
           
            this.accountCommunication = new Account_Communication__c();
           // this.accountBusinessRole = (Account_Business_Role__c)JSON.deserialize(businessRole, Account_Business_Role__c.class);            
            this.Name=businessRole.Account_SFID__r.Name;
            this.accId = businessRole.Account_SFID__c;            
            this.serviceLevelDesc=businessRole.Service_Level_Class_Descr__c;
            this.roleDesc=businessRole.Role_Descr__c;
            this.sapId=businessRole.SAP_ID__C;
            this.accountCommunication = (businessRole.Account_Communications__r.isEmpty() ? Null : businessRole.Account_Communications__r[0] );
            this.accCommu= (businessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.Id);
            this.streetAddress=(businessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.Street_Addr__c);
            this.cityName=(businessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.City_Name__c);
            this.stateName=(businessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.State_Name__c);
            this.countryName=(businessRole.Account_Communications__r.isEmpty() ? Null :accountCommunication.Parent_SFID__r.Parent_SFID__r.Country_Name__c);
        }          
    }*/
}